package uart_tx_monitor_pkg;
  

  import uvm_pkg::*;
  import shared_pkg::*;
  import config_pkg::*;
  import uart_tx_sequence_item_pkg::*;  // contains uart_tx_item

  // import uart_tx_sequence_item::*;
  `include "uvm_macros.svh"


class uart_tx_monitor extends uvm_monitor;
  `uvm_component_utils(uart_tx_monitor)

  // Virtual uart‑TX interface
  virtual uart_tx_if txif;
  uvm_analysis_port #(uart_tx_sequence_item) mon_port;

  //--------------------------------------------------------------------
  function new(string name = "uart_tx_monitor",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_port = new("mon_port", this);

    if (!uvm_config_db#(virtual uart_tx_if)::get(this,"","txif",txif))
      `uvm_fatal("uart_TX_MON", "Cannot get virtual uart_tx_if")
      
    `uvm_info("uart_TX_MON", "Build phase completed", UVM_HIGH)
  endfunction

  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("uart_TX_MON", "Run phase started", UVM_HIGH)
    
  endtask
endclass
endpackage