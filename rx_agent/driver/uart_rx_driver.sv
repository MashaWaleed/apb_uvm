package uart_rx_driver_pkg;
  

`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import uart_rx_sequence_item_pkg::*;
  
class Uart_rx_driver extends uvm_driver #(uart_rx_item);
  `uvm_component_utils(Uart_rx_driver);

  // Virtual UART RX interface
  virtual uart_rx_if rxif;

  //--------------------------------------------------------------------
  function new(string name="Uart_rx_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_rx_if)::get(this,"","rxif",rxif))
      `uvm_fatal("UART_RX_DRV","Cannot get virtual uart_rx_if")
    // Optionally fetch baud from cfg
  endfunction

  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    /*
    forever begin
    Uart_rx_sequence_item req;
    seq_item_port.get_next_item(item);

    // Send start bit (logic 0)
    rxif.tx = 1'b0;
    @(posedge rxif.clk); // 1 clock per bit 

    // Send 8 data bits (LSB first)
    for (int i = 0; i < 8; i++) begin
      rxif.tx = item.data[i];  // Send each bit
      @(posedge rxif.clk);
    end

    // Send stop bit (logic 1)
    rxif.tx = 1'b1;
    @(posedge rxif.clk);

    seq_item_port.item_done(); // Mark the item as done, so sequencer can send the next one
  end
  */
    `uvm_info("UART_RX_DRV", "Run phase started", UVM_HIGH);
  endtask
endclass

endpackage