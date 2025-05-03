class ram_agent_config extends uvm_object;
    `uvm_object_utils(ram_agent_config)

    // Virtual interface
    virtual ram_if vif;

    // Agent configuration
    bit is_active = UVM_ACTIVE;  // Will be changed to passive later

    function new(string name = "ram_agent_config");
        super.new(name);
    endfunction

endclass 