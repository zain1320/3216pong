module edge_detect (
    input logic [31:0] ball_size_x, 
                       ball_size_y,  
                       ball_ini_x, 
                       ball_ini_y,     
                       ball_off_x, 
                       ball_off_y,

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

    output logic [3:0] ball_detect_edge, 
                       paddle_R_detect_edge, 
                       paddle_L_detect_edge, 
    output logic [7:0] collision_detect
);
    logic [31:0] screen_size_x,
                 screen_size_y,

                 ball_real_pos_x,
                 ball_real_pos_y,

                 paddle_R_real_pos_x,
                 paddle_R_real_pos_y,
                 
                 paddle_L_real_pos_x,
                 paddle_L_real_pos_y,
                 
                 ball_paddle_offset_R,
                 ball_paddle_offset_L;

    initial begin
        screen_size_x <= 32'd640;
        screen_size_y <= 32'd480; 
        //ball_real_pos_x <= ball_ini_x + ball_off_x;
        //ball_real_pos_y <= ball_ini_y + ball_off_y;
        ball_detect_edge <= 4'b1111;
        collision_detect <= 8'd0;
    end

// check left edge
    always @(*) begin
        ball_real_pos_x <= ball_ini_x + ball_off_x;
        ball_real_pos_y <= ball_ini_y + ball_off_y;

        paddle_R_real_pos_x <= paddle_R_ini_x + paddle_R_off_x;
        paddle_R_real_pos_y <= paddle_R_ini_y + paddle_R_off_y;

        paddle_L_real_pos_x <= paddle_L_ini_x + paddle_L_off_x;
        paddle_L_real_pos_y <= paddle_L_ini_y + paddle_L_off_y;

        // Edge detection for the ball
        if (ball_real_pos_y + ball_size_y >= screen_size_y)         ball_detect_edge[0] = 1'b0;
        else if (ball_real_pos_x + ball_size_x >= screen_size_x)    ball_detect_edge[1] = 1'b0;
        else if (ball_real_pos_y <= 32'd10)                         ball_detect_edge[2] = 1'b0;
        else if (ball_real_pos_x <= 32'd10)                         ball_detect_edge[3] = 1'b0;

        else begin
            ball_detect_edge[0] = 1'b1;
            ball_detect_edge[1] = 1'b1;
            ball_detect_edge[2] = 1'b1;
            ball_detect_edge[3] = 1'b1;
        end

        // Ball-paddle collision detection

        // Collision in the x direction for the RIGHT paddle
        if (ball_real_pos_x + ball_size_x >= paddle_R_real_pos_x) collision_detect[0] = 1'b1;
        else collision_detect[0] = 1'b0;


        // Collision in the x direction for the LEFT paddle
        if (ball_real_pos_x <= paddle_L_real_pos_x + paddle_L_size_x) collision_detect[1] = 1'b1;
        else collision_detect[1] = 1'b0;

        
        // Collisions in the y direction for the RIGHT paddle
        if ((ball_real_pos_y + ball_size_y >= paddle_R_real_pos_y) && (ball_real_pos_y <= paddle_R_real_pos_y + paddle_R_size_y)) collision_detect[2] = 1'b1;
        else collision_detect[2] = 1'b0;

        if ((ball_real_pos_y >= paddle_R_real_pos_y) && (ball_real_pos_y <= paddle_R_real_pos_y + paddle_R_size_y)) collision_detect[3] = 1'b1;
        else collision_detect[3] = 1'b0;
        
        if ((ball_real_pos_y + ball_size_y >= paddle_R_real_pos_y + paddle_R_size_y) && (ball_real_pos_y <= paddle_R_real_pos_y + paddle_R_size_y)) collision_detect[4] = 1'b1;
        else collision_detect[4] = 1'b0;
        

        // Collisions in the y direction for the LEFT paddle
        if ((ball_real_pos_y + ball_size_y >= paddle_L_real_pos_y) && (ball_real_pos_y <= paddle_L_real_pos_y + paddle_L_size_y)) collision_detect[5] = 1'b1;
        else collision_detect[5] = 1'b0;

        if ((ball_real_pos_y >= paddle_L_real_pos_y) && (ball_real_pos_y <= paddle_L_real_pos_y + paddle_L_size_y)) collision_detect[6] = 1'b1;
        else collision_detect[6] = 1'b0;
        
        if ((ball_real_pos_y + ball_size_y >= paddle_L_real_pos_y + paddle_L_size_y) && (ball_real_pos_y <= paddle_L_real_pos_y + paddle_L_size_y)) collision_detect[7] = 1'b1;
        else collision_detect[7] = 1'b0;
        
        // Edge detection for the Right paddle
        if (paddle_R_real_pos_y + paddle_R_size_y >= screen_size_y)         paddle_R_detect_edge[0] = 1'b0;
        else if (paddle_R_real_pos_x + paddle_R_size_x >= screen_size_x)    paddle_R_detect_edge[1] = 1'b0;
        else if (paddle_R_real_pos_y <= 32'd1)                              paddle_R_detect_edge[2] = 1'b0;
        else if (paddle_R_real_pos_x <= 32'd1)                              paddle_R_detect_edge[3] = 1'b0;

        else begin
            paddle_R_detect_edge[0] = 1'b1;
            paddle_R_detect_edge[1] = 1'b1;
            paddle_R_detect_edge[2] = 1'b1;
            paddle_R_detect_edge[3] = 1'b1;
        end

        // Edge detection for the Right paddle
        if (paddle_L_real_pos_y + paddle_L_size_y >= screen_size_y)         paddle_L_detect_edge[0] = 1'b0;
        else if (paddle_L_real_pos_x + paddle_L_size_x >= screen_size_x)    paddle_L_detect_edge[1] = 1'b0;
        else if (paddle_L_real_pos_y <= 32'd1)                              paddle_L_detect_edge[2] = 1'b0;
        else if (paddle_L_real_pos_x <= 32'd1)                              paddle_L_detect_edge[3] = 1'b0;

        else begin
            paddle_L_detect_edge[0] = 1'b1;
            paddle_L_detect_edge[1] = 1'b1;
            paddle_L_detect_edge[2] = 1'b1;
            paddle_L_detect_edge[3] = 1'b1;
        end
    end

endmodule