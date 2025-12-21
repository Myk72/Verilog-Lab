module tb_counter();
    reg clk;
    reg reset;
    wire [3:0] count;

    // Init counter module
    counter uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock flip every 5ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;      // Start with reset on
        #20 reset = 0;  // Turn off reset after 20ns
        #200 $stop;     // Stop simulation after 200ns
    end
endmodule
