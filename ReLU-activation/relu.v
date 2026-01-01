`timescale 1ns / 1ps

module relu #(
    parameter DWIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DWIDTH-1:0] data_in,
    input  wire valid_in,
    output reg  [DWIDTH-1:0] data_out,
    output reg  valid_out
);


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            valid_out <= 0;
        end else begin
            valid_out <= valid_in; 
            if (valid_in) begin
                if ($signed(data_in) < 0) begin
                    data_out <= 0;
                end else begin
                    data_out <= data_in;
                end
            end else begin
                data_out <= 0;
            end
        end
    end

endmodule