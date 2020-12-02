module alu(op,in1, in2, result, clk);
	input clk; //clock dari luar
	input [7:0] op, in1, in2; //op (operasi yang akan dilakukan), input1, input2.
	output [7:0] result; //hasil yang akan diberikan ke Control Unit.
	
	reg[7:0] hasil;
	
	always @ (posedge clk) 
	begin
		if (op == 8'b00000001)//ADD
		begin
			hasil <= in1 + in2;
		end
	
		else if (op == 8'b00000010)//SUB
		begin 
			hasil <= in1 - in2;
		end
	end
	
	assign result = hasil;
endmodule