package apb_driver_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
 
// Optional convenience macro
`define CREATE_OBJ(type,name) type::type_id::create(name)

class APB_driver extends uvm_driver #(APB_sequence_item);
  `uvm_component_utils(APB_driver)

  // Virtual interface
  virtual APB_interface apbif;

  // Constructor
  function new(string name = "APB_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual APB_interface)::get(this,"","apbif",apbif))
      `uvm_fatal("APB_DRV", "Cannot get virtual APB_interface")
    `uvm_info("APB_DRV", "Build phase completed", UVM_HIGH)
  endfunction

  // Run Phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    APB_sequence_item req;

    /*forever begin
      apb_item item;  // Declare a variable for the APB transaction item
      seq_item_port.get_next_item(item);  // Get next item from sequencer

      // Apply address and data to the APB interface
      apbif.psel = 1'b1;  // Select the APB device
      apbif.paddr = item.paddr;  // Apply address from the item
      apbif.pwdata = item.pwdata;  // Apply write data
      
      if (item.pwrite) begin
        apbif.pwrite = 1'b1;  // Set to write mode
      end else begin
        apbif.pwrite = 1'b0;  // Set to read mode
      end

      // Wait for some time to simulate APB timing
      repeat(4) @(posedge apbif.clk);
      
      seq_item_port.item_done();  // Mark the item as done, so sequencer can send the next one
    end*/
    `uvm_info("rx Driver run Phase", get_full_name(), UVM_HIGH)
  endtask

endclass
endpackage
