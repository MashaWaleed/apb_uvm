`timescale 1ps/1ps
`include "uvm_macros.svh"

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import driver_pkg::*;
    import sequencer_pkg::*;
    import sequenceItem_pkg::*;
    import monitor_pkg::*;

class apb_agent extends uvm_agent;

    `uvm_component_utils(apb_agent);

    // Components
    apb_driver drv;
    apb_monitor mon;
    apb_sequencer seqr; 

    // Configuration
    apb_config cfg; 
    // Analysis port for external subscribers / scoreboard
    uvm_analysis_port #(apb_sequenceItem) agt_port;

    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Retrieve configuration from the UVM config database
        if (!uvm_config_db#(apb_config)::get(this, "", "CFG", cfg))
            `uvm_fatal("build_phase", "APB_AGENT - Unable to retrieve apb_config")

        // Create the driver, monitor, and sequencer
        drv = apb_driver::type_id::create("drv", this);
        mon = apb_monitor::type_id::create("mon", this);
        seqr = apb_sequencer::type_id::create("seqr", this);
        agt_port = new("agt_port", this);

        `uvm_info("APB_AGENT", "Build phase done.", UVM_HIGH)
    endfunction

    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect interfaces for driver and monitor from cfg
        drv.apbif = cfg.apbif;
        mon.apbif = cfg.apbif;

        // Connect the driver and sequencer
        if (drv != null && seqr != null) begin
            seqr.seq_item_port.connect(drv.seq_item_export);
            `uvm_info("DEBUG", "apb_agent connect_phase completed", UVM_HIGH)
        end else begin
            `uvm_fatal("APB_AGENT", "Driver or Sequencer is null in connect_phase")
        end

        // Connect monitor to analysis port
        mon.analysis_port.connect(agt_port);
        `uvm_info("APB_AGENT", "Connect phase done.", UVM_HIGH)
    endfunction
endclass