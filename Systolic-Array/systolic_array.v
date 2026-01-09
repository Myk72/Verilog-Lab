`timescale 1ns / 1ps


module systolic_array #(
    parameter ROWS = 4,
    parameter COLS = 4
    
    //   PE(0,0) → PE(0,1) → PE(0,2) → PE(0,3)
    //     ↓         ↓         ↓         ↓
    //   PE(1,0) → PE(1,1) → PE(1,2) → PE(1,3)
    //     ↓         ↓         ↓         ↓
    //   PE(2,0) → PE(2,1) → PE(2,2) → PE(2,3)
    //     ↓         ↓         ↓         ↓
    //   PE(3,0) → PE(3,1) → PE(3,2) → PE(3,3)
    
)(
    input wire clk,
    input wire rst,
    input wire load_weight,
    
    
    input wire signed [8*ROWS-1:0] data_in_flat,
    output wire signed [32*COLS-1:0] psum_out_flat
);


    wire signed [7:0] row_inputs [0:ROWS-1]; // [0 for _ in range(ROWS)]
    genvar i;
    generate
        for (i = 0; i < ROWS; i = i + 1) begin
            assign row_inputs[i] = data_in_flat[8*(i+1)-1 : 8*i];
        end
    endgenerate


    wire signed [7:0]  horizontal_wires [0:ROWS-1][0:COLS]; // [[0] * (COLS + 1) for _ in range(ROWS)]
    wire signed [31:0] vertical_wires   [0:ROWS][0:COLS-1];

    genvar r, c;
    generate
        for (r = 0; r < ROWS; r = r + 1) begin : ROW_GEN
            for (c = 0; c < COLS; c = c + 1) begin : COL_GEN
                
                wire signed [7:0]  pe_val_in;
                wire signed [31:0] pe_psum_in;
                
                if (c == 0) 
                    assign pe_val_in = row_inputs[r];
                else        
                    assign pe_val_in = horizontal_wires[r][c];
                
                if (r == 0)
                    assign pe_psum_in = 32'd0;
                else
                    assign pe_psum_in = vertical_wires[r][c];

                pe pe_inst (
                    .clk(clk),
                    .rst(rst),
                    .load_weight(load_weight),
                    .val_in(pe_val_in),
                    .psum_in(pe_psum_in),
                    .val_out(horizontal_wires[r][c+1]),
                    .psum_out(vertical_wires[r+1][c])
                );
            end
        end
    endgenerate

    generate
        for (c = 0; c < COLS; c = c + 1) begin
            assign psum_out_flat[32*(c+1)-1 : 32*c] = vertical_wires[ROWS][c];
        end
    endgenerate

endmodule