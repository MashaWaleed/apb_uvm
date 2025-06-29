`include "uvm_macros.svh" //all macros are defined
`timescale 1ps/1ps

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import driver_pkg::*;
    import sequencer_pkg::*;
    import sequenceItem_pkg::*;
    import monitor_pkg::*;

class apb_uart_test extends uvm_test;
    // Import UVM package
    import uvm_pkg::*;

//***base do in any test file
    `uvm_component_utils(apb_uart_test);

     //instance of the environment
    apb_uart_env env;

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    //build phase 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = apb_uart_env::type_id::create("env", this); // Create an instance of the environment
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        `uvm_info("DEBUG", "Running the apb_uart_test", UVM_HIGH);
         phase.raise_objection(this, "TEST_DONE");
      
        #(100ns);
      
        `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
        phase.drop_objection(this, "TEST_DONE");
    endtask

   


endclass
