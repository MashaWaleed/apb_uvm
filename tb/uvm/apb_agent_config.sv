class apb_agent_config extends uvm_object;
    `uvm_object_utils(apb_agent_config)

    // Virtual interface
    virtual apb_if vif;

    // Agent configuration
    bit is_active = UVM_ACTIVE;  // Default to active agent

    function new(string name = "apb_agent_config");
        super.new(name);
    endfunction

endclass 