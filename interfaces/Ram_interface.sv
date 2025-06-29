import shared_pkg::*;
interface Ram_interface (
    input clk
);
    /* input */ logic [ADDR_WIDTH-1 : 0] addr;
    /* input */ logic [DATA_WIDTH-1 : 0] wr_data;
    /* input */ logic wr;
    /* output */ logic [DATA_WIDTH-1 : 0] rd_data;
endinterface