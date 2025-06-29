module fifo #(
  parameter width = 8,
  parameter depth = 16
) (
  input  logic clk,
  input  logic rst_n,

  input  logic wr_en,
  input  logic rd_en,
  input  logic [width-1:0] din,

  output logic [width-1:0] dout,
  output logic full,
  output logic empty

);
    // internal storage
    logic [width-1:0] buffer [0:depth-1];
    logic [$clog2(depth)-1:0] wr_ptr, rd_ptr; // pointers
    logic [$clog2(depth):0] count;         // how many items in fifo

    // flags
    assign full  = (count == depth);
    assign empty = (count == 0);

    // always show data at read pointer
    assign dout = buffer[rd_ptr];

    // write side
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            count  <= 0;
        end else begin
            if (wr_en && !full) begin
                buffer[wr_ptr] <= din;
                wr_ptr <= (wr_ptr == depth-1) ? 0 : wr_ptr + 1;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                rd_ptr <= (rd_ptr == depth-1) ? 0 : rd_ptr + 1;
                count <= count - 1;
            end
        end
    end

    // read pointer reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end
    end

endmodule