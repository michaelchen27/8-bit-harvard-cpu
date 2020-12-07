module programmemory(addr_in, data_out);
	
	input [7:0] addr_in;
	output [7:0] data_out;

	reg [7:0] pm[15:0]; //pm memiliki merupakan multidimensional array dengan dimensi 16x8. 16 Instruksi masing2 isi 8 bit.
	
	assign data_out = pm[addr_in]; //instruksi yang dikeluarkan diminta berdasarkan alamatnya.
	
	initial
		begin
			// Instruksi yang akan dilakukan untuk simulasi:
			pm[0] = 8'b00000111; // JMP
			pm[1] = 8'b00000011; // to instruction no.3 
			pm[2] = 8'b00000001; // ADD instruction, this instruction is skipped.
			
			pm[3] = 8'b00000011; //MOV Reg to Reg
			pm[4] = 8'b00010100; //R1 to R4
			
			pm[5] = 8'b00000110; //MOV Directly to R2
			pm[6] = 8'b00000111; //#7
			pm[7] = 8'b00000010; //R2
			
			pm[8] = 8'b00000001; //ADD
			pm[9] = 8'b00000010; //ADD Acc with R2
			
			pm[10] = 8'b00010010; //CLR Acc
			
			pm[11] = 8'b00000000; //MOV Mem to Reg
			pm[12] = 8'b00000011; //Mem address no.3
			pm[13] = 8'b00000010; //R2
		end
endmodule