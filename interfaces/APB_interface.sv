import shared_pkg::*;
interface APB_interface(
    input clk
);
    /* input */ logic PRESETn;
    /* input */ logic [ADDR_WIDTH-1:0] PADDR;
    /* input */ logic [2:0] PPROT;
    /* input */ logic PSELx;
    /* input */ logic PENABLE;
    /* input */ logic PWRITE;

    /* input */ logic [DATA_WIDTH-1:0] PWDATA;
    /* input */ logic [PSTRB_WIDTH-1:0] PSTRB;

    //outputs from Slave to Master
    /* output */ logic [DATA_WIDTH-1:0] PRDATA;
    /* output */ logic PSLVERR;
    /* output */ logic PREADY;
endinterface