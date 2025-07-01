`timescale 1ps/1ps
package config_pkg;
  import shared_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //------------------------------------------------------------
  class apb_config extends uvm_object;
    `uvm_object_utils(apb_config)
    virtual APB_interface apbif;
    
    function new(string name = "apb_config");
      super.new(name);
    endfunction
  endclass

  //------------------------------------------------------------
  class uart_tx_config extends uvm_object;
    virtual uart_tx_if txif;
    `uvm_object_utils(uart_tx_config)
   
    function new(string name = "uart_tx_config");
      super.new(name);
    endfunction
  endclass

  //------------------------------------------------------------
  class uart_rx_config extends uvm_object;
    `uvm_object_utils(uart_rx_config)
    virtual uart_rx_if rxif;

    function new(string name = "uart_rx_config");
      super.new(name);
    endfunction
  endclass
  //------------------------------------------------------------
  class Ram_config extends uvm_object;
    `uvm_object_utils(Ram_config)    
    virtual Ram_interface v_if;

    // Agent activity flags
    uvm_active_passive_enum Ram_agent_isActive;

    function new(string name = "Ram_config");
        super.new(name);
        Ram_agent_isActive = UVM_ACTIVE;
    endfunction //new()
endclass //Ram_config

endpackage
