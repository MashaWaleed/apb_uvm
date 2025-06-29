package apb_sequencer_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import apb_sequence_item_pkg::*;


class APB_sequencer extends uvm_sequencer #(apb_sequence_item);
    `uvm_component_utils(APB_sequencer)

    function new(string name = "APB_sequencer",
                 uvm_component parent = null);
      super.new(name, parent);
    endfunction
  endclass

endpackage
