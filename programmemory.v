module programmemory(addr_in, data_out);

	input [7:0] addr_in;
	output [7:0] data_out;

	reg [7:0] pm[7:0]; //pm memiliki merupakan multidimensional array dengan dimensi 8x8
	
	assign data_out = pm[addr_in]; //instruksi yang dikeluarkan diminta berdasarkan alamatnya.
	
	initial
		begin
			// Instruksi yang akan dilakukan untuk simulasi:
			pm[0]  = 8'b00000101; // MOV addr ke reg
			pm[1]  = 8'b00000111; // addr 7 
			pm[2]  = 8'b00000010; // R2

			pm[3]  = 8'b00000110; // MOV direct ke reg
			pm[4]  = 8'b00001100; // #12 
			pm[5]  = 8'b00000011; // R3

			pm[6]  = 8'b00000110; // MOV direct ke reg
			pm[7]  = 8'b00000001; // #1
			pm[8]  = 8'b00000100; // R4
			
			pm[9]  = 8'b00000001; // ADD 
			pm[10] = 8'b00000011; // R3

			pm[11] = 8'b00000011; // MOV reg ke reg
			pm[12] = 8'b00000001; // A ke R1

			pm[13] = 8'b00010010; // CLR

			
			pm[14] = 8'b00000010; // SUB
			pm[15] = 8'b00000100; // R4

			pm[16] = 8'b00000011; // MOV reg ke reg
			pm[17] = 8'b00000101; // A ke R5

			pm[18] = 8'b00000011; // MOV reg ke reg
			pm[19] = 8'b01000000; // R4 ke A


			pm[20] = 8'b00001001; // JNB
			pm[21] = 8'b01100100; // Bit ke-6 dari R4
			pm[22] = 8'b00010101; // Jump ke alamat LSHIFT (21)

			pm[23] = 8'b00000000; // NOP

			pm[24] = 8'b00000100; // MOV reg ke addr
			pm[25] = 8'b00000001; // R1
			pm[26] = 8'b00000011; // Addr 3
			
			pm[27] = 8'b00000111; // JMP
			pm[28] = 8'b00100001; // HERE (33)		
		end
endmodule