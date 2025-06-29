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

`define create_obj(type, name) type::type_id::create(name, this);

// sequencer class
class sequencer extends uvm_sequencer #(Ram_sequenceItem);
    `uvm_component_utils(sequencer)
    function new(string name = "sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
endclass //sequencer extends uvm_sequencer #(Ram_sequenceItem)
