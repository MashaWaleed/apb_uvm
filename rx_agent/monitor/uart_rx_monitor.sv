package uart_rx_monitor_pkg;
  
  import uvm_pkg::*;
  import shared_pkg::*;
  import config_pkg::*;
  import uart_rx_sequence_item_pkg::*;  // contains uart_rx_item

  // import uart_rx_sequence_item::*;
  `include "uvm_macros.svh"

class uart_rx_monitor extends uvm_monitor;
  `uvm_component_utils(uart_rx_monitor);

  // Virtual uART‑rx interface
  virtual uart_rx_if rxif;
  uart_rx_config cfg;

  // Analysis port
   uvm_analysis_port #(uart_rx_sequence_item) mon_port;

  //--------------------------------------------------------------------
  function new(string name = "uart_rx_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_port = new("mon_port", this);
    cfg = uart_rx_config::type_id::create("cfg");

    if (!uvm_config_db#(uart_rx_config)::get(this,"","rx",cfg))
      `uvm_fatal("UART_rx_MON", "Cannot get virtual uart_rx_if");

    `uvm_info("UART_rx_MON", "Build phase completed", UVM_HIGH);
  endfunction

  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("UART_rx_MON", "Run phase started", UVM_HIGH);
    
  endtask
endclass
endpackage