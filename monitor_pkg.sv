package monitor_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import config_pkg::*;

    `include "uvm_macros.svh"

    `include "uart_tx_monitor.sv"
    `include "apb_monitor.sv"
    `include "Ram_monitor.sv"
endpackage