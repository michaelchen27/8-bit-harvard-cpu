module datamemory(clk, cmd_in, addr_in, data);
	input clk, cmd_in;
	input [7:0] addr_in;
	inout [7:0] data;
	
	reg[7:0] dm[7:0]; //Direct memory merupakan multi-dimensional array dengan dimensi 8x8.
	
	reg[7:0] tempData;
		
	always @(posedge clk)
		begin
			if (cmd_in == 1'b0) //read
				begin
					tempData[7:0] = dm[addr_in][7:0];
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
 		dm[00000000] = 0;
		dm[00000011] = 3;
		dm[00000101] = 5;
		dm[00000111] = 7;
		dm[00001010] = 10;
		dm[00001110] = 14;
		dm[00010001] = 17;
		dm[00010100] = 20;
		dm[00010110] = 22;
		dm[00011000] = 24;
		dm[00011010] = 26;
		dm[00011011] = 27;
		dm[00011101] = 29;
		dm[00011111] = 31;
		dm[00100001] = 33;
		dm[00100100] = 36;
		dm[00100101] = 37;
		dm[00101010] = 42;
		dm[00110011] = 51;
		dm[00110111] = 55;
	end
endmodule