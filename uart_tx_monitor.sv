package uart_tx_monitor_pkg;
  

  import uvm_pkg::*;
  import shared_pkg::*;
  import config_pkg::*;
  // import driver_pkg::*;        // contains Uart_rx_driver
  // import monitor_pkg::*;       // contains Uart_rx_monitor
  // import sequencer_pkg::*;     // contains Uart_rx_sequencer
  // import sequenceItem_pkg::*;  // contains Uart_rx_sequenceItem

  // import uart_tx_sequence_item::*;
  `include "uvm_macros.svh"


class Uart_tx_monitor extends uvm_monitor;
  `uvm_component_utils(Uart_tx_monitor)

  // Virtual UART‑TX interface
  virtual uart_tx_if txif;

  // Sequence item type produced by this monitor
  // Uart_tx_sequenceItem                 mon_seq_item;

  // Analysis port
  // uvm_analysis_port #(Uart_tx_sequenceItem) mon_port;

  // Baud period in clock cycles (obtain via cfg or default)
  int unsigned baud_cycles = 8680;

  //--------------------------------------------------------------------
  function new(string name = "Uart_tx_monitor",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_port = new("mon_port", this);

    if (!uvm_config_db#(virtual uart_tx_if)::get(this,"","txif",txif))
      `uvm_fatal("UART_TX_MON", "Cannot get virtual uart_tx_if")

    // Optional: override baud
    uvm_config_db#(int unsigned)::get(this,"","baud_cycles",baud_cycles);

    `uvm_info("UART_TX_MON", "Build phase completed", UVM_HIGH)
  endfunction

  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("UART_TX_MON", "Run phase started", UVM_HIGH)
    
  endtask
endclass
endpackage