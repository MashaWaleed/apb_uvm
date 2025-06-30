module UartRx #(
  parameter DATA_BITS = 8, 
  parameter PAR_TYP   = 0, // 0 -> EVEN , 1 -> ODD.
  parameter SB_TICK   = 16 // equivalent to 1 stop bit since each bit is sampled 16 times.
)(
  uart_rx_if.DUT uart_if
);

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

  typedef enum logic [2:0] {IDLE, START, DATA, PARITY, STOP} state_e;
  state_e state, next_state;

  logic [DATA_BITS-1:0]        data_reg, next_data_reg;
  logic                        parity_bit, next_parity_bit;
  logic [$clog2(16)-1:0]       tick_cnt, next_tick_cnt;  // Count ticks (0-15)
  logic [$clog2(DATA_BITS):0]  bit_cnt, next_bit_cnt;    // Count data bits received
  
  
  // Simplified sequential logic for state transition and data processing
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      tick_cnt <= '0;
      bit_cnt <= '0;
      data_reg <= '0;
      parity_bit <= '0;
    end else begin
      state <= next_state;
      tick_cnt <= next_tick_cnt;
      bit_cnt <= next_bit_cnt;
      data_reg <= next_data_reg;
      parity_bit <= next_parity_bit;
    end
  end

  //------------------------------------------------------------------------
  // Combinational: next_state, outputs, control flags and next register values
  //------------------------------------------------------------------------
  always_comb begin
    // defaults - maintain current values
    next_state = state;
    next_tick_cnt = tick_cnt;
    next_bit_cnt = bit_cnt;
    next_data_reg = data_reg;
    next_parity_bit = parity_bit;

    rx_done = 1'b0;
    rx_error = 1'b0;

    case (state)

      //----------- wait for start (line idle=1, start=0) -----------
      IDLE: begin
        // Reset counters in IDLE
        next_tick_cnt = '0;
        next_bit_cnt = '0;
        
        if (rx == 1'b0) 
          next_state = START;
      end
    
      //----------- START: sample at mid-bit -----------
      START: if (tick) begin
          if (tick_cnt == 7) begin // we reached the middle of the start bit
            next_tick_cnt = '0;
            next_state = DATA;
          end else 
            next_tick_cnt = tick_cnt + 1'b1;
      end
      
      //----------- DATA: collect 8 data bits -----------
      DATA: if (tick) begin
          if (tick_cnt == 15) begin // Sample at the end of each bit period
            next_tick_cnt = '0;
            next_data_reg = {rx, data_reg[DATA_BITS-1:1]}; // LSB first
            
            if (bit_cnt == DATA_BITS - 1) begin
              next_bit_cnt = '0;
              next_state = PARITY;
            end else
              next_bit_cnt = bit_cnt + 1'b1;
          end else 
            next_tick_cnt = tick_cnt + 1'b1;
      end
      
      //----------- PARITY: check parity bit -----------
      PARITY: if (tick) begin
          if (tick_cnt == 15) begin
            next_tick_cnt = '0;
            next_parity_bit = rx; // Capture parity bit
            next_state = STOP;
          end else
            next_tick_cnt = tick_cnt + 1'b1;
      end
      
      //----------- STOP: sample stop bit -----------
      STOP: if(tick) begin
          if (tick_cnt == SB_TICK - 1) begin
            next_tick_cnt = '0;
            rx_done = 1'b1; // Signal byte received
            
            // Check parity - even parity: XOR of all bits should be 0
            // odd parity: XOR of all bits should be 1
            if (PAR_TYP == 0) // EVEN parity
              rx_error = ^{data_reg, parity_bit}; // Error if odd parity
            else              // ODD parity
              rx_error = ~^{data_reg, parity_bit}; // Error if even parity
              
            next_state = IDLE;
          end else 
            next_tick_cnt = tick_cnt + 1'b1;
      end
      
      default: begin // Default to IDLE state in case of unexpected state
        next_state = IDLE;
        next_tick_cnt = '0;
        next_bit_cnt = '0;
      end

    endcase
  end
  
  // Final data output assignment
  assign rx_data = data_reg;
endmodule