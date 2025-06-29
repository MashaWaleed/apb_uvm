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
// monitor
class Ram_monitor extends uvm_monitor;
    `uvm_component_utils(Ram_monitor)
    virtual Ram_interface v_if;
    Ram_sequenceItem mon_seq_item;
    uvm_analysis_port #(Ram_sequenceItem) mon_port; // monitor is a port

    function new(string name = "Ram_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_port = new("mon_port", this);
        `uvm_info("RAM Monitor build Phase", get_full_name(), UVM_HIGH)
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    //   forever begin
    //   end
        `uvm_info("RAM Monitor run Phase", get_full_name(), UVM_HIGH)
    endtask //run_pha
endclass //Ram_monitor extends uvm_monitor
