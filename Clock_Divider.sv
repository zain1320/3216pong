module clock_divider (input clk_in,
                    input logic [31:0] threshold,
                    output clk_out
);
    logic [31:0] count;

    initial begin
        //clk_out = 0;
        count = 32'd0;
    end

    always @(posedge clk_in) begin
        count = count + 32'd1;
        if (count >= threshold) begin // 32'd12500000 is a good threshold
            clk_out = ~clk_out;
            $display("%b",clk_out);
            count = 32'd0;
        end
    end
endmodule