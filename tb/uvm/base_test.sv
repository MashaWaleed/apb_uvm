class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    apb_uart_env env;
    apb_agent_config apb_cfg;
    uart_agent_config uart_cfg;
    ram_agent_config ram_cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create environment
        env = apb_uart_env::type_id::create("env", this);
        
        // Create and configure agent configs
        apb_cfg = apb_agent_config::type_id::create("apb_cfg");
        uart_cfg = uart_agent_config::type_id::create("uart_cfg");
        ram_cfg = ram_agent_config::type_id::create("ram_cfg");
        
        // Set agent configurations
        apb_cfg.is_active = UVM_ACTIVE;
        uart_cfg.is_active = UVM_ACTIVE;  // Will be changed to passive later
        ram_cfg.is_active = UVM_ACTIVE;   // Will be changed to passive later
        
        // Set virtual interfaces
        if(!uvm_config_db #(virtual apb_if)::get(this, "", "apb_vif", apb_cfg.vif))
            `uvm_fatal("TEST", "Failed to get APB interface")
        if(!uvm_config_db #(virtual uart_if)::get(this, "", "uart_vif", uart_cfg.vif))
            `uvm_fatal("TEST", "Failed to get UART interface")
        if(!uvm_config_db #(virtual ram_if)::get(this, "", "ram_vif", ram_cfg.vif))
            `uvm_fatal("TEST", "Failed to get RAM interface")
        
        // Set configurations in config_db
        uvm_config_db #(apb_agent_config)::set(this, "env.apb_agt*", "cfg", apb_cfg);
        uvm_config_db #(uart_agent_config)::set(this, "env.uart_agt*", "cfg", uart_cfg);
        uvm_config_db #(ram_agent_config)::set(this, "env.ram_agt*", "cfg", ram_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        // Test code will be added here
        phase.drop_objection(this);
    endtask

endclass 