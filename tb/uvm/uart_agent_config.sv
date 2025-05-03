class uart_agent_config extends uvm_object;
    `uvm_object_utils(uart_agent_config)

    // Virtual interface
    virtual uart_if vif;

    // Agent configuration
    bit is_active = UVM_ACTIVE;  // Will be changed to passive later

    function new(string name = "uart_agent_config");
        super.new(name);
    endfunction

endclass 