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
        logic [7:0] expected_data[32];  // Array to store written data
        logic [7:0] read_data;
        
         // Write random data to all addresses*
      for (int i = 0; i < 32; i++) begin
         expected_data[i] = $random;  // Generate random data
            mif.write_mem(i, expected_data[i], debug); 
    end

        // Read back and make sure of all addresses*
        for (int i = 0; i < 32; i++) begin
         mif.read_mem(i, rdata, debug);  

         if (read_data !== expected_data[i]) begin
            $display("Error at address %0d: Expected 0x%h, Found 0x%h", 
                    i, expected_data[i], read_data);
             error_status ++;  
        end
     end
     // print result
     if (error_status == 0)
      $display("random test passed");
         else
        $display("random test FAILED with %0d errors", error_status);

        $finish;
        
    end

endmodule

 