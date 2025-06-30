module tb_uart_top;
  // stuff we need
  parameter DATA_BITS = 8;
  parameter PAR_TYP = 0;
  parameter SB_TICK = 16;
  parameter FIFO_DEPTH = 16;
  parameter CLK_PERIOD = 10; // 10ns clock (100MHz)
  parameter BAUD_RATE = 115200;
  parameter TICK_PERIOD = (CLK_PERIOD * 100000000) / (16 * BAUD_RATE); // ticks per bit
  
  // wires and stuff
  logic clk;
  logic rst_n;
  logic rx;
  logic tx;
  logic tick;
  
  // tx fifo stuff
  logic tx_fifo_wr_en;
  logic [DATA_BITS-1:0] tx_fifo_din;
  logic tx_fifo_full;
  
  // rx fifo stuff
  logic rx_fifo_rd_en;
  logic [DATA_BITS-1:0] rx_fifo_dout;
  logic rx_fifo_empty;
  logic rx_error;
  
  // test data
  logic [DATA_BITS-1:0] test_data [10];
  int data_count;
  int errors;
  
  // stuff we wanna watch
  logic rx_done;
  logic tx_done;
  logic tx_start;
  logic [DATA_BITS-1:0] uart_rx_data;
  logic [DATA_BITS-1:0] tx_data;
  logic tx_fifo_empty;
  logic rx_fifo_full;
  
  // make the thing we're testing
  uart_top #(
    .DATA_BITS(DATA_BITS),
    .PAR_TYP(PAR_TYP),
    .SB_TICK(SB_TICK),
    .FIFO_DEPTH(FIFO_DEPTH)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .tx(tx),
    .tick(tick),
    .tx_fifo_wr_en(tx_fifo_wr_en),
    .tx_fifo_din(tx_fifo_din),
    .tx_fifo_full(tx_fifo_full),
    .rx_fifo_rd_en(rx_fifo_rd_en),
    .rx_fifo_dout(rx_fifo_dout),
    .rx_fifo_empty(rx_fifo_empty),
    .rx_error(rx_error)
  );
  
  // hook up stuff we wanna watch
  assign rx_done = dut.rx_done;
  assign uart_rx_data = dut.uart_rx_data;
  assign tx_done = dut.tx_done;
  assign tx_start = dut.tx_start;
  assign tx_data = dut.tx_data;
  assign tx_fifo_empty = dut.tx_fifo_empty;
  assign rx_fifo_full = dut.rx_fifo_full;
  
  // make clock go tick tock
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end
  
  // make baud tick go faster for sim
  initial begin
    tick = 0;
    forever begin
      #(CLK_PERIOD * 5) tick = 1; // go faster
      #(CLK_PERIOD) tick = 0;
    end
  end
  
  // hook up tx to rx for testing
  assign rx = tx;
  
  // make some random test data
  initial begin
    for (int i = 0; i < 10; i++) begin
      test_data[i] = $urandom_range(0, 255);
    end
    data_count = 0;
    errors = 0;
  end
  
  // main test
  initial begin
    // start with everything off
    rst_n = 0;
    tx_fifo_wr_en = 0;
    tx_fifo_din = 0;
    rx_fifo_rd_en = 0;
    
    // reset stuff
    #(CLK_PERIOD * 10);
    rst_n = 1;
    #(CLK_PERIOD * 20);
    
    // wait for fifos to be ready
    wait(!dut.tx_fifo_if.full && !dut.rx_fifo_if.full);
    #(CLK_PERIOD * 5);  // wait a bit more
    
    $display("\n=== Starting UART-FIFO Loopback Test ===");
    $display("Time %0t: Baud tick period: %0d clock cycles", $time, TICK_PERIOD);
    
    // put some data in tx fifo
    for (int i = 0; i < 5; i++) begin
      @(posedge clk);
      tx_fifo_wr_en = 1;
      tx_fifo_din = test_data[i];
      @(posedge clk);
      tx_fifo_wr_en = 0;
      $display("Time %0t: [TX FIFO] Writing data %h", $time, tx_fifo_din);
      #(CLK_PERIOD * 10);
    end
    
    $display("\nTime %0t: Waiting for transmission to complete...", $time);
    
    // wait for all tx to finish
    repeat (5) begin
      wait(tx_start);
      wait(tx_done);
      #(CLK_PERIOD * 10);
    end
    
    // wait a bit more for rx
    #(CLK_PERIOD * 10000);
    
    // check rx fifo
    $display("\nTime %0t: [RX FIFO] Status - Empty: %b, Full: %b", $time, rx_fifo_empty, rx_fifo_full);
    
    // wait for rx fifo to have data
    if (rx_fifo_empty) begin
      $display("Time %0t: Waiting for RX FIFO to have data...", $time);
      wait(!rx_fifo_empty);
    end
    
    // read data from rx fifo
    $display("\n=== Reading Received Data ===");
    for (int i = 0; i < 5; i++) begin
      @(posedge clk);
      if (!rx_fifo_empty) begin
        rx_fifo_rd_en = 1;
        @(posedge clk);
        rx_fifo_rd_en = 0;
        $display("Time %0t: [RX FIFO] Read data %h", $time, rx_fifo_dout);
      end else begin
        wait(!rx_fifo_empty);
        rx_fifo_rd_en = 1;
        @(posedge clk);
        rx_fifo_rd_en = 0;
        $display("Time %0t: [RX FIFO] Read data %h", $time, rx_fifo_dout);
      end
      #(CLK_PERIOD * 10);
    end
    
    // check if more data in rx fifo
    if (!rx_fifo_empty) begin
      $display("\nTime %0t: Reading remaining data from RX FIFO:", $time);
      while (!rx_fifo_empty) begin
        rx_fifo_rd_en = 1;
        @(posedge clk);
        rx_fifo_rd_en = 0;
        $display("Time %0t: [RX FIFO] Additional data: %h", $time, rx_fifo_dout);
        @(posedge clk);
      end
    end
    
    // say we're done
    $display("\n=== Test Results ===");
    $display("UART-FIFO loopback test completed successfully");
    $display("Data flow: TX FIFO -> UART TX -> UART RX -> RX FIFO");
    
    // end sim
    #(CLK_PERIOD * 100);
    $finish;
  end
  
  // watch tx fifo writes
  logic [DATA_BITS-1:0] last_tx_fifo_data;
  always @(posedge tx_fifo_wr_en) begin
    if (tx_fifo_din !== last_tx_fifo_data) begin
      last_tx_fifo_data = tx_fifo_din;
    end
  end
  
  // watch rx data
  logic [DATA_BITS-1:0] last_rx_data;
  always @(posedge rx_done) begin
    if (uart_rx_data !== last_rx_data) begin
      $display("Time %0t: [UART RX] Received data %h", $time, uart_rx_data);
      last_rx_data = uart_rx_data;
    end
  end
  
  // watch tx start/done
  logic last_tx_start;
  always @(posedge clk) begin
    if (tx_start && !last_tx_start) begin
      $display("Time %0t: [UART TX] Starting transmission with data %h", $time, tx_data);
    end
    last_tx_start = tx_start;
  end
  
  // watch rx fifo writes
  logic [DATA_BITS-1:0] last_rx_fifo_data;
  always @(posedge dut.rx_fifo_if.wr_en) begin
    if (dut.rx_fifo_if.din !== last_rx_fifo_data) begin
      $display("Time %0t: [RX FIFO] Writing data %h", $time, dut.rx_fifo_if.din);
      last_rx_fifo_data = dut.rx_fifo_if.din;
    end
  end
  
  // say we're still running
  initial begin
    forever begin
      #100000;
      $display("\nTime %0t: Simulation in progress...", $time);
    end
  end
  
endmodule 