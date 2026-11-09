module DF_SYNC #(
    parameter WIDTH = 4
)(
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] d_in,
    output wire [WIDTH-1:0] d_out
);
    reg [WIDTH-1:0] q1, q2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q1 <= {WIDTH{1'b0}};
            q2 <= {WIDTH{1'b0}};
        end else begin
            q1 <= d_in;
            q2 <= q1;
        end
    end

    assign d_out = q2;
endmodule
