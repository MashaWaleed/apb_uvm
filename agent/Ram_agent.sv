`timescale 1ps/1ps
package Ram_agent_pkg;
    import shared_pkg::*;
    import config_pkg::*;
    import Ram_driver_pkg::*;
    import Ram_sequencer_pkg::*;
    import Ram_sequenceItem_pkg::*;
    import Ram_monitor_pkg::*;
    import uvm_pkg::*;

`include "uvm_macros.svh"
`define create_obj(type, name) type::type_id::create(name, this);

// agent class
class Ram_agent extends uvm_agent;
    `uvm_component_utils(Ram_agent)
    sequencer sqr; // mange data transfer
    Ram_driver drv; // inside agent 
    Ram_monitor mon; // inside agent 
    Ram_config cfg; // get the data of interface
    uvm_analysis_port #(Ram_sequenceItem) agt_port; // agent is a port

    function new(string name = "Ram_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // if (!uvm_config_db#(Ram_config)::get(this, "", "CFG", cfg))
        //     `uvm_fatal("build_phase", "AGENT - Unable to get config");

        if (cfg.Ram_agent_isActive == UVM_ACTIVE) begin
            sqr = sequencer::type_id::create("sqr", this);
            drv = Ram_driver::type_id::create("drv", this);
        end

        mon = Ram_monitor::type_id::create("mon", this);

        agt_port = new("agt_port", this);
        `uvm_info("RAM Agent Build Phase", get_full_name(), UVM_HIGH)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        if (cfg.Ram_agent_isActive == UVM_ACTIVE) begin
            drv.v_if = cfg.v_if;
            drv.seq_item_port.connect(sqr.seq_item_export);
        end

        mon.v_if = cfg.v_if;
        mon.mon_port.connect(agt_port);
        `uvm_info("RAM Agent connect Phase", get_full_name(), UVM_HIGH)
    endfunction //connect_phase
endclass //Ram_agent extends uvm_agent
endpackage