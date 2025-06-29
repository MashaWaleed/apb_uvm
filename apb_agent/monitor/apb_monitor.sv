package apb_monitor_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import apb_sequence_item_pkg::*;

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  // Virtual APB interface
  virtual APB_interface apbif;

  // Sequence item type produced by this monitor
  apb_sequence_item                mon_seq_item;

  // Analysis port for scoreboards / subscribers
  uvm_analysis_port #(apb_sequence_item) mon_port;

  //------------------------------------------------------------
  function new(string name = "APB_monitor",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the analysis port
    mon_port = new("mon_port", this);

    // Get virtual interface
    if (!uvm_config_db#(virtual APB_interface)::get(this,"","apbif",apbif))
      `uvm_fatal("APB_MON", "Cannot get virtual APB_interface")

    `uvm_info("APB_MON", "Build phase completed", UVM_HIGH)
  endfunction

  //------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("APB_MON", "Run phase", UVM_HIGH)
/*
    forever begin
      apb_item item = apb_item::type_id::create("item");

      @(posedge apbif.clk);
      if (apbif.psel && apbif.penable) begin
        item.paddr = apbif.paddr;
        item.pwrite = apbif.pwrite;
        item.pwdata = apbif.pwrite ? apbif.pwdata : 'x;
        item.prdata = !apbif.pwrite ? apbif.prdata : 'x;

        ap.write(item);
      end
    end
    */

  endtask
endclass
endpackage
