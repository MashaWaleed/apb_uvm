import shared_pkg::*;

module UartRx #(
  parameter int PARITY_EN  = 0, // 0 = no parity, 1 = odd, 2 = even
  parameter int STOP_BITS  = 1
)(
  uart_rx_if.DUT intf
);

  
  localparam START_BIT = 1'b0; // start bit is always low
  localparam STOP_BIT  = 1'b1; // stop bit is always
  

  uart_states_e state;

  logic [DATA_WIDTH-1:0] shift_reg;
  logic [3:0] bit_cnt;
  logic [1:0] stop_cnt;
  logic computed_parity;
  logic parity_bit;

  always_ff @(posedge intf.clk or negedge intf.rst_n) begin
    if (!intf.rst_n) begin
      state          <= IDLE;
      intf.rx_data   <= '0;
      intf.rx_done   <= 0;
      intf.rx_error  <= 0;
      shift_reg      <= '0;
      bit_cnt        <= 0;
      stop_cnt       <= 0;
      computed_parity <= 0;
      parity_bit     <= 0;
    end else begin
      // Default values
      intf.rx_done  <= 0;
      intf.rx_error <= 0;

      case (state)
        IDLE: begin
          if (intf.rx == START_BIT) begin  // detect falling edge (start bit)
            bit_cnt   <= 0;
            shift_reg <= '0;
            state     <= START;
          end
        end

        START: begin
          if (intf.rx == 1'b0) begin
            state <= DATA;
          end else begin
            intf.rx_error <= 1;  // false start bit
            state <= IDLE;
          end
        end

        DATA: begin
          shift_reg <= {intf.rx, shift_reg[DATA_WIDTH-1:1]};  // LSB first
          bit_cnt <= bit_cnt + 1;

          if (bit_cnt == DATA_WIDTH - 1) state <= (PARITY_EN == 0) ? STOP : PARITY;
          
        end

        PARITY: begin
          parity_bit <= intf.rx;

          computed_parity <= (^shift_reg) ^ (PARITY_EN == 1); // odd if 1, else even

          if (computed_parity != intf.rx) intf.rx_error <= 1; // parity error

          state <= STOP;
        end

        STOP: begin
          if (intf.rx != STOP_BIT) intf.rx_error <= 1; // framing error
          stop_cnt <= stop_cnt + 1;

          if (stop_cnt == STOP_BITS - 1) begin
            stop_cnt <= 0;
            state <= DONE;
          end
        end

        DONE: begin
          intf.rx_data <= shift_reg;
          intf.rx_done <= 1;
          state <= IDLE;
        end

        default: begin
          state <= IDLE;
        end
      endcase
    end
  end

endmodule
