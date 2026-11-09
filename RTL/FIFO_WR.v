
module FIFO_WR #(
    parameter ADDR_WIDTH = 3
)(
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  winc,
    input  wire [ADDR_WIDTH:0]   wq2_rptr,

    output wire [ADDR_WIDTH-1:0] waddr,
    output reg  [ADDR_WIDTH:0]   wptr,
    output reg                   wfull
);

    reg  [ADDR_WIDTH:0] wbin;

    wire [ADDR_WIDTH:0] wbin_next;
    wire [ADDR_WIDTH:0] wgray_next;
    wire                wfull_val;

    // Write address
    assign waddr = wbin[ADDR_WIDTH-1:0];

    // Binary pointer increment
    assign wbin_next = wbin + (winc & ~wfull);

    // Binary to Gray conversion
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;

    // FULL condition
    assign wfull_val =
        (wgray_next == {
            ~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1],
             wq2_rptr[ADDR_WIDTH-2:0]
        });

    // Write pointer and FULL flag update
    always @(posedge wclk or negedge wrst_n) begin

        if (!wrst_n) begin
            wbin  <= 0;
            wptr  <= 0;
            wfull <= 1'b0;
        end
        else begin
            wbin  <= wbin_next;
            wptr  <= wgray_next;
            wfull <= wfull_val;
        end

    end

endmodule
