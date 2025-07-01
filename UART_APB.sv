module UART_wrapper #(
    parameter DATA_BITS = 8,
    parameter PAR_TYP = 0,    // even parity
    parameter SB_TICK = 16,   // stop bit ticks
    parameter FIFO_DEPTH = 16, // how many things can fit in fifo
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ADDR_slave = 2'b01,
    parameter MY_PROT = 3'b000
)(
    // apb stuff
    input  logic PCLK,
    input  logic PRESETn,
    input  logic [ADDR_WIDTH-1:0] PADDR,
    input  logic [2:0] PPROT,
    input  logic PSELx,
    input  logic PENABLE,
    input  logic PWRITE,
    input  logic [DATA_WIDTH-1:0] PWDATA,
    input  logic [DATA_WIDTH/8-1:0] PSTRB,
    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic PSLVERR,
    output logic PREADY,

    // uart stuff
    input  logic rx,          // rx pin
    output logic tx          // tx pin
    //input  logic tick,        // baud tick
    //output logic rx_error     // rx messed up
);

    // internal signals
    logic [DATA_WIDTH-1:0] writeData;
    logic [DATA_WIDTH-1:0] address;
    logic write_read;
    logic enable;
    logic strb;
    logic ready;
    
    // uart fifo signals
    logic tx_fifo_wr_en;
    logic [DATA_BITS-1:0] tx_fifo_din;
    logic tx_fifo_full;
    logic rx_fifo_rd_en;
    logic [DATA_BITS-1:0] rx_fifo_dout;
    logic rx_fifo_empty;
    logic rx_error;

    // make apb slave
    APB_slave #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_slave(ADDR_slave),
        .MY_PROT(MY_PROT)
    ) apb_slave_2 (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PPROT(PPROT),
        .PSELx(PSELx),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),

        .ready(ready),
        .readData({24'b0, rx_fifo_dout}),  // extend 8-bit data to 32-bit

        .PRDATA(PRDATA),
        .PSLVERR(PSLVERR),
        .PREADY(PREADY),

        .writeData(writeData),
        .address(address),
        .write_read(write_read),
        .enable(enable),
        .strb(strb)
    );

    // make uart top
    uart_top #(
        .DATA_BITS(DATA_BITS),
        .PAR_TYP(PAR_TYP),
        .SB_TICK(SB_TICK),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) uart_top_inst (
        .clk(PCLK),
        .rst_n(PRESETn),
        .rx(rx),
        .tx(tx),
        .tx_fifo_wr_en(tx_fifo_wr_en),
        .tx_fifo_din(tx_fifo_din),
        .tx_fifo_full(tx_fifo_full),
        .rx_fifo_rd_en(rx_fifo_rd_en),
        .rx_fifo_dout(rx_fifo_dout),
        .rx_fifo_empty(rx_fifo_empty),
        .rx_error(rx_error)
    );

    // address map:
    // 0x00: TX FIFO data register (write only)
    // 0x04: TX FIFO status register (read only) - bit 0: full
    // 0x08: RX FIFO data register (read only)
    // 0x0C: RX FIFO status register (read only) - bit 0: empty, bit 1: error

    // handle writes
    always_comb begin
        tx_fifo_wr_en = 1'b0;
        tx_fifo_din = 8'b0;
        
        if (enable && write_read) begin
            case (address[3:0])
                4'h0: begin  // TX FIFO data
                    tx_fifo_wr_en = 1'b1;
                    tx_fifo_din = writeData[7:0];
                end
            endcase
        end
    end

    // handle reads
    always_comb begin
        rx_fifo_rd_en = 1'b0;
        ready = 1'b1;  // always ready for reads
        
        if (enable && !write_read) begin
            case (address[3:0])
                4'h4: begin  // TX FIFO status
                    ready = 1'b1;
                end
                4'h8: begin  // RX FIFO data
                    rx_fifo_rd_en = 1'b1;
                    ready = 1'b1;
                end
                4'hC: begin  // RX FIFO status
                    ready = (rx_error) ? 1'b0 : 1'b1;
                end
            endcase
        end
    end

endmodule 