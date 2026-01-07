`timescale 1ns / 1ps

module pe (
    input wire clk,
    input wire rst_n,          
    
    
    input wire load_weight,
    
    input wire signed [7:0] weight_in,
    input wire signed [7:0] activation_in,
    input wire signed [31:0] psum_in,
    
    output reg signed [7:0] activation_out,
    output reg signed [31:0] psum_out 
);
    
    reg signed [7:0] weight_reg;
    
    wire signed [15:0] product;
    wire signed [31:0] result;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_reg <= 8'd0;
        end else if (load_weight) begin
            weight_reg <= weight_in;
        end
    end

    // Multiplier: 8-bit * 8-bit = 16-bit
    assign product = activation_in * weight_reg;
    
    // Adder: 32-bit + 16-bit = 32-bit
    assign result = psum_in + product;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            activation_out <= 8'd0;
            psum_out <= 32'd0;
        end else begin
            activation_out <= activation_in;
            psum_out <= result;
        end
    end

endmodule