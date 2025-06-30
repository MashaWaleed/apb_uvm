module uart_top #(
  parameter DATA_BITS = 8,
  parameter PAR_TYP = 0,    // even parity
  parameter SB_TICK = 16,   // stop bit ticks

  parameter FIFO_DEPTH = 16 // how many things can fit in fifo
)(
  input  logic clk,         // clock
  input  logic rst_n,       // reset (active low)
  input  logic rx,          // rx pin

  output logic tx,          // tx pin
  //input  logic tick,        // baud tick
  
  // tx fifo stuff
  input  logic tx_fifo_wr_en,

  input  logic [DATA_BITS-1:0] tx_fifo_din,
  output logic tx_fifo_full,
  
  // rx fifo stuff
  input  logic rx_fifo_rd_en,
  output logic [DATA_BITS-1:0] rx_fifo_dout,


  output logic rx_fifo_empty,

  output logic rx_error      // rx messed up
);

  // stuff we need inside
  logic [DATA_BITS-1:0] uart_rx_data;
  logic rx_done;

  logic tx_start;
  logic [DATA_BITS-1:0] tx_data;
  logic tx_done;

  logic tx_fifo_empty;
  logic rx_fifo_full;
  logic tx_ready;  // tx can take more data
  
  // interfaces for uart and fifo

  uart_rx_if #(.DATA_BITS(DATA_BITS)) rx_if();

  uart_tx_if #(.DATA_BITS(DATA_BITS)) tx_if();
  fifo_if #(.width(DATA_BITS), .depth(FIFO_DEPTH)) tx_fifo_if(.clk(clk), .rst_n(rst_n));

  fifo_if #(.width(DATA_BITS), .depth(FIFO_DEPTH)) rx_fifo_if(.clk(clk), .rst_n(rst_n));
  
  // hook up rx stuff
  assign rx_if.clk = clk;
  assign rx_if.rst_n = rst_n;
  assign rx_if.rx = rx;

  //assign rx_if.tick = tick;

  assign uart_rx_data = rx_if.rx_data;

  assign rx_done = rx_if.rx_done;
  assign rx_error = rx_if.rx_error;
  
  //hook up tx stuff


  assign tx_if.clk = clk;
  assign tx_if.rst_n = rst_n;

  //assign tx_if.tick = tick;
  assign tx_if.tx_start = tx_start;
  assign tx_if.tx_data = tx_data;
  assign tx_done = tx_if.tx_done;
  assign tx = tx_if.tx;
  
  // hook up tx fifo
  assign tx_fifo_if.wr_en = tx_fifo_wr_en;
  assign tx_fifo_if.din = tx_fifo_din;

  assign tx_fifo_full = tx_fifo_if.full;
  assign tx_fifo_empty = tx_fifo_if.empty;
  
  // hook up rx fifo
  assign rx_fifo_if.wr_en = rx_done && !rx_fifo_if.full;
  assign rx_fifo_if.din = uart_rx_data;

  assign rx_fifo_if.rd_en = rx_fifo_rd_en;
  assign rx_fifo_dout = rx_fifo_if.dout;
  assign rx_fifo_empty = rx_fifo_if.empty;
  assign rx_fifo_full = rx_fifo_if.full;
  
  // make sure tx is ready for next byte
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)

      tx_ready <= 1'b1; // good to go after reset

    else if (tx_start)

      tx_ready <= 1'b0; // busy now
    else if (tx_done)
      tx_ready <= 1'b1; // done, can take more
  end
  
  // start tx when we got data and tx is ready
  assign tx_start = !tx_fifo_empty && tx_ready;
  
  // grab data from fifo when starting
  assign tx_fifo_if.rd_en = tx_start;
  
  // send this data
  assign tx_data = tx_fifo_if.dout;
  
  // make rx module
  UartRx #(
    .DATA_BITS(DATA_BITS),
    .PAR_TYP(PAR_TYP),
    .SB_TICK(SB_TICK)
  ) uart_rx_inst (
    .uart_if(rx_if)
  );
  
  // make tx module
  UartTx #(
    .DATA_BITS(DATA_BITS),
    .PAR_TYP(PAR_TYP),
    .SB_TICK(SB_TICK)
  ) uart_tx_inst (
    .uart_if(tx_if)
  );
  
  // make tx fifo
  fifo #(
    .width(DATA_BITS),
    .depth(FIFO_DEPTH)
  ) tx_fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(tx_fifo_if.wr_en),
    .rd_en(tx_fifo_if.rd_en),
    .din(tx_fifo_if.din),
    .dout(tx_fifo_if.dout),
    .full(tx_fifo_if.full),
    .empty(tx_fifo_if.empty)
  );
  
  // make rx fifo
  fifo #(
    .width(DATA_BITS),
    .depth(FIFO_DEPTH)
  ) rx_fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(rx_fifo_if.wr_en),
    .rd_en(rx_fifo_if.rd_en),
    .din(rx_fifo_if.din),
    .dout(rx_fifo_if.dout),
    .full(rx_fifo_if.full),
    .empty(rx_fifo_if.empty)
  );

endmodule