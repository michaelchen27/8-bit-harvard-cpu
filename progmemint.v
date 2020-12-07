module progmemint(clk, addr_out, pc, data_pm, ins);
	input clk;
	input [7:0] pc; // dari PC(CU) ke PMI
	input [7:0] data_pm; // dari PM ke PMI
	output [7:0] ins, addr_out; // ins = PMI ke CU, addr_out = dari PMI ke PM

	assign addr_out 	= pc;
	assign ins 			= data_pm;
endmodule