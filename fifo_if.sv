interface fifo_if #(parameter width = 8, parameter depth = 16) (
    input  logic clk,
    input  logic rst_n
);
    logic wr_en;           // write enable
    logic rd_en;           // read enable
    logic [width-1:0] din; // data in
    
    logic [width-1:0] dout;// data out
    logic full;            // full flag
    logic empty;           // empty flag
endinterface
