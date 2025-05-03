`timescale 1ns/1ps

module top;
    import uvm_pkg::*;
    import apb_uart_pkg::*;

    // Clock and reset
    bit clk;
    bit rst_n;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end

    // Dummy interfaces (will be replaced with real ones)
    interface apb_if apb_vif(clk, rst_n);
    endinterface

    interface uart_if uart_vif(clk, rst_n);
    endinterface

    interface ram_if ram_vif(clk, rst_n);
    endinterface

    // Create interface instances
    apb_if apb_if_inst(clk, rst_n);
    uart_if uart_if_inst(clk, rst_n);
    ram_if ram_if_inst(clk, rst_n);

    initial begin
        // Put interfaces in config_db
        uvm_config_db #(virtual apb_if)::set(null, "*", "apb_vif", apb_if_inst);
        uvm_config_db #(virtual uart_if)::set(null, "*", "uart_vif", uart_if_inst);
        uvm_config_db #(virtual ram_if)::set(null, "*", "ram_vif", ram_if_inst);

        // Run test
        run_test("base_test");
    end

endmodule 