import shared_pkg::*; // Import shared package for constants

interface RAM_interface;
    logic clk;                  // Clock signal
    logic rst_n;                // Active low reset
    logic enable;                //enable read and write
    logic we;                   // Write enable
    logic [ADDR_WIDTH-1:0] addr; // Address bus
    logic [DATA_WIDTH-1:0] din;      // Data input
    logic [(DATA_WIDTH/8)-1:0] strb;   // Byte enable
    logic ready;               // Ready signal
    logic [DATA_WIDTH-1:0] dout;     // Data output

    modport DUT (
        input clk, rst_n, enable, we, addr, din, strb,
        output ready, dout
    );
    modport TEST (
        input ready, dout,
        output clk, rst_n, enable, we, addr, din, strb
    );
endinterface //RAM_interface