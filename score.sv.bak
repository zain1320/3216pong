module score(
    input score_one, score_two, 
    output [7:0] HEX[5:0]
);

    // P100P2
    
    logic p;
    logic one;
    logic two;

    intial begin
        p = 4'b1100
        one = 4'b0001;
        two = 4'b0010;
    end

    seg_display_output seg_out_p1_1(p, HEX5);
    seg_display_output seg_out_p1_2(one, HEX4);
    seg_display_output seg_out_score_one(score_one, HEX3); 
    seg_display_output seg_out_p2_1(p, HEX2);
    seg_display_output seg_out_p2_2(two, HEX1);
    seg_display_output seg_out_score_two(score_two, HEX0); 

endmodule