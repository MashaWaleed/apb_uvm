import shared_pkg::*;
interface uart_rx_if (
  input logic clk
);
  /* input */ logic rst_n;    // active-low reset
  /* input */ logic rx;       // incoming serial line
  
  /* output */ logic [DATA_WIDTH-1:0]  rx_data;  // received byte
  /* output */ logic                   rx_done;  // 1 for one tick when data ready
  /* output */ logic                   rx_error; // 1 when error detected in reception  // clocking block for TB
  
  clocking cb @(posedge clk);
    input  rx_data, rx_done, rx_error;
    output rx, rst_n;
  endclocking

  modport DUT ( input  clk, rst_n, rx,
                output rx_done, rx_data, rx_error );

endinterface
