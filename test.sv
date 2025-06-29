`include "uvm_macros.svh" //all macros are defined
`timescale 1ps/1ps

package test_pkg;
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import apb_uart_env_pkg::*;


class test extends uvm_test;
//***base do in any test file
    `uvm_component_utils(test);

     //instance of the environment
    apb_uart_env env;

    //configuration objects
    // These objects are used to configure the agents and interfaces
    APB_config apb_config;
    Uart_tx_config tx_config;
    Uart_rx_config rx_config;
    Ram_config ram_config;

    
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    //build phase 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create instances of the configuration objects
        env = apb_uart_env::type_id::create("env", this); // Create an instance of the environment
        apb_config = APB_config::type_id::create("apb_config");
        tx_config = Uart_tx_config::type_id::create("tx_config");
        rx_config = Uart_rx_config::type_id::create("rx_config");
        ram_config = Ram_config::type_id::create("ram_config");


        if (!uvm_config_db#(virtual APB_interface)::get(this, "", "apbif", apb_config.apbif)) //db must be in config
            `uvm_fatal("build_phase", "TEST - Unable to retrieve apbif from config db");

        if (!uvm_config_db#(virtual uart_tx_if)::get(this, "", "uart_txif", tx_config.txif))
            `uvm_fatal("build_phase", "TEST - Unable to retrieve uart_txif from config db");

        if (!uvm_config_db#(virtual uart_rx_if)::get(this, "", "uart_rxif", rx_config.rxif))
            `uvm_fatal("build_phase", "TEST - Unable to retrieve uart_rxif from config db");

        if (!uvm_config_db#(virtual Ram_interface)::get(this, "", "ramif", ram_config.v_if))
            `uvm_fatal("build_phase", "TEST - Unable to retrieve ramif from config db");

        // Set the configuration objects in the UVM config database
        uvm_config_db#(APB_config)::set(this, "*", "apb", apb_config);
        uvm_config_db#(Uart_tx_config)::set(this, "*", "tx", tx_config);
        uvm_config_db#(Uart_rx_config)::set(this, "*", "rx", rx_config);
        uvm_config_db#(Ram_config)::set(this, "*", "ram", ram_config);

        

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        `uvm_info("DEBUG", "Running the test", UVM_HIGH);
         phase.raise_objection(this, "TEST_DONE");
      
        #(100ns);
      
        `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
        phase.drop_objection(this, "TEST_DONE");
    endtask



endclass
endpackage