
module FIFO_RD #(
    parameter ADDR_WIDTH = 3
)(
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  rinc,
    input  wire [ADDR_WIDTH:0]   rq2_wptr,

    output wire [ADDR_WIDTH-1:0] raddr,
    output reg  [ADDR_WIDTH:0]   rptr,
    output reg                   rempty
);

    reg  [ADDR_WIDTH:0] rbin;

    wire [ADDR_WIDTH:0] rbin_next;
    wire [ADDR_WIDTH:0] rgray_next;
    wire                rempty_val;

    // Read address
    assign raddr = rbin[ADDR_WIDTH-1:0];

    // Binary pointer increment
    assign rbin_next = rbin + (rinc & ~rempty);

    // Binary to Gray conversion
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;

    // EMPTY condition
    assign rempty_val = (rgray_next == rq2_wptr);

    // Read pointer and EMPTY flag update
    always @(posedge rclk or negedge rrst_n) begin

        if (!rrst_n) begin
            rbin   <= 0;
            rptr   <= 0;
            rempty <= 1'b1;
        end
        else begin
            rbin   <= rbin_next;
            rptr   <= rgray_next;
            rempty <= rempty_val;
        end

    end

endmodule
