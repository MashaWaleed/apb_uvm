import shared_pkg::*;
interface fifo_if (
    input clk
);
    /* input */ logic rst_n;
    /* input */ logic wr_en;                    // write enable
    /* input */ logic rd_en;                    // read enable
    /* input */ logic [DATA_WIDTH-1 : 0] din;   // data in
    
    /* output */ logic [DATA_WIDTH-1 : 0] dout; // data out
    /* output */ logic full;                    // full flag
    /* output */ logic empty;                   // empty flag
endinterface
