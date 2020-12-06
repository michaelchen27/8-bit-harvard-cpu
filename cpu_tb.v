module cpu_tb();
    reg clk;
	 reg rst;

    wire [7:0] prog_addr, prog_data;
    wire [7:0] data_cmd, data_addr, data_line;
    
	harvardcpu cpu(
			clk, rst, data_program,
			addr_memory, addr_program, cmd_memory,
			data_memory
	);	

    always #5 clk = ~clk;

    initial
    begin
        #0 clk = 0;
		  #0 rst = 1;
		  #1 rst = 0;
    end
endmodule