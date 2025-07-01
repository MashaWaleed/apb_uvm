`include "uvm_macros.svh"

package uart_rx_sequence_item_pkg;
  
   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;

class uart_rx_sequence_item extends uvm_sequence_item;

  // Declare the properties of the item

  // Received data from DUT
  rand bit [7:0] data;

  // Register this object with the factory
  `uvm_object_utils(uart_rx_sequence_item);

  // Constructor
  function new(string name = "uart_rx_sequence_item");
    super.new(name);
  endfunction

endclass
endpackage