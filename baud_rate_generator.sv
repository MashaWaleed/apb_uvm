module baud_rate_generator #(
    parameter CLK_FREQ = 100_000_000,  // clock frequency in Hz
    parameter BAUD_RATE = 115200,      // baud rate
    parameter OVERSAMPLE = 16,         // oversampling factor
    parameter SIMULATION = 1           // 1 for simulation (faster), 0 for real hardware
)(
    input  logic clk,      // system clock
    input  logic rst_n,    // active low reset
    output logic tick      // baud tick output
);

    // calculate the counter value for the desired baud rate
    localparam COUNTER_MAX = SIMULATION ? 5 : (CLK_FREQ / (BAUD_RATE * OVERSAMPLE)) - 1;
    localparam COUNTER_WIDTH = $clog2(COUNTER_MAX + 1);
    
    logic [COUNTER_WIDTH-1:0] counter;
    
    // counter logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            tick <= 0;
        end else begin
            if (counter == COUNTER_MAX) begin
                counter <= 0;
                tick <= 1;
            end else begin
                counter <= counter + 1;
                tick <= 0;
            end
        end
    end

endmodule 