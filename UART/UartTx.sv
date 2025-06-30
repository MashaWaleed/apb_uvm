import shared_pkg::*;

module UartTx #(
  parameter int PARITY_EN  = 0, // 0 = no parity, 1 = odd, 2 = even
  parameter int STOP_BITS  = 1 
)(
  uart_tx_if.DUT intf
);

  localparam START_BIT = 1'b0; // start bit is always low
  localparam LINE_IDLE = 1'b1; // idle line is high
  
  uart_states_e state;

  logic [DATA_WIDTH-1:0] shift_reg;
  logic [3:0] bit_cnt;
  logic [1:0] stop_cnt;
  logic parity_bit;

  always_ff @(posedge intf.clk or negedge intf.rst_n) begin

    if (!intf.rst_n) begin
      state      <= IDLE;
      intf.tx    <= 1'b1;
      intf.tx_done <= 1'b0;
      shift_reg  <= '0;
      bit_cnt    <= 0;
      stop_cnt   <= 0;
      parity_bit <= 0;

    end else begin

      intf.tx_done <= 1'b0; // default

      case (state)

        IDLE: begin
          intf.tx <= LINE_IDLE; // idle line high
          if (intf.tx_start) begin
            shift_reg <= intf.tx_data;
            bit_cnt <= 0;
            parity_bit <= (PARITY_EN == 0)  ? 1'b0 
                                            : (PARITY_EN == 2) ? ~(^intf.tx_data) : (^intf.tx_data); // even or odd
            state <= START;
          end

        end

        START: begin
          intf.tx <= START_BIT; // start bit
          state <= DATA;
        end

        DATA: begin
          intf.tx <= (shift_reg[0]);
          shift_reg <= (shift_reg >> 1);
          bit_cnt <= (bit_cnt + 1);

          if (bit_cnt == DATA_WIDTH - 1)  state <= (PARITY_EN == 0) ? STOP : PARITY;

        end

        PARITY: begin
          intf.tx <= parity_bit;
          state <= STOP;
        end

        STOP: begin
          intf.tx <= 1'b1;
          stop_cnt <= stop_cnt + 1;

          if (stop_cnt == STOP_BITS - 1) begin
            stop_cnt <= 0;
            state <= DONE;
          end
        end

        DONE: begin
          intf.tx_done <= 1'b1;
          state <= IDLE;
        end

        default: begin
          state <= IDLE;
          intf.tx <= LINE_IDLE;
        end

      endcase
    end
  end

endmodule
