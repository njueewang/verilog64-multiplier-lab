`timescale 1ns / 1ps

// V1: unsigned 64 x 64 multiplier using an unrolled shift-and-add structure.
module multiplier64 (
    input  wire [63:0]  a,
    input  wire [63:0]  b,
    output reg  [127:0] product
);

    integer bit_index;

    always @* begin
        product = 128'b0;
        for (bit_index = 0; bit_index < 64; bit_index = bit_index + 1) begin
            if (b[bit_index]) begin
                product = product + ({64'b0, a} << bit_index);
            end
        end
    end

endmodule
