module cpu_tb();
    reg clk;

    wire [7:0] prog_addr, prog_data;
    wire [7:0] data_cmd, data_addr, data_line;
    
//	 datamemory ram(clk, data_cmd, data_addr, data_line);

//    programmemory rom(
//			.prog_addr	(addr_in	), 
//			.prog_data	(data_out)
//	 );//module not found in modelsim altera error msg, why?

//	harvardcpu cpu(
//			clk, data_program,
//			addr_memory, addr_program, cmd_memory,
//			data_memory
//	);

    always #5 clk = ~clk;

    initial
    begin
        #0 clk = 0;
    end
endmodule