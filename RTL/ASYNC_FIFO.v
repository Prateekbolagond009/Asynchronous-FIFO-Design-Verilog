
module ASYNC_FIFO #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
)(
    input  wire                  W_CLK,
    input  wire                  W_RST,
    input  wire                  W_INC,

    input  wire                  R_CLK,
    input  wire                  R_RST,
    input  wire                  R_INC,

    input  wire [DATA_WIDTH-1:0] WR_DATA,

    output wire [DATA_WIDTH-1:0] RD_DATA,
    output wire                  FULL,
    output wire                  EMPTY
);

    wire [ADDR_WIDTH-1:0] waddr, raddr;

    wire [ADDR_WIDTH:0] wptr;
    wire [ADDR_WIDTH:0] rptr;

    wire [ADDR_WIDTH:0] wq2_rptr;
    wire [ADDR_WIDTH:0] rq2_wptr;

    // FIFO memory
    FIFO_MEM_CNTRL #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_mem (
        .wclk   (W_CLK),
        .wclken (W_INC & ~FULL),
        .waddr  (waddr),
        .raddr  (raddr),
        .wdata  (WR_DATA),
        .rdata  (RD_DATA)
    );

    // Write controller
    FIFO_WR #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_wr (
        .wclk     (W_CLK),
        .wrst_n   (W_RST),
        .winc     (W_INC),
        .wq2_rptr (wq2_rptr),
        .waddr    (waddr),
        .wptr     (wptr),
        .wfull    (FULL)
    );

    // Read controller
    FIFO_RD #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_rd (
        .rclk     (R_CLK),
        .rrst_n   (R_RST),
        .rinc     (R_INC),
        .rq2_wptr (rq2_wptr),
        .raddr    (raddr),
        .rptr     (rptr),
        .rempty   (EMPTY)
    );

    // Read pointer synchronization
    DF_SYNC #(
        .WIDTH(ADDR_WIDTH+1)
    ) sync_r2w (
        .clk   (W_CLK),
        .rst_n (W_RST),
        .d_in  (rptr),
        .d_out (wq2_rptr)
    );

    // Write pointer synchronization
    DF_SYNC #(
        .WIDTH(ADDR_WIDTH+1)
    ) sync_w2r (
        .clk   (R_CLK),
        .rst_n (R_RST),
        .d_in  (wptr),
        .d_out (rq2_wptr)
    );

endmodule
