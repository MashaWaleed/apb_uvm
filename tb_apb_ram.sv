import shared_pkg::*;

module tb_apb_ram;

    // Signals
    logic clk;
    logic rst_n;
    logic [ADDR_WIDTH-1:0] paddr;
    logic [DATA_WIDTH-1:0] pwdata;
    logic [DATA_WIDTH-1:0] prdata;
    logic pwrite;
    logic penable;
    logic psel;
    logic pready;
    logic [3:0] pstrb;
    logic [2:0] pprot;
    logic [DATA_WIDTH-1:0] pslverr;

    // DUT instantiation
    RAM_wrapper #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .PCLK(clk),
        .PRESETn(rst_n),
        .PADDR(paddr),
        .PWDATA(pwdata),
        .PRDATA(prdata),
        .PWRITE(pwrite),
        .PENABLE(penable),
        .PSEL(psel),
        .PPROT(pprot), // Assuming no specific protection bits are needed
        .PSTRB(pstrb),
        .PREADY(pready),
        .PSLVERR(pslverr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        paddr = 0;
        pwdata = 0;
        pwrite = 0;
        penable = 0;
        psel = 0;
        pprot = 3'b000; // No specific protection bits
        
        // Reset sequence
        #10 rst_n = 1;
        
        // Test write operation
        @(posedge clk);
        dut.ram_ready = 1; // Indicate RAM is initially ready

        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h00A4;
        pwdata = 32'hDEADBEEF;

        // Test read operation
        @(posedge clk);
        @(posedge clk);
        pwrite = 0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        penable = 0;

        // Check read data
        @(posedge clk);
        check_output(32'hDEADBEEF);




        // Test write operation
        @(posedge clk);
        dut.ram_ready = 1; // Indicate RAM is initially ready

        pstrb = 4'b1001; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h00A8;
        pwdata = 32'hAAAAAAAA;

        // Test read operation
        @(posedge clk);
        @(posedge clk);
        pwrite = 0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        penable = 0;

        // Check read data
        @(posedge clk);
        check_output(32'hAAxxxxAA);





        // Test write operation
        @(posedge clk);
        dut.ram_ready = 1; // Indicate RAM is initially ready

        pstrb = 4'b1110; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h0180;
        pwdata = 32'hDEADBEEF;

        // Test read operation
        @(posedge clk);
        @(posedge clk);
        pwrite = 0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        penable = 0;

        // Check read data
        @(posedge clk);
        check_output(32'hDEADBE00);





        // Test write operation
        @(posedge clk);
        dut.ram_ready = 1; // Indicate RAM is initially ready

        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h0181;
        pwdata = 32'hDEADBEEF;

        // Test read operation
        @(posedge clk);
        @(posedge clk);
        pwrite = 0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        penable = 0;

        // Check read data
        @(posedge clk);
        check_error(1'h1);

        // End simulation
        #10 $finish;
    end


    task check_output(input logic [DATA_WIDTH-1:0] expected_data);
    if (prdata !== expected_data) begin
        $error("Read data mismatch! Expected: 0x%h, Got: 0x%h", expected_data, prdata);
    end else begin
        $display("Read data matched: 0x%h", prdata);
    end
    endtask

    task check_error(input logic expected_error);
    if (pslverr !== expected_error) begin
        $error("Error signal mismatch! Expected: %0d, Got: %0d", expected_error, pslverr);
    end else begin
        $display("Error signal matched: %0d", pslverr);
    end
    endtask
endmodule