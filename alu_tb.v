module alu_tb;

	reg clk;
	reg [7:0] op, in1, in2;
	wire [7:0] result;
	
	alu testbenchalu(op,in1, in2, result, clk);
	
always
#1 clk=!clk;


initial
begin
#0 clk = 1;
   op = 8'b00000001;
	in1 = 8'b10101010;
	in2 = 8'b01001101;
end
	
endmodule