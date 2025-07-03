package apb_sequence_item_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;

class apb_sequence_item extends uvm_sequence_item;

  rand logic [ADDR_WIDTH-1:0]  PADDR;
  rand logic [2:0]             PPROT;
  rand logic                   PWRITE;  //(1 = write / 0 = read)
  rand logic [DATA_WIDTH-1:0]  PWDATA;
  rand logic [PSTRB_WIDTH-1:0] PSTRB;
  rand logic                   PSELx;   //optional when modelling bursts

  // fields set by the slave / monitor, NOT randomized
  logic [DATA_WIDTH-1:0]  PRDATA;
  logic                   slverr;    // PSLVERR
  logic                   PREADY;

  `uvm_object_utils(apb_sequence_item)

  function new(string name = "apb_sequence_item");
    super.new(name);
  endfunction

endclass
endpackage
