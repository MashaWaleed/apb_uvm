package uart_tx_sequence_item_pkg;
import uvm_pkg::*;
import shared_pkg::*;
import config_pkg::*;

`include "uvm_macros.svh"

class uart_tx_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(uart_tx_sequence_item) // Register the class with UVM

    //constructor
    function new(string name = "uart_tx_sequence_item");
        super.new(name);
    endfunction

    // Declare the data members of the class
    rand bit [7:0] data;


endclass 
endpackage