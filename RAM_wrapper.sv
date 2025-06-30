module RAM_wrapper #(
    parameter ADDR_WIDTH = 16, // Address width
    parameter DATA_WIDTH = 32,  // Data width
    parameter MY_PROT = 3'b000,
    parameter ADDR_slave = 2'b00
)(
    // APB Interface
    input  logic        PCLK,       // APB clock
    input  logic        PRESETn,    // APB reset (active low)
    input  logic        PSEL,       // APB select
    input  logic        PENABLE,    // APB enable
    input  logic        PWRITE,     // APB write enable
    input  logic [ADDR_WIDTH-1:0] PADDR,      // APB address
    input  logic [DATA_WIDTH-1:0] PWDATA,     // APB write data
    input  logic [3:0]  PSTRB,      // APB byte enable
    input  logic [2:0]  PPROT,      // APB protection
    output logic [DATA_WIDTH-1:0] PRDATA,     // APB read data
    output logic        PREADY,     // APB ready signal
    output logic        PSLVERR    // APB error signal
    );
    // RAM Interface
    logic        ram_clk;
    logic        ram_rstn;
    logic        enable;
    logic        ram_write_en;
    logic        ram_ready;
    logic [3:0]  strb;
    logic [31:0] ram_addr;
    logic [31:0] ram_wdata;
    logic [31:0] ram_rdata;

    // Instantiate the RAM module
    RAM #(
        .SIZE(1024), // Size of the RAM
        .WIDTH(32)   // Width of the RAM
    ) ram_inst (
        //memory inputs
        .clk(ram_clk),
        .rst_n(ram_rstn),
        .enable(enable),
        .we(ram_write_en),
        .addr(ram_addr),
        .din(ram_wdata),
        .pstrb(strb),

        .ready(ram_ready),
        .dout(ram_rdata)
    );

    // instantiate APB interface 
    APB_slave #(.ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MY_PROT(MY_PROT),
        .ADDR_slave(ADDR_slave))
        apb_slave_0 (
        //inputs from master to slave
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSELx(PSELx),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PPROT(PPROT),

        //inputs from peripheral to slave
        .ready(ram_ready),
        .readData(ram_rdata),

        //outputs from slave to master
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR),

        //outputs from slave to peripheral
        .writeData(ram_wdata),
        .address(ram_addr),
        .write_read(ram_write_en),
        .enable(enable),
        .strb(strb)
    );




endmodule