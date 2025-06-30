// Assertions for an APB (Advanced Peripheral Bus) module

module apb_assertions(
    input logic        PCLK,      // APB clock
    input logic        PRESETn,   // APB reset (active low)
    input logic        PSEL,      // APB select
    input logic        PENABLE,   // APB enable
    input logic        PWRITE,    // APB write
    input logic [31:0] PADDR,     // APB address
    input logic [31:0] PWDATA,    // APB write data
    input logic [31:0] PRDATA,    // APB read data
    input logic        PREADY,     // APB ready
    input logic        PSTRB,    // APB strobe
    input logic [2:0]  PPROT    // APB protection
);

    // Ensure PREADY is deasserted when PRESETn is low
    property reset;
        @(posedge PCLK) disable iff (!PRESETn)
        !PRESETn |-> !PREADY
    endproperty
    assert_rst: assert property (reset) else $error("PREADY should be deasserted during reset");



    // Ensure PENABLE is only asserted after PSEL
    property enabled;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL |=> PENABLE;
    endproperty
    assert_enabled: assert property (enabled) else $error("PENABLE should only be asserted after PSEL");

    // Ensure PADDR is stable during a transaction
    property address;
        @(posedge PCLK)  disable iff (!PRESETn)
        PSEL |=> $stable(PADDR);
    endproperty
    assert_address: assert property (address) else $error("PADDR should remain stable during a transaction");



    // Ensure PWRITE is stable low during a read transaction
    property read_stable;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL |=> $stable(!PWRITE);
    endproperty
    assert_read_stable: assert property (read_stable) else $error("PWRITE should remain stable low during a read transaction");

    // Ensure PWRITE is stable during a write transaction
    property write_stable;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL |=> $stable(PWRITE);
    endproperty
    assert_write_stable: assert property (write_stable) else $error("PWRITE should remain stable during a write transaction");

    // Ensure PWRITE remains stable during a transaction (read or write)
    property transaction_stable;
        read_stable or write_stable;
    endproperty
    assert_transaction: assert property (transaction_stable) else $error("PWRITE should remain stable during a transaction");



    // Ensure PWDATA is stable during a write transaction
    property write_data;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL && PWRITE |=> $stable(PWDATA);
    endproperty
    assert_write_data: assert property (write_data) else $error("PWDATA should remain stable during a write transaction");

    // Ensure PSTRB is stable during a write transaction
    property write_strobe;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL && PWRITE |=> $stable(PSTRB) && PSTRB != 0;
    endproperty
    assert_write_strobe: assert property (write_strobe) else $error("PSTRB should remain stable during a write transaction and not be 0");

        

    //Ensure successful transaction is indicated by PREADY
    property successful;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL && PENABLE |-> ##[1:$] PREADY;
    endproperty
    assert_successful: assert property (successful) else $error("PREADY should be asserted during a successful transaction");

    // Ensure successful transaction is finished by deasserting PENABLE
    property finish_transaction;
        @(posedge PCLK) disable iff (!PRESETn)
        PSEL && PENABLE && PREADY |=> !PENABLE;
    endproperty
    assert_finish_transaction: assert property (finish_transaction) else $error("PENABLE should be deasserted after a successful transaction");

endmodule