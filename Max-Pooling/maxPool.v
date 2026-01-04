`timescale 1ns / 1ps

module maxPool #(
    parameter dataWidth = 16,
    parameter imageWidth = 32
)(
    input  wire clk,
    input  wire rstN,
    
    input  wire [dataWidth-1:0] pixelIn,
    input  wire validIn,
    
    output reg  [dataWidth-1:0] pixelOut,
    output reg  validOut
);

    // I nneed to consider stride, padding
    // it's a 2x2 max pooling
    
    reg [dataWidth-1:0] lineBuffer [0:imageWidth-1];

    reg [dataWidth-1:0] t1; 
    reg [dataWidth-1:0] b1;


    reg [15:0] colCount;
    reg [15:0] rowCount;

    integer i;
    initial begin
        for(i=0; i<imageWidth; i=i+1) lineBuffer[i] = 0;
    end

    // t1  | tr ( lineBuffer[colCount] )
    // b1  | br ( pixelIn )
    
    wire signed [dataWidth-1:0] win_tr = lineBuffer[colCount];
    wire signed [dataWidth-1:0] win_br = pixelIn;
    wire signed [dataWidth-1:0] win_tl = t1;
    wire signed [dataWidth-1:0] win_bl = b1;

    wire signed [dataWidth-1:0] max_top = (win_tl > win_tr) ? win_tl : win_tr;
    wire signed [dataWidth-1:0] max_bot = (win_bl > win_br) ? win_bl : win_br;
    wire signed [dataWidth-1:0] max_val = (max_top > max_bot) ? max_top : max_bot;

    always @(posedge clk or negedge rstN) begin
        if (!rstN) begin
            colCount <= 0;
            rowCount <= 0;
            validOut <= 0;
            pixelOut <= 0;
            t1 <= 0;
            b1 <= 0;
        end else begin
            validOut <= 0;

            if (validIn) begin
                lineBuffer[colCount] <= pixelIn;
                
                if (colCount == imageWidth - 1) begin
                    colCount <= 0;
                    rowCount <= rowCount + 1;
                end else begin
                    colCount <= colCount + 1;
                end
                
                t1 <= lineBuffer[colCount];
                b1 <= pixelIn;

                if ((rowCount[0] == 1'b1) && (colCount[0] == 1'b1)) begin
                    pixelOut <= max_val;
                    validOut <= 1'b1;
                end
            end
        end
    end

endmodule