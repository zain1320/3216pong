//`include "VGA_Controller.v"
//`include "Clock_Divider.sv"
module Ping_Pong_Final (
    input MAX10_CLK1_50,
    input [9:0] SW,
    input [1:0] KEY,
    input [3:0] gpio,
    output[7:0] HEX[5:0],
    output [9:0] LED,

    // VGA outputs
    output [3:0] R, G, B,
    output VGA_hsync, VGA_vsync
);

    
	 logic pixel_clk, t_clk, disp_ena, hsync, vsync, sw_en, boost, op;
    logic [1:0] paddle_R_detect_edge, paddle_L_detect_edge;
    logic [3:0] r, b, g, seg0, seg1, ball_detect_edge;
    logic [5:0] bounce_en;
    logic [7:0] collision_detect;
    logic signed [31:0] col, row, 
                 ball_size_y, ball_size_x,  // Ball size
                 ball_ini_x, ball_ini_y,    // Ball initial position
                 ball_off_x, ball_off_y,    // Ball offset from initial position
                 ball_vel_x, ball_vel_y,    // Ball velocity in pixel/clock cycle

                 paddle_R_size_y, paddle_R_size_x,  // Right paddle size
                 paddle_R_ini_x, paddle_R_ini_y,    // Right paddle initial position
                 paddle_R_off_x, paddle_R_off_y,    // Right paddle offset from initial position
                 paddle_R_vel,                      // Right paddle velocity in pixel/clock cycle

                 paddle_L_size_y, paddle_L_size_x,  // Left paddle size
                 paddle_L_ini_x, paddle_L_ini_y,    // Left paddle initial position
                 paddle_L_off_x, paddle_L_off_y,    // Left paddle offset from initial position
                 paddle_L_vel,                      // Left paddle velocity in pixel/clock cycle
                 rect_boost_dist;
/*
    Initialize all the variables needed
    to draw and make the rectangle move
*/
    initial begin
        boost = 1'b1;
        r = 4'b1111;
        g = 4'b1111;
        b = 4'b1111;
        ball_size_x = 32'd25;
        ball_size_y = 32'd25;
        ball_ini_x = 32'd269;
        ball_ini_y = 32'd189;
        ball_off_x = 32'd0;
        ball_off_y = 32'd0;
        ball_vel_x = 32'd4;
        ball_vel_y = 32'd4;
        rect_boost_dist = 32'd20;

        paddle_R_size_x = 32'd10;
        paddle_R_size_y = 32'd150;
        paddle_R_ini_x = 32'd600;
        paddle_R_ini_y = 32'd100;
        paddle_R_off_x = 32'd0;
        paddle_R_off_y = 32'd0;
        paddle_R_vel = 32'd6;

        paddle_L_size_x = 32'd10;
        paddle_L_size_y = 32'd150;
        paddle_L_ini_x = 32'd40;
        paddle_L_ini_y = 32'd189;
        paddle_L_off_x = 32'd0;
        paddle_L_off_y = 32'd0;
        paddle_L_vel = 32'd6;
        
        bounce_en = 4'b111111;
		  
	

    end

