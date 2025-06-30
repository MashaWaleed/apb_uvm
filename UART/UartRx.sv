module UartRx #(
  parameter DATA_BITS = 8, 
  parameter PAR_TYP   = 0, // 0 -> EVEN , 1 -> ODD.
  parameter SB_TICK   = 16 // equivalent to 1 stop bit since each bit is sampled 16 times.
)(
  uart_rx_if.DUT uart_if
);

  localparam int TOTALBITS = DATA_BITS + 1; // Data bits + one parity bit
  
  //–– Alias interface signals ––
  wire        clk   = uart_if.clk;
  wire        rx    = uart_if.rx;
  wire        tick  = uart_if.tick;
  wire        rst_n = uart_if.rst_n;
  
  logic [DATA_BITS-1:0] rx_data;
  logic         rx_done;
  logic         rx_error;
  
  //–– Drive interface outputs ––
  assign uart_if.rx_data  = rx_data;
  assign uart_if.rx_done = rx_done;
  assign uart_if.rx_error = rx_error;
  

  //------------------------------------------------------------------------
  //-- FSM states & local signals
  //------------------------------------------------------------------------

  typedef enum logic [2:0] {IDLE, START, DATA, STOP} state_e;
  state_e state, next_state;

  logic [TOTALBITS-1:0]         shiftReg , shiftReg_next;
  logic [$clog2(TOTALBITS):0]   tickCnt, next_tickCnt;  // Enough bits to count ticks per bit
  logic [$clog2(TOTALBITS):0]   shiftedBitsCnt, shiftedBitsCnt_next;  // Count of bits received
  
  
  // Simplified sequential logic for state transition and data processing
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      tickCnt <= '0;
      shiftedBitsCnt <= '0;
      shiftReg <= '0;
    end else begin
      state <= next_state;
      tickCnt <= next_tickCnt;
      shiftedBitsCnt <= shiftedBitsCnt_next;
      shiftReg <= shiftReg_next;
    end
  end

  //------------------------------------------------------------------------
  // Combinational: next_state, outputs, control flags and next register values
  //------------------------------------------------------------------------
  always_comb begin
    // defaults - maintain current values
    next_state = state;
    next_tickCnt = tickCnt;
    shiftedBitsCnt_next = shiftedBitsCnt;
    shiftReg_next = shiftReg;

    rx_done = 1'b0;
    rx_error = 1'b0;

    case (state)

      //----------- wait for start (line idle=1, start=0) -----------
      IDLE: begin

        // Reset counters in IDLE
        next_tickCnt = '0;
        shiftedBitsCnt_next = '0;
        
        if (rx == 1'b0) 
          next_state = START;

      end
    
      //----------- START: sample at mid-bit -----------
      START: if (tick) begin

          if (tickCnt == 7) begin // we reached the middle of the start bit
            next_tickCnt = '0;
            next_state = DATA;
          end else 
            next_tickCnt = tickCnt + 1'b1;
          
      end
      

      //----------- DATA: shift N bits -----------
      DATA: if (tick) begin
        
          if (tickCnt == 15) begin // Middle of data bit reached - sample
            next_tickCnt = '0;
            shiftReg_next = {rx, shiftReg[TOTALBITS-1:1]}; // Shift in new bit
            
            if (shiftedBitsCnt == TOTALBITS - 1)
              next_state = STOP;
            else
              shiftedBitsCnt_next = shiftedBitsCnt + 1'b1;

          end else 
            next_tickCnt = tickCnt + 1'b1;
          
      end
      
     
      //----------- STOP: sample stop bit -----------
      STOP: if(tick) begin
        
          if (tickCnt == SB_TICK - 1) begin
            next_tickCnt = '0;
            rx_done = 1'b1;
            next_state = IDLE;
          end else 
            next_tickCnt = tickCnt + 1'b1;
          
      end
  
      
      default: begin // Default to IDLE state in case of unexpected state
        next_state = IDLE;
        next_tickCnt = '0;
        shiftedBitsCnt_next = '0;
      end

    endcase
  end
  
  // Final data output assignment
  assign rx_data = shiftReg[DATA_BITS-1:0];
  assign rx_error = ((^shiftReg[DATA_BITS:0]) != PAR_TYP);
endmodule
