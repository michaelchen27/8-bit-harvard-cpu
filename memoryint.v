module memoryint(cmd_in, cmd_out, addr_in, addr_out, data_cu, data_dm, clk);

	input clk, cmd_in;
	input [7:0] addr_in;
	
	output [7:0] cmd_out, addr_out; // read data_dm input , data_cu output
	
	inout [7:0] data_cu, data_dm;   // write data_dm output, data_cu input 
	
	reg [7:0] tempData_dm, tempData_cu;

	assign data_cu = cmd_in? 8'bzzzzzzzz : tempData_cu ; //Kalau Read, data_cu jadi output untuk nerusin tempData_cu
	assign data_dm = cmd_in? tempData_dm : 8'bzzzzzzzz ; //Kalau Write, data_dm jadi output untuk nerusin tempData_dm.
	
	always @ (posedge clk) 
	begin
			if (cmd_in == 1'b0) //read
				begin 
					tempData_cu = data_dm;
				end
				
			else if (cmd_in == 1'b1) //write
				begin	
					tempData_dm = data_cu;
				end		
	end
	
	assign cmd_out = cmd_in;
	assign addr_out = addr_in;
endmodule