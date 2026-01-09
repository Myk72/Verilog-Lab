`timescale 1ns / 1ps

module pe (
    input wire clk,
    input wire rst,
    input wire load_weight,       // 1 = Load Weight Mode, 0 = Compute Mode
    
    
    input wire signed [7:0] val_in,
    input wire signed [31:0] psum_in,
    
    output reg signed [7:0] val_out,
    output reg signed [31:0] psum_out
);


    reg signed [7:0] weight_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            weight_reg <= 8'd0;
            val_out    <= 8'd0;
            psum_out   <= 32'd0;
        end else begin
            if (load_weight) begin
                weight_reg <= val_in;
                val_out    <= val_in; 
                psum_out   <= 32'd0; 
            end else begin
                val_out  <= val_in;
                psum_out <= psum_in + (val_in * weight_reg);
            end
        end
    end

endmodule