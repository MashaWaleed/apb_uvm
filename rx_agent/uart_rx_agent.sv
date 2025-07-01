 `include "uvm_macros.svh"

package uart_rx_agent_pkg;
  import uvm_pkg::*;
  import shared_pkg::*;
  import config_pkg::*;
 
  import uart_rx_driver_pkg::*;
  import uart_rx_sequencer_pkg::*;
  import uart_rx_sequence_item_pkg::*;
  import uart_rx_monitor_pkg::*;

  class uart_rx_agent extends uvm_agent;

    uart_rx_sequencer sqr;
    uart_rx_driver drv;
    uart_rx_monitor mon;

    uart_rx_config cfg;
    virtual uart_rx_if rxif;

    uvm_analysis_port #(uart_rx_sequence_item) agt_port;

    `uvm_component_utils(uart_rx_agent)

    //--------------------------------------------------------------------
    function new(string name = "uart_rx_agent",uvm_component parent = null);
      super.new(name, parent);
    endfunction

    //--------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      cfg = uart_rx_config::type_id::create("cfg");
      sqr = uart_rx_sequencer::type_id::create("sqr", this);
      drv = uart_rx_driver::type_id::create("drv", this);
      agt_port = new("agt_port", this);


      if (!uvm_config_db#(uart_rx_config)::get(this, "", "rx", cfg))
        `uvm_fatal("build_phase","UART_RX_AGENT - Unable to retrieve uart_rx_config");

      `uvm_info("UART_RX_AGENT", "Build phase done.", UVM_HIGH);
    endfunction

    //--------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
      drv.rxif = cfg.rxif;
      mon.rxif = cfg.rxif;

      drv.seq_item_port.connect(sqr.seq_item_export);

      `uvm_info("UART_RX_AGENT", "Connect phase done.", UVM_HIGH);
    endfunction

  endclass

endpackage