package uart_rx_monitor_pkg;
  
  import uvm_pkg::*;
  import shared_pkg::*;
  import config_pkg::*;
  import uart_rx_sequence_item_pkg::*;  // contains uart_rx_item

  // import uart_rx_sequence_item::*;
  `include "uvm_macros.svh"

class Uart_rx_monitor extends uvm_monitor;
  `uvm_component_utils(Uart_rx_monitor);

  // Virtual UART‑rx interface
  virtual uart_rx_if rxif;

  // Sequence item type produced by this monitor
  // Uart_rx_sequenceItem                 mon_seq_item;

  // Analysis port
   uvm_analysis_port #(uart_rx_item) mon_port;

  //--------------------------------------------------------------------
  function new(string name = "Uart_rx_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_port = new("mon_port", this);

    if (!uvm_config_db#(virtual uart_rx_if)::get(this,"","rxif",rxif))
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