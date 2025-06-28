interface APB_interface(
    input clk
);
    // logic PCLK;
    logic PRESETn;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic [2:0] PPROT;
    logic PSELx;
    logic PENABLE;
    logic PWRITE;

    logic [DATA_WIDTH-1:0] PWDATA;
    logic [PSTRB_WIDTH-1:0] PSTRB;

    //inputs from Periphral to Slave 
    logic ready;
    logic [DATA_WIDTH-1:0] readData;

    //outputs from Slave to Master
    logic [DATA_WIDTH-1:0] PRDATA;
    logic PSLVERR;

    logic PREADY;


    //outputs from Slave to Periphral
    logic [DATA_WIDTH-1:0]writeData;
    logic address;

    logic write_read;
    logic enable;
    logic strb;
endinterface