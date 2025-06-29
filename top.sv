`include "uvm_macros.svh"
`timescale 1ps/1ps

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import driver_pkg::*;
    import sequencer_pkg::*;
    import sequenceItem_pkg::*;
    import monitor_pkg::*;

module top_tb;

    //clk
    reg clk = 0;
    initial begin
        $display("Starting the testbench...");
        
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    //run test
    initial begin
        $display("Running the top_tb test");

        
        $dumpfile("dump.vcd");
        $dumpvars;

        run_test("");

    end
endmodule
