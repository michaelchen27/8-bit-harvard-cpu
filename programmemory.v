module programmemory(addr_in, data_out);

	input [7:0] addr_in;
	output [7:0] data_out;

	reg [7:0] pm[7:0]; //pm memiliki merupakan multidimensional array dengan dimensi 8x8
	
	assign data_out = pm[addr_in]; //instruksi yang dikeluarkan diminta berdasarkan alamatnya.
	
	initial
		begin
			// Instruksi yang akan dilakukan untuk simulasi:
			pm[0]  = 8'b00000001; // ADD
			pm[1]  = 8'b00000111; // #7 
			pm[2]  = 8'b00000010; // R2
		end
endmodule