/*
    Calling important modules
*/
    pll pll_inst (.inclk0(MAX10_CLK1_50), .c0(pixel_clk));
    clock_divider div (MAX10_CLK1_50, 32'd1250000, t_clk);
    //xor4 xor4 (SW[3:0], sw_en);
    xor4 xor4 (~gpio[3:0], sw_en);
    assign op = sw_en & ball_detect_edge[0] & ball_detect_edge[1] & ball_detect_edge[2] & ball_detect_edge[3];

    Edge_Detect detect (ball_size_x, 
                        ball_size_y,
                        ball_ini_x, 
                        ball_ini_y,
                        ball_off_x, 
                        ball_off_y,
                        ball_vel_x,
                        ball_vel_y,

                        paddle_R_size_x,
                        paddle_R_size_y,
                        paddle_R_ini_x,
                        paddle_R_ini_y,
                        paddle_R_off_x,
                        paddle_R_off_y,
 
                        paddle_L_size_x,
                        paddle_L_size_y,
                        paddle_L_ini_x,
                        paddle_L_ini_y,
                        paddle_L_off_x,
                        paddle_L_off_y,

                        ball_detect_edge,
                        paddle_R_detect_edge, 
                        paddle_L_detect_edge,
                        collision_detect);

    vga_controller controller (.pixel_clk  (pixel_clk),
                               .reset_n    (KEY[0]),
                               .h_sync     (hsync),
                               .v_sync     (vsync),
                               .disp_ena   (disp_ena),
                               .column     (col),
                               .row        (row));

/*
    Display error message here
*/
     seg_display_output seg_out_p1_1(4'b1100, HEX[5]); // P
    seg_display_output seg_out_p1_2(4'b1101, HEX[4]); // 1.
    seg_display_output seg_out_score_one(score_one, HEX[3]);
    seg_display_output seg_out_p2_1(4'b1100, HEX[2]); // P
    seg_display_output seg_out_p2_2(4'b1110, HEX[1]); // 2.
    seg_display_output seg_out_score_two(score_two, HEX[0]);

    assign LED[7:0] = collision_detect[7:0];
/*
    Time block controlling the reset
    and the rectangle's movement based
    on the switches
*/
    always @(posedge t_clk) begin
        if (~KEY[0]) begin
            ball_size_x = 32'd25;
            ball_size_y = 32'd25;
            ball_ini_x = 32'd269;
            ball_ini_y = 32'd189;
            ball_off_x = 32'd0;
            ball_off_y = 32'd0;
            ball_vel_x = 32'd4;
            ball_vel_y = 32'd4;

            paddle_R_size_x = 32'd10;
            paddle_R_size_y = 32'd150;
            paddle_R_ini_x = 32'd600;
            paddle_R_ini_y = 32'd100;
            paddle_R_off_x = 32'd0;
            paddle_R_off_y = 32'd0;
            paddle_R_vel = 32'd6;

            paddle_L_size_x = 32'd10;
            paddle_L_size_y = 32'd150;
            paddle_L_ini_x = 32'd40;
            paddle_L_ini_y = 32'd189;
            paddle_L_off_x = 32'd0;
            paddle_L_off_y = 32'd0;
            paddle_L_vel = 32'd6;

            bounce_en = 4'b111111;

            r = 4'b1111;
            g = 4'b1111;
            b = 4'b1111;
				
				
        end else begin
           
            ball_off_y <= ball_off_y + ball_vel_y;
            ball_off_x <= ball_off_x + ball_vel_x;
            

            if (~ball_detect_edge[0] && bounce_en[0]) begin // bounce off bottom
                ball_vel_y <= -ball_vel_y;
                bounce_en[0] <= 1'b0;
            end

            if (~ball_detect_edge[1] && bounce_en[1]) begin // bounce off right
                ball_vel_x <= -ball_vel_x;
                bounce_en[1] <= 1'b0;
            end

            if (~ball_detect_edge[2] && bounce_en[2]) begin // bounce off top
                ball_vel_y <= -ball_vel_y;
                bounce_en[2] <= 1'b0;
            end

            if (~ball_detect_edge[3] && bounce_en[3]) begin // bounce off left
                ball_vel_x <= -ball_vel_x;
                bounce_en[3] <= 1'b0;
            end

            if (collision_detect[0] & (collision_detect[2] | collision_detect[3] | collision_detect[4]) && bounce_en[4]) begin
                ball_vel_x <= -ball_vel_x; 
                bounce_en[4] <= 1'b0;
            end

            if (collision_detect[1] & (collision_detect[5] | collision_detect[6] | collision_detect[7]) && bounce_en[5]) begin
                ball_vel_x <= -ball_vel_x; 
                bounce_en[5] <= 1'b0;
            end

            // Needed to stabilise each bounce
            if (ball_detect_edge[0]) bounce_en[0] <= 1'b1;
            if (ball_detect_edge[1]) bounce_en[1] <= 1'b1;
            if (ball_detect_edge[2]) bounce_en[2] <= 1'b1;
            if (ball_detect_edge[3]) bounce_en[3] <= 1'b1;
            if (~collision_detect[0]) bounce_en[4] <= 1'b1;
            if (~collision_detect[1]) bounce_en[5] <= 1'b1;
				
	
				
            // Paddle control
            if (~gpio[0] && (gpio[0] ^ gpio[1]) && paddle_R_detect_edge[0]) paddle_R_off_y <= paddle_R_off_y + paddle_R_vel; // Right paddle going down
            if (~gpio[1] && (gpio[0] ^ gpio[1]) && paddle_R_detect_edge[1]) paddle_R_off_y <= paddle_R_off_y - paddle_R_vel; // Right paddle going up
            if (~gpio[2] && (gpio[2] ^ gpio[3]) && paddle_L_detect_edge[0]) paddle_L_off_y <= paddle_L_off_y + paddle_L_vel; // Left paddle going down
            if (~gpio[3] && (gpio[2] ^ gpio[3]) && paddle_L_detect_edge[1]) paddle_L_off_y <= paddle_L_off_y - paddle_L_vel; // Left paddle going up
				

        end
        
    end

/*
    This displays the rectangle on the screen 
    at whatever position it is currently at
*/
    always @(posedge pixel_clk) begin

      if (disp_ena == 1'b1) begin
		
        // Draw the ball (keep it white or your chosen color)
        if (((col > ball_ini_x + ball_off_x) & 
            (col <= ball_ini_x + ball_size_x + ball_off_x) & 
            (row > ball_ini_y + ball_off_y) & 
            (row <= ball_ini_y + ball_size_y + ball_off_y))) begin
            R <= r;
            G <= g;
            B <= b;	
				
        // Draw the right paddle in blue
        end else if ((col > paddle_R_ini_x + paddle_R_off_x) & 
                     (col <= paddle_R_ini_x + paddle_R_size_x + paddle_R_off_x) & 
                     (row > paddle_R_ini_y + paddle_R_off_y) & 
                     (row <= paddle_R_ini_y + paddle_R_size_y + paddle_R_off_y)) begin
            R <= 4'b0000;
            G <= 4'b0000;
            B <= 4'b1111; // Full intensity for blue
				
        // Draw the left paddle in red
        end else if ((col > paddle_L_ini_x + paddle_L_off_x) & 
                     (col <= paddle_L_ini_x + paddle_L_size_x + paddle_L_off_x) & 
                     (row > paddle_L_ini_y + paddle_L_off_y) & 
                     (row <= paddle_L_ini_y + paddle_L_size_y + paddle_L_off_y)) begin
            R <= 4'b1111; // Full intensity for red
            G <= 4'b0000;
            B <= 4'b0000;
				
        end else begin
            // Background color
            R <= 4'd0;
            G <= 4'd0;
            B <= 4'd0;
        end
    end else begin
        // If not in display enable area, set output to black
        R <= 4'd0;
        G <= 4'd0;
        B <= 4'd0;
    end

    VGA_hsync <= hsync;
    VGA_vsync <= vsync;
	 
end

endmodule

module xor4 (
    input logic [3:0] in,
    output logic out);

    always
        case (in)
            4'b0000: out = 1'b1;
            4'b0001: out = 1'b1;
            4'b0010: out = 1'b1;
            4'b0100: out = 1'b1;
            4'b1000: out = 1'b1;
            default: out = 1'b0; 
        endcase

endmodule

module mux2 (input logic op,
            input logic [3:0] a, b,
            output logic [3:0] z);
    always
        case (op)
            0: z = a;
            1: z = b;
            default: z = 4'd0;
        endcase
endmodule

