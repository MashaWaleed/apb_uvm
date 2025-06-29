package shared_pkg;
    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;
    parameter PSTRB_WIDTH = DATA_WIDTH/8;
    parameter CLK_PERIOD = 2; // Clock period in nanoseconds
    parameter RESET_TIME = 10; // Reset time in nanoseconds
endpackage