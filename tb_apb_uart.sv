module tb_apb_uart;
    import shared_pkg::*;
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
    logic rx;
    logic tx;
    logic rx_error;

    //DUT instantiation
    UART_wrapper #(
    .ADDR_WIDTH(16),
    .DATA_WIDTH(32),
    .ADDR_slave(2'b01)
) DUT (
    // apb stuff
    .PCLK(clk),
    .PRESETn(rst_n),
    .PADDR(paddr),
    .PPROT(pprot),
    .PSELx(psel),
    .PENABLE(penable),
    .PWRITE(pwrite),
    .PWDATA(pwdata),
    .PSTRB(pstrb),
    .PRDATA(prdata),
    .PSLVERR(pslverr),
    .PREADY(pready),

    // uart stuff
    .rx(rx),          // rx pin
    .tx(tx),          // tx pin
    .rx_error(rx_error)     // rx messed up
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
        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h4000;   // Address for write operation
        pwdata = 32'hDEADBEEF;

        @(posedge clk);
        @(posedge clk);
        pwrite = 0;
        repeat (12) @(posedge clk); //transmit 1 byte


        // Test write operation
        @(posedge clk);
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h4000;
        pwdata = 32'hAAAAAAAA;

        @(posedge clk);
        @(posedge clk);
        pwrite = 0;
        repeat (12) @(posedge clk); //transmit 1 byte


        // Test write operation
        @(posedge clk);
        pstrb = 4'b1110;
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h4000;
        pwdata = 32'hDEADBE1D;

        @(posedge clk);
        @(posedge clk);
        pwrite = 0;
        repeat (12) @(posedge clk); //transmit 1 byte



        rx = tx;
        repeat (4000)begin
            @(posedge clk);
            rx = tx; // Simulate receiving the same data back
        end // Wait for 20 time units to allow for transmission


        // Test read operation from rx_fifo
        $display("Reading from RX FIFO");
        repeat (12) @(posedge clk);
        $display("Read data: %h", prdata);


        // Test read operation
        @(posedge clk);
        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 0;
        penable = 1;
        paddr = 16'h4008;   // Address for write operation

        @(posedge clk);
        pwrite = 0;
        check_output(32'h000000EF);


        // Test read operation
        @(posedge clk);
        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 0;
        penable = 1;
        paddr = 16'h4008;   // Address for write operation

        @(posedge clk);
        pwrite = 0;
        check_output(32'h000000AA);


        // Test read operation
        @(posedge clk);
        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 0;
        penable = 1;
        paddr = 16'h4008;   // Address for write operation

        @(posedge clk);
        pwrite = 0;
        check_output(32'h0000001D);



        // Test write operation
        @(posedge clk);
        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 1;
        paddr = 16'h4001;
        pwdata = 32'hDEADBEEF;

        // Test read operation
        @(posedge clk);
        @(posedge clk);
        pwrite = 0;
        @(posedge clk);
        check_error(1'h1);


        // Test write operation
        @(posedge clk);
        pstrb = 4'b1111; // Assuming all bytes are valid for simplicity
        psel = 1;
        pwrite = 1;
        penable = 0;
        paddr = 16'h4001;
        pwdata = 32'hDEADBEEF;
        pprot = 3'b010; //wrong protection bits

        // Test read operation
        @(posedge clk);
        @(posedge clk);
        pwrite = 0;
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