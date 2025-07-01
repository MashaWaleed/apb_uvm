`include "uvm_macros.svh"
`timescale 1ps/1ps

   // Import UVM package
    import uvm_pkg::*;  
    import shared_pkg::*;
    import config_pkg::*;
    import test_pkg::*;

module top;

    //clk
    logic clk = 0;
    initial begin
        $display("Starting the testbench...");
        
        forever #(CLK_PERIOD/2) clk = ~clk; // Toggle clock every 5 time units
    end

    APB_interface apbif (
        .clk(clk)
    );

    Ram_interface ramif (
        .clk(clk)
    );

    uart_rx_if uart_rxif (
        .clk(clk)
    );

    uart_tx_if uart_txif (
        .clk(clk)
    );

    //run test
    initial begin
        $display("Running the top_tb test");

        uvm_config_db#(virtual APB_interface)::set(null, "uvm_test_top", "apbif", apbif);
        uvm_config_db#(virtual Ram_interface)::set(null, "uvm_test_top", "ramif", ramif);
        uvm_config_db#(virtual uart_rx_if)::set(null, "uvm_test_top", "rxif", uart_rxif);
        uvm_config_db#(virtual uart_tx_if)::set(null, "uvm_test_top", "txif", uart_txif);

        $dumpfile("dump.vcd");
        $dumpvars;

        run_test("test");
    end

endmodule
