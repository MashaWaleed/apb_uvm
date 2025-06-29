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

`define create_obj(type, name) type::type_id::create(name);

// driver class
class Ram_driver extends uvm_driver #(Ram_sequenceItem);
    `uvm_component_utils(Ram_driver)
    virtual Ram_interface v_if;
    Ram_sequenceItem stim_seq_item;

    function new(string name = "Ram_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("RAM Driver build Phase", get_full_name(), UVM_HIGH)
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // forever begin
        // end
        `uvm_info("RAM Driver run Phase", get_full_name(), UVM_HIGH)
    endtask //run_phase
endclass //Ram_driver extends uvm_driver
