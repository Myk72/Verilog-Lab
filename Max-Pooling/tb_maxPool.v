`timescale 1ns / 1ps

module tb_maxPool;
    parameter dataWidth = 16;
    parameter testImageWidth = 4;
    
    reg clk;
    reg rstN;
    reg [dataWidth-1:0] pixelIn;
    reg validIn;
    
    wire [dataWidth-1:0] pixelOut;
    wire validOut;
    
    maxPool #(
        .dataWidth(dataWidth),
        .imageWidth(testImageWidth)
    ) uut (
        .clk(clk),
        .rstN(rstN),
        .pixelIn(pixelIn),
        .validIn(validIn),
        .pixelOut(pixelOut),
        .validOut(validOut)
    );


    always #5 clk = ~clk;


    task feedRow;
        input [dataWidth-1:0] p0, p1, p2, p3;
        begin
            @(posedge clk); pixelIn <= p0; validIn <= 1;
            @(posedge clk); pixelIn <= p1; validIn <= 1;
            @(posedge clk); pixelIn <= p2; validIn <= 1;
            @(posedge clk); pixelIn <= p3; validIn <= 1;
        end
    endtask

    initial begin
        clk = 0; rstN = 0; pixelIn = 0; validIn = 0;

        #20 rstN = 1; 
        #10;
        
        $display("Starting ...");

        // e.g: 4x4 Matrix
        // [[10, 20, 10, 10],
        //  [30, 40, 15, 12],
        //  [90, 80,  5,  6],
        //  [50, 60,  7,  8]]

        feedRow(10, 20, 10, 10);
        @(posedge clk); validIn <= 0; #10; 
        feedRow(30, 40, 15, 12);
        @(posedge clk); validIn <= 0; #10;
        feedRow(90, 80, 5, 6);
        @(posedge clk); validIn <= 0; #10;
        feedRow(50, 60, 7, 8);

        @(posedge clk); validIn <= 0;
        #50;
        
        $display("done");
        $stop;
    end
    
    
    always @(posedge clk) begin
        if (validOut) begin
            $display("Time %t | Max Pool Output: %d", $time, pixelOut);
        end
    end

endmodule