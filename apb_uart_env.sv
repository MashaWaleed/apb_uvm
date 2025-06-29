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
    apb_agent apb_agent;
    
    Uart_rx_agent rx_agent;
    uart_tx_agent tx_agent;

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the agents
        rx_agent = Uart_rx_agent::type_id::create("rx_agent", this);
        tx_agent = uart_tx_agent::type_id::create("tx_agent", this);
        apb_agent = apb_agent::type_id::create("apb_agent", this);
        ram_agent = Ram_agent::type_id::create("ram_agent", this);
    
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        `uvm_info("APB_UART_ENV", "Connect phase completed.", UVM_HIGH)
    endfunction
endclass

endpackage