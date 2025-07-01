module UartTx #(
  parameter DATA_BITS = 8, 
  parameter PAR_TYP   = 0, // 0 -> EVEN , 1 -> ODD.
  parameter SB_TICK   = 16 // equivalent to 1 stop bit since each bit is sampled 16 times.
)(
  uart_tx_if.DUT uart_if
);
  
  //–– Alias interface signals ––
  wire        clk       = uart_if.clk;
  wire        tick      = uart_if.tick;
  wire        rst_n     = uart_if.rst_n;
  wire        tx_start  = uart_if.tx_start;
  wire [DATA_BITS-1:0] tx_data = uart_if.tx_data;

  logic       tx_done;
  logic       tx;
  
  //–– Drive interface outputs ––
  assign uart_if.tx_done = tx_done;
  assign uart_if.tx = tx;
  
  
  //------------------------------------------------------------------------
  //-- FSM states & local signals
  //------------------------------------------------------------------------

  typedef enum logic [2:0] {IDLE, START, DATA, PARITY, STOP} state_e;
  state_e state, next_state;

  logic [DATA_BITS-1:0]     data_reg, next_data_reg;
  logic                     parity_bit;
  logic [$clog2(16)-1:0]    tick_cnt, next_tick_cnt;     // Count ticks (0-15)
  logic [$clog2(DATA_BITS):0] bit_cnt, next_bit_cnt;     // Count bits transmitted
  logic                     tx_reg, next_tx_reg;


  // Sequential logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
      tick_cnt <= '0;
      bit_cnt <= '0;
      data_reg <= '0;
      tx_reg <= 1'b1;  // Idle state is high
    end else begin
      state <= next_state;
      tick_cnt <= next_tick_cnt;
      bit_cnt <= next_bit_cnt;
      data_reg <= next_data_reg;
      tx_reg <= next_tx_reg;
    end
  end

  // Calculate parity bit
  assign parity_bit = PAR_TYP ? ~^data_reg : ^data_reg;
  
  // Combinational logic
  always_comb begin
    // Default assignments
    next_state = state;
    next_tick_cnt = tick_cnt;
    next_bit_cnt = bit_cnt;
    next_data_reg = data_reg;
    next_tx_reg = tx_reg;
    tx_done = 1'b0;

    case (state)
      //----------- IDLE: wait for tx_start -----------
      IDLE: begin
        next_tx_reg = 1'b1;  // Idle high
        if (tx_start) begin
          next_data_reg = tx_data;
          next_tick_cnt = '0;
          next_bit_cnt = '0;
          next_state = START;
        end
      end
    
      //----------- START: send start bit -----------
      START: begin
        next_tx_reg = 1'b0;  // Start bit is low
        if (tick) begin
          if (tick_cnt == 15) begin
            next_tick_cnt = '0;
            next_state = DATA;
          end else
            next_tick_cnt = tick_cnt + 1'b1;
        end
      end
      
      //----------- DATA: send data bits -----------
      DATA: begin
        next_tx_reg = data_reg[0];  // LSB first
        if (tick) begin
          if (tick_cnt == 15) begin
            next_tick_cnt = '0;
            next_data_reg = {1'b0, data_reg[DATA_BITS-1:1]};  // Shift right
            
            if (bit_cnt == DATA_BITS - 1) begin
              next_bit_cnt = '0;
              next_state = PARITY;
            end else
              next_bit_cnt = bit_cnt + 1'b1;
          end else
            next_tick_cnt = tick_cnt + 1'b1;
        end
      end
      
      //----------- PARITY: send parity bit -----------
      PARITY: begin
        next_tx_reg = parity_bit;
        if (tick) begin
          if (tick_cnt == 15) begin
            next_tick_cnt = '0;
            next_state = STOP;
          end else
            next_tick_cnt = tick_cnt + 1'b1;
        end
      end
      
      //----------- STOP: send stop bit -----------
      STOP: begin
        next_tx_reg = 1'b1;  // Stop bit is high
        if (tick) begin
          if (tick_cnt == SB_TICK - 1) begin
            next_tick_cnt = '0;
            tx_done = 1'b1;
            next_state = IDLE;
          end else
            next_tick_cnt = tick_cnt + 1'b1;
        end
      end
      
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // Output assignment
  assign tx = tx_reg;

endmodule