`include "uvm_macros.svh"

package uart_rx_sequencer_pkg;

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import uart_rx_sequence_item_pkg::*;

class Uart_rx_sequencer extends uvm_sequencer #(uart_rx_item);
    `uvm_component_utils(Uart_rx_sequencer);

    function new(string name = "Uart_rx_sequencer",
                 uvm_component parent = null);
      super.new(name, parent);
    endfunction
  endclass
endpackage