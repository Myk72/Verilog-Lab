`timescale 1ns / 1ps

module tb_relu;

    parameter DWIDTH = 16;

    reg clk;
    reg rst_n;
    reg signed [DWIDTH-1:0] data_in;
    reg valid_in;


    wire signed [DWIDTH-1:0] data_out;
    wire valid_out;


    relu #(
        .DWIDTH(DWIDTH)
    ) uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .data_in(data_in), 
        .valid_in(valid_in), 
        .data_out(data_out), 
        .valid_out(valid_out)
    );


    always #5 clk = ~clk;

    initial begin
    
        clk = 0;
        rst_n = 0;
        data_in = 0;
        valid_in = 0;


        #20 rst_n = 1;
        #10;

        $display("Starting ReLU Test");


        @(posedge clk);
        data_in <= 15;
        valid_in <= 1;
        
        
        @(posedge clk);
        data_in <= -25;
        valid_in <= 1;


        @(posedge clk);
        data_in <= 0;
        valid_in <= 1;


        @(posedge clk);
        data_in <= 100;
        valid_in <= 1;
        
        // End Stream
        @(posedge clk);
        valid_in <= 0;
        data_in <= 0;

        #50;
        $stop;
    end

    reg signed [DWIDTH-1:0] data_in_d;

    always @(posedge clk) begin
        data_in_d <= data_in;
        if (valid_out) begin
            $display("Time: %t | Input: %d | Output: %d", 
                     $time, data_in_d, data_out);
        end
    end

endmodule

// Output seen when running the testbench:
// Starting ReLU Test
// Time:                55000 | Input:     15 | Output:     15
// Time:                65000 | Input:    -25 | Output:      0
// Time:                75000 | Input:      0 | Output:      0
// Time:                85000 | Input:    100 | Output:    100