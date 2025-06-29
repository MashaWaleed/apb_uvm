
package uart_rx_agent_pkg;
  import uvm_pkg::*;
  import shared_pkg::*;
  import config_pkg::*;
  `include "uvm_macros.svh"
  import uart_rx_driver_pkg::*;
  import uart_rx_sequencer_pkg::*;
  import uart_rx_sequence_item_pkg::*;

  class Uart_rx_agent extends uvm_agent;
    `uvm_component_utils(Uart_rx_agent)

    Uart_rx_sequencer                     sqr;
    Uart_rx_driver                        drv;
    // Uart_rx_monitor                       mon;
    Uart_rx_config                        cfg;

    uvm_analysis_port #(Uart_rx_sequenceItem) agt_port;

    //--------------------------------------------------------------------
    function new(string name = "Uart_rx_agent",
                 uvm_component parent = null);
      super.new(name, parent);
    endfunction

    //--------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if (!uvm_config_db#(Uart_rx_config)::get(this, "", "CFG", cfg))
        `uvm_fatal("build_phase",
                   "UART_RX_AGENT - Unable to retrieve Uart_rx_config")

      sqr      = `CREATE_OBJ(Uart_rx_sequencer, "sqr");
      drv      = `CREATE_OBJ(Uart_rx_driver,    "drv");
      agt_port = new("agt_port", this);

      `uvm_info("UART_RX_AGENT", "Build phase done.", UVM_HIGH)
    endfunction

    //--------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
      drv.rxif = cfg.rxif;
      drv.seq_item_port.connect(sqr.seq_item_export);

      `uvm_info("UART_RX_AGENT", "Connect phase done.", UVM_HIGH)
    endfunction

  endclass

endpackage