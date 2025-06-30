module top #(
    parameter ADDR_WIDTH = 16, // Address width
    parameter DATA_WIDTH = 32  // Data width
)(
    //APB Interface
    input  logic        PCLK,       // APB clock
    input  logic        PRESETn,    // APB reset (active low)
    input  logic [3:0]  PSEL,       // APB select
    input  logic        PENABLE,    // APB enable
    input  logic        PWRITE,     // APB write enable
    input  logic [ADDR_WIDTH-1:0] PADDR,      // APB address
    input  logic [DATA_WIDTH-1:0] PWDATA,     // APB write data
    input  logic [3:0]  PSTRB,      // APB byte enable
    input  logic [2:0]  PPROT,      // APB protection
    output logic [DATA_WIDTH-1:0] PRDATA,     // APB read data
    output logic        PREADY,     // APB ready signal
    output logic        PSLVERR,    // APB error signal

    //uart I/O
    input  logic        uart_rx,
    output logic        uart_tx
);

RAM_wrapper #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MY_PROT(3'b000),
    .ADDR_slave(2'b00) // Address space for RAM
    )
    RAM_block(
    // APB Interface
    .PCLK(PCLK),       // APB clock
    .PRESETn(PRESETn), // APB reset (active low)
    .PSEL(PSEL[0]),       // APB select
    .PENABLE(PENABLE), // APB enable
    .PWRITE(PWRITE),   // APB write enable
    .PADDR(PADDR),     // APB address
    .PWDATA(PWDATA),   // APB write data
    .PSTRB(PSTRB),     // APB byte enable
    .PPROT(PPROT),     // APB protection
    .PRDATA(PRDATA),   // APB read data
    .PREADY(PREADY),   // APB ready signal
    .PSLVERR(PSLVERR)  // APB error signal
    );



UART_wrapper #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MY_PROT(3'b000),
    .ADDR_slave(2'b01)
    ) UART_block(     // Address space for RAM)
    // APB Interface
    .PCLK(PCLK),       // APB clock
    .PRESETn(PRESETn), // APB reset (active low)
    .PSEL(PSEL[1]),       // APB select
    .PENABLE(PENABLE), // APB enable
    .PWRITE(PWRITE),   // APB write enable
    .PADDR(PADDR),     // APB address
    .PWDATA(PWDATA),   // APB write data
    .PSTRB(PSTRB),     // APB byte enable
    .PPROT(PPROT),     // APB protection
    .PRDATA(PRDATA),   // APB read data
    .PREADY(PREADY),   // APB ready signal
    .PSLVERR(PSLVERR),  // APB error signal

    // UART Interface
    .uart_rx(uart_rx),  // UART receive
    .uart_tx(uart_tx)   // UART transmit
);

endmodule