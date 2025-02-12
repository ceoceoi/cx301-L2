module top;
    // Clock generation
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Interface instantiation with clock connection
    mem_intf mif(clk);

    // Memory and testbench instantiation
    mem      mem_inst  (.mif(mif));
    mem_test test_inst (.mif(mif));

endmodule
