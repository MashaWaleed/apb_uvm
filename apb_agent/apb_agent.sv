package apb_agent_pkg;
`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import apb_driver_pkg::*;
    import apb_sequencer_pkg::*;
    import apb_sequence_item_pkg::*;
    import apb_monitor_pkg::*;
    
class apb_agent extends uvm_agent;

    `uvm_component_utils(apb_agent);

    // Components
    APB_driver drv;
    apb_monitor mon;
    APB_sequencer seqr; 

    // Configuration
    APB_config cfg; 

    // Analysis port for external subscribers / scoreboard
    uvm_analysis_port #(apb_sequence_item) agt_port;

    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg = APB_config::type_id::create("cfg");

        // Create the driver, monitor, and sequencer
        drv = APB_driver::type_id::create("drv", this);
        mon = apb_monitor::type_id::create("mon", this);
        seqr = APB_sequencer::type_id::create("seqr", this);
        agt_port = new("agt_port", this);

        `uvm_info("APB_AGENT", "Build phase done.", UVM_HIGH)

        if(!uvm_config_db#(APB_config)::get(this, "", "apb", cfg))
            `uvm_fatal("build_phase", "APB_AGENT - Unable to get virtual APB_interface for driver");

    endfunction

    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect interfaces for driver and monitor from cfg

        drv.apbif = cfg.apbif;
        mon.apbif = cfg.apbif;

        // Connect the driver and sequencer
        drv.seq_item_port.connect(seqr.seq_item_export);
    

        // Connect monitor to analysis port
        mon.mon_port.connect(agt_port);
        `uvm_info("APB_AGENT", "Connect phase done.", UVM_HIGH)
    endfunction
endclass
endpackage
