module RAM #(
    parameter WIDTH = 32,  // Data width
    parameter ADDR_WIDTH = 16 // Size of the RAM
) (
    input logic clk,                  // Clock signal
    input logic rst_n,                // Active low reset
    input logic enable,                //enable read and write
    input logic we,                   // Write enable
    input logic [ADDR_WIDTH-1:0] addr, // Address bus
    input logic [WIDTH-1:0] din,      // Data input
    input logic [(WIDTH/8)-1:0] pstrb,   // Byte enable
    output logic ready,               // Ready signal
    output logic [WIDTH-1:0] dout     // Data output
);

    assign ready = enable; // Always ready for simplicity
    reg [WIDTH-1:0] mem [(ADDR_WIDTH/(4*4))-1:0];   //memory is sixteenth the available space due to 2-bit address encoding and word alignment

    // Registers
    reg [WIDTH-1:0] SYS_STATUS_REG;
    reg [WIDTH-1:0] INT_CTRL_REG;
    reg [WIDTH-1:0] DEV_ID_REG;
    reg [WIDTH-1:0] MEM_CTRL_REG;
    reg [WIDTH-1:0] TEMP_SENSOR_REG;
    reg [WIDTH-1:0] ADC_CTRL_REG;
    reg [WIDTH-1:0] DBG_CTRL_REG;
    reg [WIDTH-1:0] GPIO_DATA_REG;
    reg [WIDTH-1:0] DAC_OUTPUT_REG;
    reg [WIDTH-1:0] VOLTAGE_CTRL_REG;
    reg [WIDTH-1:0] CLK_CONFIG_REG;
    reg [WIDTH-1:0] TIMER_COUNT_REG;
    reg [WIDTH-1:0] INPUT_DATA_REG;
    reg [WIDTH-1:0] OUTPUT_DATA_REG;
    reg [WIDTH-1:0] DMA_CTRL_REG;
    reg [WIDTH-1:0] SYS_CTRL_REG;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            SYS_STATUS_REG <= '0;
            INT_CTRL_REG <= '0;
            DEV_ID_REG <= '0;
            MEM_CTRL_REG <= '0;
            TEMP_SENSOR_REG <= '0;
            ADC_CTRL_REG <= '0;
            DBG_CTRL_REG <= '0;
            GPIO_DATA_REG <= '0;
            DAC_OUTPUT_REG <= '0;
            VOLTAGE_CTRL_REG <= '0;
            CLK_CONFIG_REG <= '0;
            TIMER_COUNT_REG <= '0;
            INPUT_DATA_REG <= '0;
            OUTPUT_DATA_REG <= '0;
            DMA_CTRL_REG <= '0;
            SYS_CTRL_REG <= '0;

            dout <= '0;
        end
        else if (enable) begin
            if (we) begin
                case (addr)
				16'h0000: begin
                    update_reg(SYS_STATUS_REG, din, pstrb);
                end
                16'h0040: begin
                    update_reg(INT_CTRL_REG, din, pstrb);
                end
                16'h0080: begin
                    update_reg(DEV_ID_REG, din, pstrb);
                end
                16'h00c0: begin
                    update_reg(MEM_CTRL_REG, din, pstrb);
                end
                16'h0100: begin
                    update_reg(TEMP_SENSOR_REG, din, pstrb);
                end
                16'h0140: begin
                    update_reg(ADC_CTRL_REG, din, pstrb);
                end
                16'h0180: begin
                    update_reg(DBG_CTRL_REG, din, pstrb);
                end
                16'h01c0: begin
                    update_reg(GPIO_DATA_REG, din, pstrb);
                end
                16'h0200: begin
                    update_reg(DAC_OUTPUT_REG, din, pstrb);
                end
                16'h0240: begin
                    update_reg(VOLTAGE_CTRL_REG, din, pstrb);
                end
                16'h0280: begin
                    update_reg(CLK_CONFIG_REG, din, pstrb);
                end
                16'h02c0: begin
                    update_reg(TIMER_COUNT_REG, din, pstrb);
                end
                16'h0300: begin
                    update_reg(INPUT_DATA_REG, din, pstrb);
                end
                16'h0340: begin
                    update_reg(OUTPUT_DATA_REG, din, pstrb);
                end
                16'h0380: begin
                    update_reg(DMA_CTRL_REG, din, pstrb);
                end
                16'h03c0: begin
                    update_reg(SYS_CTRL_REG, din, pstrb);
                end
                default: begin
                    if(addr[ADDR_WIDTH-1:ADDR_WIDTH-2] == 2'b00) begin
                        update_mem(addr, din, pstrb); // Write to memory
                    end
                end

			    endcase
            end else begin
                case (addr)
				16'h0000: dout <= SYS_STATUS_REG;
				16'h0040: dout <= INT_CTRL_REG;
				16'h0080: dout <= DEV_ID_REG;
				16'h00c0: dout <= MEM_CTRL_REG;
				16'h0100: dout <= TEMP_SENSOR_REG;
				16'h0140: dout <= ADC_CTRL_REG;
				16'h0180: dout <= DBG_CTRL_REG;
				16'h01c0: dout <= GPIO_DATA_REG;
				16'h0200: dout <= DAC_OUTPUT_REG;
				16'h0240: dout <= VOLTAGE_CTRL_REG;
				16'h0280: dout <= CLK_CONFIG_REG;
				16'h02c0: dout <= TIMER_COUNT_REG;
				16'h0300: dout <= INPUT_DATA_REG;
				16'h0340: dout <= OUTPUT_DATA_REG;
				16'h0380: dout <= DMA_CTRL_REG;
				16'h03c0: dout <= SYS_CTRL_REG;
                default:  begin
                        if(addr[ADDR_WIDTH-1:ADDR_WIDTH-2] == 2'b00) begin
                            dout <= mem[addr/4]; // Read from memory
                        end else begin
                            dout <= '0; // Default case for unrecognized addresses
                        end
                    end
			    endcase
            end
        end
    end
    task update_mem(
        input logic [ADDR_WIDTH-1:0] addr,
        input logic [WIDTH-1:0] data,
        input logic [(WIDTH/8)-1:0] strb
    );
        for (int i = 0; i < (WIDTH/8); i++) begin
            if (strb[i]) begin
                mem[addr/4][(i*8) +: 8] <= data[(i*8) +: 8];
            end
        end
    endtask

    task update_reg(
        input logic [WIDTH-1:0] register,
        input logic [WIDTH-1:0] data,
        input logic [(WIDTH/8)-1:0] strb
    );
        for (int i = 0; i < (WIDTH/8); i++) begin
            if (strb[i]) begin
                register[(i*8) +: 8] <= data[(i*8) +: 8];
            end
        end
    endtask
endmodule