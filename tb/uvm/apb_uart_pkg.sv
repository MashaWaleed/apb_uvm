package apb_uart_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Agent configurations
    `include "apb_agent_config.sv"
    `include "uart_agent_config.sv"
    `include "ram_agent_config.sv"

    // Agents
    `include "apb_agent.sv"
    `include "uart_agent.sv"
    `include "ram_agent.sv"

    // Environment
    `include "apb_uart_env.sv"

    // Tests
    `include "base_test.sv"
endpackage 