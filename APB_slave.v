module APB_slave #(
        parameter ADDR_WIDTH = 16 ,
        parameter DATA_WIDTH = 32 ,
        parameter ADDR_slave = 2'b00 ,
        parameter MY_PROT = 3'b000,
        localparam PSTRB_WIDTH = DATA_WIDTH / 8)(
    //inputs from Master to Slave
    input PCLK ,PRESETn ,
    input [ADDR_WIDTH-1:0] PADDR,
    input [2:0] PPROT,
    input PSELx ,PENABLE,PWRITE,
    input [DATA_WIDTH-1:0] PWDATA,
    input [PSTRB_WIDTH-1:0] PSTRB,

    //inputs from Periphral to Slave 
    input ready,
    input [DATA_WIDTH-1:0]readData,

    //outputs from Slave to Master
    output reg [DATA_WIDTH-1:0] PRDATA, PSLVERR,
    output reg PREADY,

    //outputs from Slave to Periphral
    output reg [DATA_WIDTH-1:0]writeData,address,
    output reg [PSTRB_WIDTH-1:0] strb,      //modified to use PSTRB_WIDTH
    output reg write_read , enable
);

//States encoding
parameter IDLE = 3'b000;
parameter ACCESS = 3'b001;
parameter WAIT = 3'b011;
parameter ERROR = 3'b010;

//localparam PSTRB_WIDTH = DATA_WIDTH / 8;

reg [2:0] ns ,cs; 
wire chosenSlave;
//integer Range;
integer i;

/////////////////STATE MEMORY/////////////
always@(posedge PCLK or negedge PRESETn)begin
    if(!PRESETn)begin
        cs <= IDLE;
        PRDATA <= 0;
        PREADY <= 0;
        enable <= 0;
        writeData <= 0;
        address <= 0;
        write_read <= 0;
        PSLVERR <= 0;
        strb <= 0;
    end
    else begin
        cs <= ns;
    end
    end

//////////////////NEXT STATE///////////////////
always@(*)begin
    case(cs)
    IDLE : begin
        if (chosenSlave && PENABLE && PPROT == MY_PROT && ready )
        ns = ACCESS;
        else if (chosenSlave && PENABLE && PPROT == MY_PROT && !ready)
        ns = WAIT;
        else if (chosenSlave && PENABLE && PPROT != MY_PROT)
        ns = ERROR;
        else
        ns = IDLE;
    end
    ACCESS : begin
         ns = IDLE;
    end
    WAIT : begin
        if (ready)
        ns = ACCESS;
        else
        ns = WAIT;
    end
    ERROR : begin
        ns = IDLE ;
    end
    default : ns = IDLE;
endcase
end

/////////OUTPUT///////////////
always@(*)begin
    case(cs)
    IDLE : begin
        PREADY = 0;
        //PRDATA = 0;
        //address = 0;
        //write_read = 0;
        enable = 0;
        //writeData = 0;
        if (PPROT == MY_PROT)
        PSLVERR = 0;
        else
        PSLVERR = 1;
    end
    ACCESS : begin
        if (PADDR > 32'h0000_FFFF || PADDR % 4 != 0)    //it was 0000_00FF && PADDR % 4
        PSLVERR = 1;
        else begin
        PREADY = 1;
        address = PADDR;
        write_read = PWRITE;
        enable = PENABLE;
        if(PWRITE ) begin
        writeData = PWDATA;
        strb = PSTRB;
        end
        else begin
        PRDATA = readData;
        strb = 0;
        end
        end
    end
    WAIT : begin
        PREADY = 0;
        enable =0;
        //PRDATA = readData;
    end
    default : begin
        PREADY = 0;
        enable = 0;
        PSLVERR = 0;
    end
endcase
end

assign chosenSlave = (PSELx && PADDR[ADDR_WIDTH-1:ADDR_WIDTH-2] == ADDR_slave)? 1 : 0 ; // It was DATA_WIDTH-1:DATA_WIDTH-2
//assign Range = $clog2(PSTRB) * 8;
   
endmodule


 
