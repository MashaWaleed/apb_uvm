package apb_monitor_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import apb_sequence_item_pkg::*;

class apb_monitor extends uvm_monitor;

  virtual APB_interface apbif;
  apb_config cfg;

  uvm_analysis_port #(apb_sequence_item) mon_port;

  `uvm_component_utils(apb_monitor)

  //------------------------------------------------------------
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = apb_config::type_id::create("cfg");
    mon_port = new("mon_port", this);

    // Get virtual interface
    if (!uvm_config_db#(apb_config)::get(this,"","apb",cfg))
      `uvm_fatal("apb_MON", "Cannot get virtual apb_interface")

    `uvm_info("apb_MON", "Build phase completed", UVM_HIGH)
  endfunction

  //------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("apb_MON", "Run phase", UVM_HIGH)


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
