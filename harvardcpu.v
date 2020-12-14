module harvardcpu( 
		clk, rst, 
		data_program, addr_program,
		cmd_memory, addr_memory, data_memory
);

input clk;
input rst;
input [7:0] data_program;
output[7:0] cmd_memory, addr_memory, addr_program;
inout [7:0] data_memory;

// Wires
wire [7:0] ins_alu, in1, in2, res; 						//ALU <-> CU
wire [7:0] commandmemory, datamemory, addrmemory; 	//Memory Interface <-> CU
wire [7:0] pc_wire, instruction_wire; 					//Program Memory Interface <-> CU

wire [7:0] pm_addr, pm_data; 			//Program Memory  	<-> PM Interface
wire [7:0] m_cmd, m_addr, m_data; 	//Data Memory 			<-> M	 Interface

cu controlunit(
	clk, rst,
	commandmemory, addrmemory, datamemory, 	//Data Memory
	pc_wire, instruction_wire, 					//Program Memory 
	ins_alu, in1, in2, res 							//ALU
); 		 				

alu arithmeticlogicunit(ins_alu, in1, in2, res, clk);

memoryint memoryinterface(commandmemory, m_cmd, addrmemory, m_addr, datamemory, m_data, clk);
datamemory ram(clk, m_cmd, m_addr, m_data);

progmemint programinterface(clk, pm_addr, pc_wire, pm_data, instruction_wire);
programmemory rom(pm_addr, pm_data);

endmodule