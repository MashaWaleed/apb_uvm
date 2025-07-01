package uart_tx_agent_pkg;
    
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;

    import uart_tx_monitor_pkg::*;
    import uart_tx_sequence_item_pkg::*; // contains uart_tx_item


class uart_tx_agent extends uvm_agent;

    virtual uart_tx_if txif;
    uart_tx_monitor mon;
    uart_tx_config cfg;

    uvm_analysis_port #(uart_tx_sequence_item) agt_port;

    `uvm_component_utils(uart_tx_agent)

    function new(string name = "tx_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = uart_tx_monitor::type_id::create("mon", this);
        agt_port = new("agt_port", this);
        cfg = uart_tx_config::type_id::create("cfg");

        if (!uvm_config_db#(uart_tx_config)::get(this, "", "tx", cfg))
        `uvm_fatal("build_phase","uart_TX_AGENT - Unable to retrieve uart_tx_config");

        `uvm_info("DEBUG", "uart_tx_agent build_phase completed", UVM_HIGH);
    endfunction

    //connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //connect interfaces for driver and monitor from cfg
        mon.txif = cfg.txif;
        //connect monitor to analysis port
        mon.mon_port.connect(agt_port);

    endfunction

endclass
endpackage
