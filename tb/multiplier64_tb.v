`timescale 1ns / 1ps

module multiplier64_tb;

    reg  [63:0] a;
    reg  [63:0] b;
    wire [127:0] product;
    integer error_count;
    integer vector_count;
    integer random_index;

    multiplier64 dut (
        .a      (a),
        .b      (b),
        .product(product)
    );

    task automatic check_product;
        input [63:0] test_a;
        input [63:0] test_b;
        reg   [127:0] expected;
        begin
            a = test_a;
            b = test_b;
            expected = {64'b0, test_a} * {64'b0, test_b};
            #1;
            vector_count = vector_count + 1;

            if (product !== expected) begin
                error_count = error_count + 1;
                $display(
                    "FAIL: a=%h b=%h expected=%h actual=%h",
                    test_a, test_b, expected, product
                );
            end
        end
    endtask

    initial begin
        error_count  = 0;
        vector_count = 0;
        a = 64'b0;
        b = 64'b0;

        check_product(64'd0, 64'd0);
        check_product(64'd1, 64'd1);
        check_product(64'd1, 64'hFFFF_FFFF_FFFF_FFFF);
        check_product(64'hFFFF_FFFF_FFFF_FFFF, 64'hFFFF_FFFF_FFFF_FFFF);
        check_product(64'h0123_4567_89AB_CDEF, 64'hFEDC_BA98_7654_3210);
        check_product(64'h8000_0000_0000_0000, 64'd2);
        check_product(64'h0000_0001_0000_0000, 64'h0000_0001_0000_0000);
        check_product(64'hDEAD_BEEF_0123_4567, 64'h0000_0000_CAFE_BABE);

        for (random_index = 0; random_index < 200; random_index = random_index + 1) begin
            check_product({$random, $random}, {$random, $random});
        end

        if (error_count == 0) begin
            $display(
                "MULTIPLIER64 V1 TEST PASSED: %0d vectors",
                vector_count
            );
        end else begin
            $display(
                "MULTIPLIER64 V1 TEST FAILED: %0d errors in %0d vectors",
                error_count, vector_count
            );
            $fatal(1);
        end

        $finish;
    end

endmodule
