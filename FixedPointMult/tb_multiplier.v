`timescale 1ns / 1ps

module tb_multiplier();
    parameter N = 16;
    parameter Q = 8;
    
    reg clk;
    reg reset;
    reg in_valid;
    reg signed [N-1:0] a, b;
    
    wire signed [N-1:0] out;
    wire out_valid;

    real scale = 256.0; 

    multiplier #(.Q(Q), .N(N)) uut (
        .clk(clk),
        .reset(reset),
        .in_valid(in_valid),
        .a(a),
        .b(b),
        .out(out),
        .out_valid(out_valid)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Reset
        reset = 1; in_valid = 0; a = 0; b = 0;
        
        @(posedge clk);
        reset = 0;


        @(posedge clk);
        in_valid = 1;
        a = $rtoi(2.5 * scale);
        b = $rtoi(1.5 * scale);

        @(posedge clk);
        in_valid = 0;
        a = 0; b = 0;


        repeat(3) @(posedge clk);
        $finish;
    end


    always @(posedge clk) begin
        if (out_valid) begin
            $display("Output = %0f", $itor(out)/scale);
        end
    end
endmodule
