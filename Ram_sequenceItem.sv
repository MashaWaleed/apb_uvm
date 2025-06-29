package Ram_sequenceItem_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`define create_obj(type, name) type::type_id::create(name, this);

// Sequence Item class Valid and Invalid
class Ram_sequenceItem extends uvm_sequence_item;
    `uvm_object_utils(Ram_sequenceItem) 
    logic [ADDR_WIDTH-1 : 0] addr;
    logic [DATA_WIDTH-1 : 0] data;
    logic wr;
endclass //Ram_sequenceItem extends uvm_sequence_item
endpackage