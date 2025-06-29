`timescale 1ps/1ps
package config_pkg;
  import shared_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //------------------------------------------------------------
  class APB_config extends uvm_object;
    `uvm_object_utils(APB_config)
    virtual APB_interface apbif;
    
    function new(string name = "APB_config");
      super.new(name);
    endfunction
  endclass

  //------------------------------------------------------------
  class Uart_tx_config extends uvm_object;
    `uvm_object_utils(Uart_tx_config)
    virtual uart_tx_if txif;
   
    function new(string name = "Uart_tx_config");
      super.new(name);
    endfunction
  endclass

  //------------------------------------------------------------
  class Uart_rx_config extends uvm_object;
    `uvm_object_utils(Uart_rx_config)
    virtual uart_rx_if rxif;

    function new(string name = "Uart_rx_config");
      super.new(name);
    endfunction
  endclass
endpackage
