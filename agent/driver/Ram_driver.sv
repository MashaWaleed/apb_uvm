`timescale 1ps/1ps
package Ram_driver_pkg;
import shared_pkg::*;
import Ram_sequenceItem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

// driver class
class Ram_driver extends uvm_driver #(Ram_sequenceItem);
    `uvm_component_utils(Ram_driver)
    virtual Ram_interface v_if;
    Ram_sequenceItem item;

    function new(string name = "Ram_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("RAM Driver build Phase", get_full_name(), UVM_HIGH)
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        item = Ram_sequenceItem::type_id::create("item");
        // forever begin
        // end
        `uvm_info("RAM Driver run Phase", get_full_name(), UVM_HIGH)
    endtask //run_phase
endclass //Ram_driver extends uvm_driver
    
endpackage