module cpu_tb();
    reg clk;

    wire [7:0] prog_addr, prog_data;
    wire [7:0] data_cmd, data_addr, data_line;
    
	 datamemory ram(clk, data_cmd, data_addr, data_line);
    programmemory rom(prog_addr, prog_data);
    harvardcpu chip(clk, prog_data, data_addr, prog_addr, data_cmd, data_line);

    always #5 clk = ~clk;

    initial
    begin
        #0 clk = 0;
    end
endmodule