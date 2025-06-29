`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import driver_pkg::*;
    import sequencer_pkg::*;
    import sequenceItem_pkg::*;
    import monitor_pkg::*;

class apb_uart_env extends uvm_env;
    `uvm_component_utils(apb_uart_env);

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction


endclass