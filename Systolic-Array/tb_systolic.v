`timescale 1ns / 1ps

module tb_systolic;

    reg clk;
    reg rst;
    reg load_weight;
    
    reg signed [31:0] data_in_flat; 
    wire signed [127:0] psum_out_flat;
    
    
    wire signed [31:0] out_col0 = psum_out_flat[31:0];
    wire signed [31:0] out_col1 = psum_out_flat[63:32];
    wire signed [31:0] out_col2 = psum_out_flat[95:64];
    wire signed [31:0] out_col3 = psum_out_flat[127:96];


    systolic_array #(
        .ROWS(4), .COLS(4)
    ) uut (
        .clk(clk),
        .rst(rst),
        .load_weight(load_weight),
        .data_in_flat(data_in_flat),
        .psum_out_flat(psum_out_flat)
    );

    always #5 clk = ~clk;

    task drive_input(input [31:0] data);
        begin
            @(negedge clk);
            data_in_flat = data;
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        load_weight = 0;
        data_in_flat = 0;
        
        #20;
        @(negedge clk);
        rst = 0;
        

        
        $display("Loading Weights");
        load_weight = 1;
        
        drive_input({8'd13, 8'd9,  8'd5,  8'd1});
        drive_input({8'd14, 8'd10, 8'd6,  8'd2});
        drive_input({8'd15, 8'd11, 8'd7,  8'd3});
        drive_input({8'd16, 8'd12, 8'd8,  8'd4});
        
        @(negedge clk);
        load_weight = 0;
        $display("Weights Loaded.");
        
        // [1 2 3 4]
        $display("Starting Compute");
        drive_input({8'd4, 8'd3, 8'd2, 8'd1});
        
        #100;
        
        $display("Col Result: %d", out_col0, out_col1, out_col2, out_col3);             
        $finish;
    end

endmodule