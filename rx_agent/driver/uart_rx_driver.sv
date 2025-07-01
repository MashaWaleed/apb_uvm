package uart_rx_driver_pkg;
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import uart_rx_sequence_item_pkg::*;
  
class uart_rx_driver extends uvm_driver #(uart_rx_sequence_item);
  `uvm_component_utils(uart_rx_driver);

  // Virtual uart RX interface
  virtual uart_rx_if rxif;
  uart_rx_config cfg;

  //--------------------------------------------------------------------
  function new(string name="uart_rx_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = uart_rx_config::type_id::create("cfg");

    if (!uvm_config_db#(uart_rx_config)::get(this,"","rx",cfg))
      `uvm_fatal("UART_RX_DRV","Cannot get virtual uart_rx_if")
    
  endfunction

  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    rxif = cfg.rxif;
    
    /*
    forever begin
    uart_rx_sequence_item req;
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
    `uvm_info("uart_RX_DRV", "Run phase started", UVM_HIGH);
  endtask
endclass

endpackage