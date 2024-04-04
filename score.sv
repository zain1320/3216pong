module score(
    input score_one, score_two, 
    output [7:0] HEX[5:0]
);

    // P100P2

    seg_display_output seg_out_p1_1(4'b1100, HEX[5]); // P
    seg_display_output seg_out_p1_2(4'b1101, HEX[4]); // 1.
    seg_display_output seg_out_score_one(score_one, HEX[3]);
    seg_display_output seg_out_p2_1(4'b1100, HEX[2]); // P
    seg_display_output seg_out_p2_2(4'b1110, HEX[1]); // 2.
    seg_display_output seg_out_score_two(score_two, HEX[0]);

endmodule