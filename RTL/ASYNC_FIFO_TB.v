
`timescale 1ns/1ps

module tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 3;
    parameter NUM_BYTES  = 9;

    reg W_CLK = 0, R_CLK = 0;
    reg W_RST, R_RST;
    reg W_INC, R_INC;

    reg [DATA_WIDTH-1:0] WR_DATA;

    wire [DATA_WIDTH-1:0] RD_DATA;
    wire FULL, EMPTY;

    ASYNC_FIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .W_CLK(W_CLK),
        .W_RST(W_RST),
        .W_INC(W_INC),
        .R_CLK(R_CLK),
        .R_RST(R_RST),
        .R_INC(R_INC),
        .WR_DATA(WR_DATA),
        .RD_DATA(RD_DATA),
        .FULL(FULL),
        .EMPTY(EMPTY)
    );

    // Clock generation
    always #5 W_CLK = ~W_CLK;
    always #12.5 R_CLK = ~R_CLK;

    // Test data and scoreboard
    reg [DATA_WIDTH-1:0] sent [0:NUM_BYTES-1];

    integer wr_cnt, rd_cnt, errors, i;

    reg full_seen;

    initial begin
        sent[0] = 8'hA1;
        sent[1] = 8'hB2;
        sent[2] = 8'hC3;
        sent[3] = 8'hD4;
        sent[4] = 8'hE5;
        sent[5] = 8'hF6;
        sent[6] = 8'h17;
        sent[7] = 8'h28;
        sent[8] = 8'h39;
    end

    // Reset
    initial begin
        W_RST = 0;
        R_RST = 0;

        W_INC = 0;
        R_INC = 0;
        WR_DATA = 0;

        wr_cnt = 0;
        rd_cnt = 0;
        errors = 0;
        full_seen = 0;

        #53;
        W_RST = 1;

        #17;
        R_RST = 1;
    end

    // Write process
    initial begin

        wait (W_RST && R_RST);

        @(negedge W_CLK);

        while (wr_cnt < NUM_BYTES) begin

            if (!FULL) begin
                W_INC = 1;
                WR_DATA = sent[wr_cnt];
                wr_cnt = wr_cnt + 1;
            end
            else begin
                W_INC = 0;
            end

            @(negedge W_CLK);

        end

        W_INC = 0;

    end

    // Monitor FULL
    always @(posedge W_CLK)
        if (FULL)
            full_seen <= 1;

    // Read process
    always @(negedge R_CLK) begin

        if (R_RST && rd_cnt < NUM_BYTES)
            R_INC <= !EMPTY;
        else
            R_INC <= 0;

    end

    // Scoreboard / data comparison
    always @(posedge R_CLK) begin

        if (R_RST && R_INC && !EMPTY &&
            rd_cnt < NUM_BYTES) begin

            if (RD_DATA === sent[rd_cnt]) begin

                $display(
                    "[%0t ns] READ #%0d : 0x%02h PASS",
                    $time, rd_cnt, RD_DATA
                );

            end
            else begin

                $display(
                    "[%0t ns] READ #%0d : 0x%02h FAIL",
                    $time, rd_cnt, RD_DATA
                );

                errors = errors + 1;

            end

            rd_cnt = rd_cnt + 1;

        end

    end

    // Write monitor
    always @(posedge W_CLK)
        if (W_INC && !FULL)
            $display(
                "[%0t ns] WRITE : 0x%02h",
                $time, WR_DATA
            );

    // End of test
    initial begin

        wait (rd_cnt == NUM_BYTES);

        repeat (6) @(posedge R_CLK);

        $display("--------------------------------");

        $display("Bytes written : %0d", wr_cnt);
        $display("Bytes read    : %0d", rd_cnt);

        $display(
            "FULL asserted : %s",
            full_seen ? "YES" : "NO"
        );

        $display("EMPTY at end  : %b", EMPTY);

        if (errors == 0 && EMPTY)
            $display("RESULT: TEST PASSED");
        else
            $display("RESULT: TEST FAILED");

        $finish;

    end

    // Watchdog
    initial begin

        #5000;

        $display("TIMEOUT - TEST FAILED");

        $finish;

    end

    // Waveform dump
    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

    end

endmodule
