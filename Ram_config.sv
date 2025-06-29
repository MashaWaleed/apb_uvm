`timescale 1ps/1ps
package Ram_config_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

// Configration class
class Ram_config extends uvm_object;
    `uvm_object_utils(Ram_config)    
    virtual Ram_interface v_if;

    // Agent activity flags
    uvm_active_passive_enum Ram_agent_isActive;

    function new(string name = "Ram_config");
        super.new(name);
        Ram_agent_isActive  = UVM_ACTIVE;
    endfunction //new()
endclass //Ram_config
endpackage