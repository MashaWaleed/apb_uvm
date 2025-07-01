package apb_driver_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import apb_sequence_item_pkg::*;

class apb_driver extends uvm_driver #(apb_sequence_item);

  virtual APB_interface apbif;
  apb_config cfg;

  `uvm_component_utils(apb_driver)

  // Constructor
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = apb_config::type_id::create("cfg");

    if (!uvm_config_db#(apb_config)::get(this,"","apb",cfg)) //retrieving only the interface not full config object
      `uvm_fatal("apb_DRV", "Cannot get virtual apb_interface")

    `uvm_info("apb_DRV", "Build phase completed", UVM_HIGH)
  endfunction

  // Run Phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    apbif = cfg.apbif;
    // apb_sequence_item req;

    /*forever begin
      apb_item item;  // Declare a variable for the apb transaction item
      seq_item_port.get_next_item(item);  // Get next item from sequencer

      // Apply address and data to the apb interface
      apbif.psel = 1'b1;  // Select the apb device
      apbif.paddr = item.paddr;  // Apply address from the item
      apbif.pwdata = item.pwdata;  // Apply write data
      
      if (item.pwrite) begin
        apbif.pwrite = 1'b1;  // Set to write mode
      end else begin
        apbif.pwrite = 1'b0;  // Set to read mode
      end

      // Wait for some time to simulate apb timing
      repeat(4) @(posedge apbif.clk);
      
      seq_item_port.item_done();  // Mark the item as done, so sequencer can send the next one
    end*/

    `uvm_info("rx Driver run Phase", get_full_name(), UVM_HIGH)
  endtask

endclass
endpackage
