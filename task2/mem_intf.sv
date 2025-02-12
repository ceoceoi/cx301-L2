interface mem_intf(input clk);
logic read;
logic write;
logic [4:0] addr;
logic  [7:0] data_in;
logic data_out;  

modport mem_dut (
        input  clk,
        input  read,
        input  write,
        input  addr,
        input  data_in,
        output data_out
    );

modport test_tb (
        input  clk,
        output read,
        output write,
        output addr,
        output data_in,
        input  data_out,
        import write_mem,
        import read_mem
    );    

//
    task write_mem(input [4:0] waddr, input [7:0] wdata, input bit dbug);
        @(negedge clk);    
        read = 0;          
        write = 1;         
        addr = waddr;      
        data_in = wdata;   
        @(negedge clk);    
        write = 0;         
        if (dbug == 1)     
            $display("Write - Address:%d Data:%h", waddr, wdata);
    endtask

    //
    task read_mem(input [4:0] raddr, output [7:0] rdata, input bit dbug);
        @(negedge mif.clk);   
        write = 0;        
        read = 1;          
        addr = raddr;     
        @(negedge clk);    
        read = 0;          
        rdata = data_out; 
        if (dbug == 1)     
            $display("Read - Address:%d Data:%h", raddr, rdata);
    endtask

endinterface //mem_intf





