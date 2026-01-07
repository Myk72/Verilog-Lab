`timescale 1ns / 1ps

module tb_pe;

    reg clk;
    reg rst_n;
    reg load_weight;
    reg signed [7:0] weight_in;
    reg signed [7:0] activation_in;
    reg signed [31:0] psum_in;
    
    wire signed [7:0] activation_out;
    wire signed [31:0] psum_out;

    pe uut (
        .clk(clk),
        .rst_n(rst_n),
        .load_weight(load_weight),
        .weight_in(weight_in),
        .activation_in(activation_in),
        .psum_in(psum_in),
        .activation_out(activation_out),
        .psum_out(psum_out)
    );


    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        load_weight = 0;
        weight_in = 0;
        activation_in = 0;
        psum_in = 0;

        #20;
        rst_n = 1;
        #10;

        $display("Test 1: Loading Weight 2");
        load_weight = 1;
        weight_in = 8'd2; 
        #10; 
        load_weight = 0;
        
        activation_in = 8'd3;
        psum_in = 32'd0;
        #10;
        
        $display("Test 1 Result: Input=3, Weight=2. Output=%d (Expected 6)", psum_out);


        $display("Test 2: Loading Weight -5");
        load_weight = 1;
        weight_in = -8'sd5;
        #10;
        load_weight = 0;
        
        activation_in = 8'd4;
        psum_in = 32'd100;
        #10;
        
        $display("Test 2 Result: Input=4, Weight=-5, Psum_in=100. Output=%d (Expected 80)", psum_out);

        if (activation_out == 8'd4)
            $display("Test 3 Passed: Activation passed to right neighbor correctly.");
        else
            $display("Test 3 Failed: Activation out is %d", activation_out);

        $finish;
    end

endmodule