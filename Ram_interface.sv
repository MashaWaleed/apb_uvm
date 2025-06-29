interface Ram_interface;
    logic [ADDR_WIDTH-1 : 0] addr;
    logic [DATA_WIDTH-1 : 0] wr_data;
    logic [DATA_WIDTH-1 : 0] rd_data;
    logic wr;
endinterface