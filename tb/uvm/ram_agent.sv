class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)

    ram_agent_config cfg;
    uvm_analysis_port #(ram_seq_item) ap;
    ram_driver drv;
    ram_monitor mon;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db #(ram_agent_config)::get(this, "", "cfg", cfg))
            `uvm_fatal("RAM_AGENT", "Failed to get config object")

        ap = new("ap", this);
        mon = ram_monitor::type_id::create("mon", this);
        
        if(cfg.is_active == UVM_ACTIVE) begin
            drv = ram_driver::type_id::create("drv", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        mon.ap.connect(ap);
        if(cfg.is_active == UVM_ACTIVE) begin
            mon.vif = cfg.vif;
            drv.vif = cfg.vif;
        end
    endfunction

endclass 