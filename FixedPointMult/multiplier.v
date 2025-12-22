// Optimized Fixed-Point Signed Multiplier

module multiplier #(
    parameter Q = 8,
    parameter N = 16
)(
    input clk,
    input reset,
    
    input in_valid,
    
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    
    output reg signed [N-1:0] out,
    output reg out_valid
);

    // Pipeline Registers    
    reg signed [N-1:0] a_reg, b_reg;
    reg signed [(2*N)-1:0] product_reg;
    reg v1, v2;


    always @(posedge clk) begin
        if (reset) begin
            a_reg   <= 0;
            b_reg   <= 0;
            v1      <= 0;
        end else begin
            a_reg   <= a;
            b_reg   <= b;
            v1      <= in_valid;
        end
    end


    always @(posedge clk) begin
        if (reset) begin
            product_reg <= 0;
            v2          <= 0;
        end else begin
            product_reg <= a_reg * b_reg;
            v2          <= v1;
        end
    end


    always @(posedge clk) begin
        if (reset) begin
            out       <= 0;
            out_valid <= 0;
        end else begin
            out_valid <= v2;
            
            if (product_reg[(2*N)-1] == 0 && |product_reg[(2*N)-2 : N-1+Q]) begin
                out <= {1'b0, {(N-1){1'b1}}}; 
            end 
            else if (product_reg[(2*N)-1] == 1 && !(&product_reg[(2*N)-2 : N-1+Q])) begin
                out <= {1'b1, {(N-1){1'b0}}}; 
            end 
            else begin
                out <= product_reg[N-1+Q : Q];
            end
        end
    end

endmodule