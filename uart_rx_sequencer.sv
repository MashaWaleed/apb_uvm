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


class Uart_rx_sequencer extends uvm_sequencer #(Uart_rx_sequenceItem);
    `uvm_component_utils(Uart_rx_sequencer)

    function new(string name = "Uart_rx_sequencer",
                 uvm_component parent = null);
      super.new(name, parent);
    endfunction
  endclass