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

    // Components
    apb_driver drv;
    apb_monitor mon;
    apb_sequencer seqr; 

    apb_config cfg; 
    virtual APB_interface apbif;

    uvm_analysis_port #(apb_sequence_item) agt_port;

    `uvm_component_utils(apb_agent);
//--------------------------------------------------------------
    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
//--------------------------------------------------------------
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg = apb_config::type_id::create("cfg");
        drv = apb_driver::type_id::create("drv", this);
        mon = apb_monitor::type_id::create("mon", this);
        seqr = apb_sequencer::type_id::create("seqr", this);
        agt_port = new("agt_port", this);

        if(!uvm_config_db#(apb_config)::get(this, "", "apb", cfg))
            `uvm_fatal("build_phase", "apb_AGENT - Unable to get virtual apb_interface ");
        
        `uvm_info("apb_AGENT", "Build phase done.", UVM_HIGH)

    endfunction
//-----------------------------------------------------------------
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
        //mon_port: analysis port of the monitor class

        `uvm_info("APB_AGENT", "Connect phase done.", UVM_HIGH)
    endfunction
endclass
endpackage
