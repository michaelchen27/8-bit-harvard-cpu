module cu(
    clk,                                    // Clock source berasal dari luar
    cmd_memory, addr_memory, data_memory,   // Data Memory
                addr_program, data_program, // Program Memory
    ins_alu, in1, in2, result               // ALU
);

//Reg Type INPUT
input clk;
input[7:0] data_program, result;

//Reg Type INOUT for Bidirectional port.
inout[7:0] data_memory; //data_memory bolak balik.

//Reg Type OUTPUT
output[7:0] addr_memory, addr_program, cmd_memory, ins_alu, in1, in2;

reg[7:0] cir, operand1, operand2, pc; //Internal register, CIR = Current Instruction Register
reg[7:0] temp_addr_memory, temp_cmd_memory, temp_data_memory; //Data Memory temporary register.
reg[7:0] temp_ins_alu, temp_in1, temp_in2; //ALU temporary register
reg[2:0] gpr[7:0];
reg[3:0] state;
reg data_in; //Flag untuk mengubah "data_memory" menjadi input atau output.

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
assign addr_program = pc;

always @(posedge clk)
    begin
        case(state)
        //STATE 1
        4'b0001:
            begin
                cir = data_program;
                state = 4'b0010; //state 2
            end
        //STATE 2
        4'b0010:
            begin
                if(cir == 8'b00000000 || cir == 8'b00010010 || cir == 8'b00001110) //Perintah ga perlu baca PC (NOP, CLR Acc, CPL Acc)
                    begin
                       case(cir)
                        8'b00010010: //CLR Acc
                            begin
                                gpr[0][7:0]=8'b00000000; //Clear the General Purpose Register
						        state=4'b1111; //Go to the last state?
                            end
                        8'b00000000: //NOP (Do Nothing).
                            begin
                                state = 4'b1111; //Last state
                            end
                        8'b00001110,8'b00010011, 8'b00010100: 
                        //CPL           RShift       LShift
                            begin
                                temp_ins_alu = cir;
                                temp_in1 = gpr[0][7:0];
                                state = 4'b0011; //state 3
                            end
                       endcase
                    end

                else if(cir == 8'b00000011 || cir == 8'b00000001|| cir == 8'b00000010|| cir == 8'b00001111|| cir == 8'b00000111 || cir == 8'b00010000|| cir == 8'b00010001) //Perintah yang butuh baca 8 bit.
                    begin //MOV Reg to Reg             ADD                  SUB                  AND                   JMP                   OR                  XOR
                        pc = pc + 1'b1;
                        state = 4'b0011; //state 3
                    end

                else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001 || cir == 8'b00001100 || cir == 8'b000001101) // Perintah yang butuh baca 2 operand
                    begin //MOV Reg to Mem       MOV Mem to Reg      MOV Directly to Reg            JB                 JNB                    JZ                   JNZ
                        pc = pc + 1'b1;
                        state = 4'b0011; //state 3
                    end
            end

        //STATE 3
        4'b0011:
            begin
				if(cir==8'b00001110 || cir == 8'b00010011|| cir == 8'b00010100)
                    begin //CPL              RSHIFT               LSHIFT
                        gpr[0][7:0] = result;
                        state = 4'b1111; //last state
                    end

   				else if(cir == 8'b00000011)
                   begin //MOV reg to reg
                       operand1 = data_program;
                       gpr[operand1[2:0]] = gpr[operand1[6:4]];
                       state = 4'b1111; //last state
                   end

                else if(cir == 8'b00000111)
                    begin //JMP
                       operand1 = data_program;
                       pc = operand1;
                       state = 4'b0001;

                       cir = 8'b00000000;
                       temp_in1 = 8'b00000000;
                       data_in = 1'b1;
                    end
                
				else if(cir==8'b00000001|| cir==8'b00000010|| cir==8'b00001111|| cir==8'b00010000|| cir==8'b00010001)
                    begin //     ADD                 SUB             AND                 OR                  XOR
                        operand1 = data_program;
                        temp_ins_alu = cir;
                        temp_in1 = gpr[0][7:0];
                        temp_in2 = gpr[operand1[2:0]][7:0];
                        state = 4'b0100;
                    end

				else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001 || cir == 8'b00001100 || cir == 8'b000001101)
                    begin //MOV Reg to Mem       MOV Mem to Reg      MOV Directly to Reg            JB                 JNB                    JZ                   JNZ
                        operand1 = data_program;
                        case(cir)
                        8'b00001000: //JB
                            begin
                                if(gpr[operand1[2:0]][operand1[6:4]])
                                begin
                                    pc = pc+1'b1;
                                    state = 4'b0100; //state 4
                                end
                                else
                                begin
                                    state = 4'b1111; //last state
                                end
                            end

                        8'b00001000: //JNB, ini tinggal dibalik dari JB
                            begin
                                if(gpr[operand1[2:0]][operand1[6:4]]) //kalo ada bitnya, ke state akhir. 
                                begin
                                    state = 4'b1111;
                                end
                                else //Kalo gaada bit (JNB) maka jump.
                                begin
                                    pc = pc+1'b1;
                                    state = 4'b0100;
                                end
                            end

                        8'b00001000: //JZ
                            begin
                                if(gpr[operand1[2:0]] == 8'b00000000) //Kalau 0, jump.
                                begin
                                    pc = pc+1'b1;
                                    state = 4'b0100;
                                end
                                else
                                begin
                                    state = 4'b1111; //Kalau engga, last state.
                                end
                            end

                        8'b00001000: //JNZ, kebalikan dari JZ
                            begin
                                if(gpr[operand1[2:0]] == 8'b00000000)
                                begin
                                    state = 4'b1111;
                                end
                                else 
                                begin
                                    pc=pc+1'b1;
                                    state = 4'b0100;
                                end      
                            end

                        8'b00001000: //M0V Addr to Reg
                            begin
                                temp_addr_memory = operand1;
                                temp_cmd_memory = 8'b00000000;
                                data_in = 1'b1;
                                pc = pc+1'b1;
                                state = 4'b0100;
                            end
                        
                        default:
                            begin
                                pc = pc+1'b1;
                                state = 4'b0100;
                            end
                        endcase
                    end                    
            end


        //STATE 4
        4'b0100:
            begin
                if(cir==8'b00000001|| cir==8'b00000010|| cir==8'b00001111|| cir==8'b00010000|| cir==8'b00010001)
                    begin // ADD                 SUB             AND                 OR                  XOR
                        gpr[0][7:0] = result;
                        state = 4'b1111; //Job is done, go to last state.
                    end
                

                else if (cir == 8'b00000100 || cir == 8'b00000101 || cir == 8'b00000110 || cir == 8'b00001000 || cir == 8'b00001001 || cir == 8'b00001100 || cir == 8'b000001101)
                    begin //MOV Reg to Mem       MOV Mem to Reg      MOV Directly to Reg            JB                 JNB                    JZ                   JNZ
                        case(cir)
                            8'b00000100: //Mov reg to mem
                            begin
                                operand2 = data_program;
                                temp_addr_memory = operand2;
                                temp_cmd_memory = 8'b00000001;
                                temp_data_memory = gpr[operand1[2:0]];
                                data_in = 1'b0;
                                state = 4'b1111;
                            end

                            8'b00000101: //Mov Mem to Reg
                            begin
                                operand2 = data_program;
                                gpr[operand2[2:0]] = data_memory;
                                state = 4'b1111;
                            end

                            8'b00000110: //Mov directy to reg
                            begin
                                operand2 = data_program;
                                gpr[operand2[2:0]] = operand1;
                                state = 4'b1111;
                            end

                            //All the jump instructions
                            8'b00001100,  8'b00001101,  8'b00001000,  8'b00001001:
                            begin
                            operand2 = data_program;
                            pc = operand2;
                            state = 4'b0001; 
                            end
                        endcase
                    end
            end

        //LAST STATE
        4'b1111:
            begin
                cir = 8'b00000000;
                temp_in1 = 8'b00000000;
                data_in = 1'b1;

                state = 4'b0001;
                pc = pc+1'b1;
            end
        endcase
    end
endmodule
