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

class apb_item extends uvm_sequence_item;

  // Indicates read or write (1 = write, 0 = read)
  rand bit        pwrite;

  // Address to access (typically 8-bit or 32-bit)
  rand bit [7:0]  paddr;

  // Write data (if pwrite == 1)
  rand bit [7:0]  pwdata;

  // Read data (if pwrite == 0, filled by monitor)
  bit [7:0]       prdata;

  `uvm_object_utils(apb_item)

  function new(string name = "apb_item");
    super.new(name);
  endfunction

endclass
