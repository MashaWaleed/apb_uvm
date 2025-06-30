interface uart_tx_if #(parameter DATA_BITS = 8);
  logic        clk;       // Clock signal
  logic        rst_n;     // active-low reset
  logic        tx;        // incoming serial line
  logic        tick;      // Baud tick (one per bit time)
  logic        tx_start;
  logic [DATA_BITS-1:0] tx_data;  // received byte
  logic        tx_done;  // 1 for one tick when data ready

   // clocking block for TB
  clocking cb @(posedge clk);
    input  tx_done, tx;
    output tick, tx_start, tx_data, rst_n;
  endclocking

  modport DUT ( input  clk,rst_n , tick , tx_start, tx_data,
                output tx, tx_done);

endinterface
