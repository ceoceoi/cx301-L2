module mem_test (mem_intf mif);
    // SYSTEMVERILOG: timeunit and timeprecision specification
    timeunit 1ns;
    timeprecision 1ns;

    // SYSTEMVERILOG: new data types - bit, logic
    bit debug = 1;      // flag to control display messages
    logic [7:0] rdata;  


    initial begin
        $timeformat(-9, 0, " ns", 9);
        // SYSTEMVERILOG: Time Literals
        #40000ns $display("MEMORY TEST TIMEOUT");
        $finish;
    end

    //updated regarding to the task
    function void printstatus(input int status);
        if (status == 0)
            $display("Test PASSED");
        else
            $display("Test FAILED with %0d errors", status);
    endfunction

    
    initial begin: memtest
        int error_status = 0;  
        mif.read = 0;
        mif.write = 0;
        mif.addr = 0;
        mif.data_in = 0;

        $display("Clear Memory Test");
        
        
        for (int i = 0; i < 32; i++) begin
            mif.write_mem(i, 0, debug); 
        end

        
        for (int i = 0; i < 32; i++) begin
            mif.read_mem(i, rdata, debug);  
            error_status += checkit(i, rdata, 8'h00);  
        end
        
        printstatus(error_status); 
        
        $display("Testing data equal to address");
        
        
        for (int i = 0; i < 32; i++) begin
            mif.write_mem(i, i, debug);  // Write address value to each address
        end

        
        for (int i = 0; i < 32; i++) begin
            mif.read_mem(i, rdata, debug);  
            error_status += checkit(i, rdata, i);  
        end
        
        printstatus(error_status);  // Report final results
        $finish;
    end

   
    function int checkit(input [4:0] addr, input [7:0] data, input [7:0] expected);
        if (data !== expected) begin
            $display("ERROR: Address %0d: Got %h, Expected %h", addr, data, expected);
            return 1;
        end
        return 0;
    endfunction

endmodule

