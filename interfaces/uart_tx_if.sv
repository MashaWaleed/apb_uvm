import shared_pkg::*;
interface uart_tx_if (
  input logic        clk
);
  /* input */ logic                 rst_n;    // active-low reset
  /* input */ logic                 tx_start;
  /* input */ logic [DATA_WIDTH-1:0] tx_data;  // received byte
  
  /* output */ logic tx;       // incoming serial line
  /* output */ logic tx_done;  // 1 for one tick when data ready
   
  clocking cb @(posedge clk);
    input  tx_done, tx;
    output tx_start, tx_data, rst_n;
  endclocking

  modport DUT ( input  clk,rst_n , tx_start, tx_data,
                output tx, tx_done);

endinterface
