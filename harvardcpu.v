module harvardcpu( clk, data_program,
			addr_memory, addr_program, cmd_memory,
			data_memory);
	
	//clk dari luar
	//memory interface punya 3 jalur, command bolakbalik(read/write), addr(dari cpu ke memory),data bolakbalik
	//program memory interface 2 jalur, addr( dari pmi ke pm untuk kirim PC ), data ( dari pm ke pmi untuk baca mau kerjain instruksi apa)

input clk;
input [7:0] data_program;

output[7:0] cmd_memory, addr_memory, addr_program;

inout [7:0] data_memory;

// Wire internal
wire [7:0] ins_alu, in1, in2, res; //alu <-> cu
wire [7:0] commandmemory, datamemory, addrmemory; //memory interface <-> cu
wire [7:0] pc_wire, instruction_wire ; //program memory interface <-> cu

cu controlunit(clk, 
				commandmemory, addrmemory, datamemory, 	//datamemory
				pc_wire, instruction_wire, 				//program memory 
				ins_alu, in1, in2, res); 				//ke alu
				 
//alu aritmetik(ins_alu, in1, in2, res, clk); //ke cu

//memoryint memint(commandmemory, cmd_memory, addrmemory, addr_memory, datamemory, data_memory, clk);

//progmemint progint(clk, addr_program, pc_wire, data_program, instruction_wire);

endmodule