interface uart_rx_if #(parameter DATA_BITS = 8);
  logic        clk;       // Clock signal
  logic        rst_n;     // active-low reset
  logic        rx;        // incoming serial line
  logic        tick;      // Baud tick (one per bit time)
  logic [DATA_BITS-1:0] rx_data;  // received byte
  logic        rx_done;  // 1 for one tick when data ready
  logic        rx_error;  // 1 when error detected in reception  // clocking block for TB
  clocking cb @(posedge clk);
    input  rx_data, rx_done, rx_error;
    output tick, rx, rst_n;
  endclocking

  modport DUT ( input  clk, rst_n, rx, tick,
                output rx_done, rx_data, rx_error );

endinterface
