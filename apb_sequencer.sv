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


class APB_sequencer extends uvm_sequencer #(APB_sequenceItem);
    `uvm_component_utils(APB_sequencer)

    function new(string name = "APB_sequencer",
                 uvm_component parent = null);
      super.new(name, parent);
    endfunction
  endclass