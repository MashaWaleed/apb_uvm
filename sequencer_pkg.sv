package sequencer_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import config_pkg::*;
    
    `include "uvm_macros.svh"

    `include "apb_sequencer.sv"
    `include "uart_rx_sequencer.sv" 
    `include "Ram_sequencer.sv"
endpackage