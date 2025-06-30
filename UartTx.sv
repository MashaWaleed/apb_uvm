module UartTx #(
  parameter DATA_BITS = 8, 
  parameter PAR_TYP   = 0, // 0 -> EVEN , 1 -> ODD.
  parameter SB_TICK   = 16 // equivalent to 1 stop bit since each bit is sampled 16 times.
)(
  uart_tx_if.DUT uart_if
);
  
  localparam int TOTALBITS = DATA_BITS + 1; // Data bits + one parity bit
  //–– Alias interface signals ––
  wire        clk       = uart_if.clk;
  wire        tick      = uart_if.tick;
  wire        rst_n     = uart_if.rst_n;
  wire        tx_start  = uart_if.tx_start;
  wire        tx_data   = uart_if.tx_data ;

  logic       tx_done;
  logic       tx;
  //–– Drive interface outputs ––
  assign uart_if.tx_done  = tx_done;
  assign uart_if.tx       = tx;
  
  
  //------------------------------------------------------------------------
  //-- FSM states & local signals
  //------------------------------------------------------------------------

  typedef enum logic [2:0] {IDLE, START, DATA, STOP} state_e;
  state_e state, next_state;

  logic [TOTALBITS-1:0]         shiftReg , next_shiftReg;
  logic [3:0]                   tickCnt, next_tickCnt;  // Enough bits to count ticks per bit, which are 16 ticks (0 -> 15)
  logic [$clog2(TOTALBITS):0]   shiftedBitsCnt, next_shiftedBitsCnt;  // Count of bits received
  logic                         txReg , next_txReg;


  // Simplified sequential logic for state transition and data processing
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      tickCnt <= '0;
      shiftedBitsCnt <= '0;
      shiftReg <= '0;
      txReg <= 0;
    end else begin
      state <= next_state;
      tickCnt <= next_tickCnt;
      shiftedBitsCnt <= next_shiftedBitsCnt;
      shiftReg <= next_shiftReg;
      txReg <= next_txReg;
    end
  end

  
  // Combinational: next_state, outputs, control flags and next register values
  always_comb begin
    // defaults - maintain current values
    next_state = state;
    next_tickCnt = tickCnt;
    next_shiftedBitsCnt = shiftedBitsCnt;
    next_shiftReg = shiftReg;
    tx_done = 1'b0;

    case (state)

      //----------- wait for start (line idle=1, start=0) -----------
      IDLE: begin
        next_txReg = '1;
        if (tx_start) begin
          next_tickCnt = '0;
          next_shiftReg = tx_data;
          next_state = START;
        end
      end
    
      //----------- START: sample at mid-bit -----------
      START: begin
        next_txReg = '0;
        if (tick) begin
            if (tickCnt == 15) begin // keep start bit held for 16 ticks
              next_tickCnt = '0;
              next_shiftedBitsCnt = '0;
              next_state = DATA;
            end else 
              next_tickCnt = tickCnt + 1'b1;
        end
      end
      

      //----------- DATA: shift N bits -----------
      DATA: begin
        next_txReg = shiftReg[0];
        if (tick) begin
          if (tickCnt == 15) begin
            next_tickCnt = '0;
            // shift when we are sending data bits then after that, send parity bit
            next_shiftReg = (shiftedBitsCnt == TOTALBITS - 1) ? { {DATA_BITS{1'b0}} , ^shiftReg} : {1'b0 , shiftReg[TOTALBITS-1:1]};

            if (shiftedBitsCnt == TOTALBITS - 1)
              next_state = STOP;
            else
              next_shiftedBitsCnt = shiftedBitsCnt + 1'b1;

          end else 
            next_tickCnt = tickCnt + 1'b1;
      end
    end
      
     
      //----------- STOP: sample stop bit -----------
      STOP: begin
        next_txReg = '1;
        if(tick) begin
          
            if (tickCnt == SB_TICK - 1) begin
              tx_done = 1'b1;
              next_state = IDLE;
            end else 
              next_tickCnt = tickCnt + 1'b1;
            
        end
    end
  
      
      default: begin // Default to IDLE state in case of unexpected state
        next_state = IDLE;
        next_tickCnt = '0;
        next_shiftedBitsCnt = '0;
      end

    endcase
  end

 // Final data output assignment
assign tx = txReg;

endmodule
