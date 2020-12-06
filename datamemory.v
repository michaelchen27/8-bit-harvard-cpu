module datamemory(clk, cmd_in, addr_in, data);
	input clk, cmd_in;
	input [7:0] addr_in;
	inout [7:0] data;
	
	reg dm[7:0]; //Direct memory merupakan multi-dimensional array dengan dimensi 8x8.
	
	reg[7:0] tempData;
		
	always @(posedge clk)
		begin
			if (cmd_in == 1'b0) //read
				begin
					tempData[7:0] = dm[addr_in];
				end
				
			else if (cmd_in == 1'b1) //write
				begin	
					tempData[7:0] = 8'b00000000;
					dm[addr_in] = data;
				end
					
		end

	assign data = tempData;
		
	initial
	begin
 		dm[0] = 8'b00000000;
		dm[1] = 8'b00000001;
		dm[2] = 8'b00000010;
		dm[3] = 8'b00000011;
	end
endmodule