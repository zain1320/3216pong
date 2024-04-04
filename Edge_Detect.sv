module edge_detect (
    input logic [31:0] ball_size_x, 
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
        ball_detect_edge <= 4'b1111;
        collision_detect <= 8'd0;
    end

// check left edge
    always @(*) begin
        ball_real_pos_x = ball_ini_x + ball_off_x;
        ball_real_pos_y = ball_ini_y + ball_off_y;

        paddle_R_real_pos_x = paddle_R_ini_x + paddle_R_off_x;
        paddle_R_real_pos_y = paddle_R_ini_y + paddle_R_off_y;

        paddle_L_real_pos_x = paddle_L_ini_x + paddle_L_off_x;
        paddle_L_real_pos_y = paddle_L_ini_y + paddle_L_off_y;

        // Edge detection for the ball
        if (ball_real_pos_y + ball_size_y >= screen_size_y) ball_detect_edge[0] = 1'b0;
        else ball_detect_edge[0] = 1'b1;
        if (ball_real_pos_x + ball_size_x >= screen_size_x) ball_detect_edge[1] = 1'b0;
        else ball_detect_edge[1] = 1'b1;
        if (ball_real_pos_y <= 32'd10) ball_detect_edge[2] = 1'b0;
        else ball_detect_edge[2] = 1'b1;
        if (ball_real_pos_x <= 32'd10) ball_detect_edge[3] = 1'b0;
        else ball_detect_edge[3] = 1'b1;

        // Edge detection for the Right paddle
        if (paddle_R_real_pos_y + paddle_R_size_y >= screen_size_y)         paddle_R_detect_edge[0] = 1'b0;
        else paddle_R_detect_edge[0] = 1'b1;
        if (paddle_R_real_pos_y <= 32'd5)                              paddle_R_detect_edge[1] = 1'b0;
        else paddle_R_detect_edge[1] = 1'b1;

        // Edge detection for the Right paddle
        if (paddle_L_real_pos_y + paddle_L_size_y >= screen_size_y)         paddle_L_detect_edge[0] = 1'b0;
        else paddle_L_detect_edge[0] = 1'b1;
        if (paddle_L_real_pos_y <= 32'd5)                              paddle_L_detect_edge[1] = 1'b0;
        else paddle_L_detect_edge[1] = 1'b1;



        /* 
            Ball-paddle collision detection

            There is alot of logic because its detecting whether the ball collides 
            with either the top middle or the bottom edge of each paddle. This
            logic is not being used right now because im too lazy to fix other issues
            that would allow this to bounce the ball into different directions and not
            just diagonally
        */

        // Collision in the x direction for the RIGHT paddle
        if ((ball_real_pos_x + ball_size_x > paddle_R_real_pos_x - 32'd10) && (ball_real_pos_x + ball_size_x < paddle_R_real_pos_x + 32'd5)) collision_detect[0] = 1'b1;
        else collision_detect[0] = 1'b0;


        // Collision in the x direction for the LEFT paddle
        if ((ball_real_pos_x <= paddle_L_real_pos_x + paddle_L_size_x) && (ball_real_pos_x >= paddle_L_real_pos_x + paddle_L_size_x - 32'd5)) collision_detect[1] = 1'b1;
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
            
    end

endmodule