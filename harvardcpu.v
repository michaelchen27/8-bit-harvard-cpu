module harvardcpu( 
		clk, rst, data_program,
		addr_memory, addr_program, cmd_memory,
		data_memory
);

input clk;
input rst;
input [7:0] data_program;

output[7:0] cmd_memory, addr_memory, addr_program;

inout [7:0] data_memory;

// Wire internal
wire [7:0] ins_alu, in1, in2, res; //ALU <-> CU
wire [7:0] commandmemory, datamemory, addrmemory; //Memory Interface <-> CU
wire [7:0] pc_wire, instruction_wire; //Program Memory Interface <-> CU

cu controlunit(clk, 
				commandmemory, addrmemory, datamemory, 	//Data Memory
				pc_wire, instruction_wire, 					//Program Memory 
				ins_alu, in1, in2, res); 		 				//ALU

alu arithmeticlogicunit(ins_alu, in1, in2, res, clk); //ke cu

memoryint memoryinterface(commandmemory, cmd_memory, addrmemory, addr_memory, datamemory, data_memory, clk);
datamemory datamem(clk, cmd_memory, addr_memory, data_memory);

progmemint programinterface(clk, addr_program, pc_wire, data_program, instruction_wire);
programmemory progmem(addr_program, data_program);

endmodule