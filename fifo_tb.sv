module fifo_tb;
    localparam width = 8;
    localparam depth = 16;

    // clock and reseet
    logic clk;
    logic rst_n;

    //fif signals
    logic wr_en;
    logic rd_en;
    logic [width-1:0] din;
    logic [width-1:0] dout;
    logic full;
    logic empty;

    //fifo under test
    fifo #(width, depth) uut (
        .clk   (clk),
        .rst_n (rst_n),
        .wr_en (wr_en),
        .rd_en (rd_en),
        .din   (din),
        .dout  (dout),
        .full  (full),
        .empty (empty)
    );

    // clock gen
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns period

    // drive signals
    initial begin
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        #20;
        rst_n = 1;

        // push 10 items
        repeat (10) begin
            @(posedge clk);
            wr_en = 1;
            din   = $random;
        end
        @(posedge clk);
        wr_en = 0;
        // pop 5 items
        repeat (5) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;
        // random mix
        repeat (20) begin
            @(posedge clk);
            wr_en = $urandom_range(0,1);
            rd_en = $urandom_range(0,1);
            din   = $random;
        end

        #50;
        $finish;
    end
    // waveform & monitor

    
    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        $monitor("time=%0t wr=%b rd=%b din=%0h dout=%0h full=%b empty=%b", 
                 $time,
                 wr_en,
                 rd_en,
                 din,
                 dout,
                 full,
                 empty
        );
    end
endmodule
