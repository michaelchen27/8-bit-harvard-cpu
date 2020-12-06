module cu(
    clk,	rst,		                          // Clock source berasal dari luar
    cmd_memory, addr_memory, data_memory,   // Data Memory
                addr_program, data_program, // Program Memory
    ins_alu, in1, in2, result               // ALU
);

localparam
	S1 = 4'b0001,
	S2 = 4'b0010,
	S3 = 4'b0011,
	S4 = 4'b0100,
	S_Last = 4'b1111;

//Reg Type INPUT
input clk;
input rst;

input[7:0] data_program, result; //data_program di diagram namanya "instruction"

//Reg Type INOUT for Bidirectional port.
inout[7:0] data_memory; //data_memory bolak balik.

//Reg Type OUTPUT
output[7:0] addr_program, addr_memory, cmd_memory, ins_alu, in1, in2; //addr_program di diagram namanya "data".

reg[7:0] cir, operand1, operand2, pc; //Internal registers, CIR = Current Instruction Register.
reg[7:0] temp_addr_memory, temp_cmd_memory, temp_data_memory; //Temporary registers for Data Memory.
reg[7:0] temp_ins_alu, temp_in1, temp_in2; //Temporary registers for ALU.
reg[7:0] gpr[2:0]; //General Purpose Register.
reg[3:0] state; //Register to keep track the state.
reg[3:0] next_state;
reg data_in; //Flag untuk mengubah "data_memory" yang bidirectional menjadi mode input atau output.

initial
    begin
			pc = 8'b00000000;
    end

//Assign temporary registers.
assign ins_alu = temp_ins_alu;
assign in1 = temp_in1;
assign in2 = temp_in2;
assign cmd_memory = temp_cmd_memory;
assign addr_memory = temp_addr_memory;
assign data_memory = (data_in) ? 8'bzzzzzzzz : temp_data_memory;  
// z represents a high-impedance state.
//It basically means that you aren't driving the output of the bus, so that something else can drive it.
assign addr_program = pc; //PC to PMI via "data".	

always @(posedge clk, posedge rst)
begin
	if(rst) begin
		state <= S1;
	end
	else begin
		state <= next_state;
	end
end

always @(posedge clk)
    begin
	 state = next_state;
        case(state)
        S1:
            begin
                cir = data_program; //Instruction masuk ke dalam Current Instruction Register.
                next_state = S2;
            end

        S2:
            begin
                if(cir == 8'b00000000 || cir == 8'b00010010) //Perintah ga perlu baca PC
                    begin//  NOP					  CLR
                       case(cir)
                        8'b00010010: //CLR Acc
                            begin
                                gpr[0][7:0] = 8'b00000000; //Clear the General Purpose Register
                                next_state = S_Last; //Last state.
                            end
                        8'b00000000: //NOP (Do Nothing).
                            begin
                                next_state = S_Last; //Last state
                            end
                       endcase
                    end

						 else if(cir == 8'b00000011 || cir == 8'b00000001|| cir == 8'b00000010|| cir == 8'b00000111) //Perintah yang butuh baca 8 bit.
                    begin //MOV Reg to Reg             ADD                  SUB         			JMP
                        pc = pc + 1'b1;
                        next_state = S3; //state 3
                    end

                else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001) // Perintah yang butuh baca 2 operand
                    begin //MOV Reg to Mem       MOV Mem to Reg      MOV Directly to Reg            JB                 JNB
                        pc = pc + 1'b1;
                        next_state = S3; //state 3
                    end
            end //end of state 2
				
        S3:
            begin
   				if(cir == 8'b00000011)
                   begin //MOV reg to reg
                       operand1 = data_program;
                       gpr[operand1[2:0]][7:0] = gpr[operand1[6:4]][7:0];
                       next_state = S_Last; //last state
                   end

                else if(cir == 8'b00000111)
                    begin //JMP
                       operand1 = data_program;
                       pc = operand1;
                       next_state = S1;

                       cir = 8'b00000000;
                       temp_in1 = 8'b00000000;
                       data_in = 1'b1;
                    end
                
				else if(cir==8'b00000001|| cir==8'b00000010)
                    begin // ADD 	         SUB
                        operand1 = data_program;
                        temp_ins_alu = cir; //CIR yang merupakan 1 atau 2 (ADD or SUB) akan digunakan sebagai juga sebagai opcode oleh ALU.
                        temp_in1 = gpr[0][7:0];
                        temp_in2 = gpr[operand1[2:0]][7:0];
                        next_state = S4; //State 4
                    end

				else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001)
                    begin //MOV Reg to Mem    MOV Mem to Reg     MOV Directly to Reg          JB                  JNB
                        operand1 = data_program;
								
                            if(cir == 8'b00001000) //JB
                            begin
                                if(gpr[operand1[2:0]][operand1[6:4]])
                                begin
                                    pc = pc+1'b1;
                                    next_state = S4;
                                end
                                else
                                begin
                                    next_state = S_Last;
                                end
                            end

								else if(cir == 8'b00001001) //JNB, kondisi ini tinggal dibalik dari JB
                            begin
                                if(gpr[operand1[2:0]][operand1[6:4]]) //kalo ada bitnya, ke state akhir. 
                                begin
                                    next_state = S_Last;
                                end
                                else //Kalo gaada bit (JNB) maka jump.
                                begin
                                    pc = pc+1'b1;
                                    next_state = S4;
                                end
                            end
								else if(operand1 == 00000101) //M0V Mem to Reg
                            begin
                                temp_addr_memory = operand1;
                                temp_cmd_memory = 8'b00000000; //read dari memory
                                data_in = 1'b1; //temp_addr_memory -> addr_memory
                                pc = pc+1'b1;
                                next_state = S4;
                            end
                        
                        else
                            begin
                                pc = pc+1'b1;
                                next_state = S4;
                            end
                    end                    
            end //end of state 3


  
        S4:
            begin
                if(cir==8'b00000001|| cir==8'b00000010)
                    begin // ADD              SUB
                        gpr[0][7:0] = result;
                        next_state = S_Last; //Last State
                    end
                

                else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001)
                    begin //MOV Reg to Mem       MOV Mem to Reg      MOV Directly to Reg            JB                 JNB
                        case(cir)
                            8'b00000100: //MOV reg to mem
                            begin
                                operand2 = data_program;
                                temp_addr_memory = operand2;
                                temp_cmd_memory = 8'b00000001;
                                temp_data_memory = gpr[operand1[2:0]];
                                data_in = 1'b0;
                                next_state = S_Last;
                            end

                            8'b00000101: //MOV Mem to Reg
                            begin
                                operand2 = data_program;
                                gpr[operand2[2:0]] = data_memory;
                                next_state = S_Last;
                            end

                            8'b00000110: //MOV directy to reg
                            begin
                                operand2 = data_program;
                                gpr[operand2[2:0]] = operand1;
                                next_state = S_Last;
                            end

                            //JB or JNB
                            8'b00001000,  8'b00001001:
                            begin
                            operand2 = data_program;
                            pc = operand2;
                            next_state = S1; 
                            end
                        endcase
                    end
            end //end of state 4

        //LAST STATE
        S_Last:
            begin
                cir = 8'b00000000;
                temp_in1 = 8'b00000000;
                data_in = 1'b1;

                next_state = S1;
                pc = pc+1'b1;
            end
        endcase
    end
endmodule
