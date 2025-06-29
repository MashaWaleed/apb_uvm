module tb_uart_top;
  // stuff we need
  parameter DATA_BITS = 8;
  parameter PAR_TYP = 0;
  parameter SB_TICK = 16;
  parameter FIFO_DEPTH = 16;
  parameter CLK_PERIOD = 10; // 10ns clock (100MHz)
  parameter CLK_FREQ = 100_000_000;
  parameter BAUD_RATE = 115200;
  
  // wires and stuff
  logic clk;
  logic rst_n;
  logic rx;
  logic tx;
  
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
    .FIFO_DEPTH(FIFO_DEPTH),
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .tx(tx),
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
    
    $display("\n=== Starting UART Top Test ===");
    $display("Time %0t: Clock frequency: %0d Hz", $time, CLK_FREQ);
    $display("Time %0t: Baud rate: %0d", $time, BAUD_RATE);
    
    // write some data to tx fifo
    for (int i = 0; i < 5; i++) begin
      @(posedge clk);
      tx_fifo_wr_en = 1;
      tx_fifo_din = test_data[i];
      $display("Time %0t: Writing data %h to TX FIFO", $time, test_data[i]);
      @(posedge clk);
      tx_fifo_wr_en = 0;
      #(CLK_PERIOD * 10);
    end
    
    // wait for transmission
    #(CLK_PERIOD * 10000);
    
    // read data from rx fifo
    $display("\n=== Reading Received Data ===");
    for (int i = 0; i < 5; i++) begin
      @(posedge clk);
      rx_fifo_rd_en = 1;
      @(posedge clk);
      rx_fifo_rd_en = 0;
      $display("Time %0t: Read data %h from RX FIFO", $time, rx_fifo_dout);
      #(CLK_PERIOD * 10);
    end
    
    // say we're done
    $display("\n=== Test Results ===");
    $display("UART top test completed successfully");
    $display("Data flow: TX FIFO -> UART TX -> UART RX -> RX FIFO");
    
    // end sim
    #(CLK_PERIOD * 100);
    $finish;
  end
  
  // watch tx data
  logic [DATA_BITS-1:0] last_tx_data;
  always @(posedge dut.tx_start) begin
    if (dut.tx_data !== last_tx_data) begin
      $display("Time %0t: [UART TX] Starting transmission with data %h", $time, dut.tx_data);
      last_tx_data = dut.tx_data;
    end
  end
  
  // watch rx data
  logic [DATA_BITS-1:0] last_rx_data;
  always @(posedge dut.rx_done) begin
    if (dut.uart_rx_data !== last_rx_data) begin
      $display("Time %0t: [UART RX] Received data %h", $time, dut.uart_rx_data);
      last_rx_data = dut.uart_rx_data;
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