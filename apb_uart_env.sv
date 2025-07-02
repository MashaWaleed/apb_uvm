`timescale 1ps/1ps
`include "uvm_macros.svh"
package apb_uart_env_pkg;
   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;

    import apb_sequence_item_pkg::*;
    import uart_tx_sequence_item_pkg::*;
    import uart_rx_sequence_item_pkg::*;

    import uart_rx_agent_pkg::*;
    import uart_tx_agent_pkg::*;
    import apb_agent_pkg::*;

    import Ram_agent_pkg::*;
  
class apb_uart_env extends uvm_env;
    `uvm_component_utils(apb_uart_env);
    
    Ram_agent ram_agent;
    apb_agent apb_agnt;
    uart_rx_agent rx_agent;
    uart_tx_agent tx_agent;

    apb_config apb_cfg;
    uart_tx_config uart_tx_cfg;
    uart_rx_config uart_rx_cfg;

    Ram_config ram_cfg;


    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the agents
        rx_agent = uart_rx_agent::type_id::create("rx_agent", this);
        tx_agent = uart_tx_agent::type_id::create("tx_agent", this);
        apb_agnt = apb_agent::type_id::create("apb_agnt", this);
        ram_agent = Ram_agent::type_id::create("ram_agent", this);

        //create configs
        apb_cfg = apb_config::type_id::create("apb_cfg", this);
        uart_tx_cfg = uart_tx_config::type_id::create("uart_tx_cfg", this);
        uart_rx_cfg = uart_rx_config::type_id::create("uart_rx_cfg", this);
        ram_cfg = Ram_config::type_id::create("ram_cfg", this);

        //get handle to vif via config_db
        if (!uvm_config_db#(apb_config)::get(this, "", "apb", apb_cfg))
            `uvm_fatal("ENV", "Unable to get apb_config from config DB")

        if (!uvm_config_db#(uart_tx_config)::get(this, "", "tx", uart_tx_cfg))
            `uvm_fatal("ENV", "Unable to get tx_config from config DB")

        if (!uvm_config_db#(uart_rx_config)::get(this, "", "rx", uart_rx_cfg))
            `uvm_fatal("ENV", "Unable to get rx_config from config DB")

        if (!uvm_config_db#(Ram_config)::get(this, "", "ram", ram_cfg))
            `uvm_fatal("ENV", "Unable to get ram_config from config DB")
    
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("APB_uart_ENV", "Connect phase completed.", UVM_HIGH)
    endfunction
endclass

endpackage