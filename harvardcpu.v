module harvardcpu( 
		clk, data_program,
		addr_memory, addr_program, cmd_memory,
		data_memory
);
	
	//clk dari luar
	//memory interface punya 3 jalur, command bolakbalik(read/write), addr(dari cpu ke memory),data bolakbalik
	//program memory interface 2 jalur, addr( dari pmi ke pm untuk kirim PC ), data ( dari pm ke pmi untuk baca mau kerjain instruksi apa)

input clk;
input [7:0] data_program;

output[7:0] cmd_memory, addr_memory, addr_program;

inout [7:0] data_memory;

// Wire internal
wire [7:0] ins_alu, in1, in2, res; //alu <-> cu
wire [7:0] cmd_memory, data_memory, addr_memory; //memory interface <-> cu
wire [7:0] pc_wire, instruction_wire ; //program memory interface <-> cu

cu controlunit(
    clk,                                    // Clock source berasal dari luar
    cmd_memory, addr_memory, data_memory,   // Data Memory
                addr_program, data_program, // Program Memory
    ins_alu, in1, in2, result               // ALU
);

alu arithmeticlogicunit(op,in1, in2, result, clk);

memoryint memoryinterface(cmd_in, cmd_out, addr_in, addr_out, data_cu, data_dm, clk);

progmemint programmemoryinterface(clk, addr_out, pc, data_pm, ins);

endmodule