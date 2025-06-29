package uart_tx_agent_pkg;
    
endpackage
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    // import uart_tx_driver_pkg::*;
    // import uart_tx_sequencer_pkg::*;
    // import uart_tx_sequence_item_pkg::*;
    import uart_tx_monitor_pkg::*;


class uart_tx_agent extends uvm_agent;
 
    `uvm_component_utils(uart_tx_agent);

    //components
    // uart_tx_driver drv;
    uart_tx_monitor mon;
    // uart_tx_sequencer seqr;
    uart_tx_config cfg;

     // Analysis port for external subscribers / scoreboard
    uvm_analysis_port #(Uart_tx_sequenceItem) agt_port;

    function new(string name = "tx_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(Uart_tx_config)::get(this, "", "CFG", cfg))
        `uvm_fatal("build_phase",
                   "UART_TX_AGENT - Unable to retrieve Uart_tx_config")

        // Create the monitor, and sequencer
        mon = uart_tx_monitor::type_id::create("mon", this);
        //seqr = uart_tx_sequencer::type_id::create("seqr", this);
        agt_port = new("agt_port", this);

        `uvm_info("DEBUG", "uart_tx_agent build_phase completed", UVM_HIGH)
    endfunction

    //connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //connect interfaces for driver and monitor from cfg
        mon.txif = cfg.txif;
        //connect monitor to analysis port
        mon.analysis_port.connect(agt_port);

    endfunction

endclass
