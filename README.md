# 8-bit-harvard-cpu

### Group Project:
Michael 00000033572 <br>
Brian   000000 <br>
Angel   000000 <br>
Akmal   000000 <br>

### Architecture
<img src="https://user-images.githubusercontent.com/56579574/100183328-38deb100-2f11-11eb-92af-74cf384b7cee.jpg">

### Instructions
| No               | Instruction | Operand             | Opcode    | Keterangan               |
| ---------------- | ----------- | ------------------- | --------- | ------------------------ |
| 1                | ADD         | REG                 | 0000 0001 | GPR to Acc               |
| 2                | SUB         | REG                 | 0000 0010 | Reg value - Acc Value    |
| 3                | MOV         | Register, Register  | 0000 0011 | Reg to reg               |
|                  | MOV         | Register, Memory    | 0000 0100 | Reg to external mem      |
|                  | MOV         | Direct, Register    | 0000 0110 | To reg                   |
|                  | MOV         | Memory, Register    | 0000 0101 | External mem to Reg      |
| 4                | JMP         | Addr                | 0000 0111 | Jump to certain PC       |
| 5                | JB          | Bit, Register, Addr | 0000 1000 | Jump bit                 |
| 6                | JNB         | Bit, Register, Addr | 0000 1001 | Jump not bit             |
| 7                | JZ          | Register, Addr      | 0000 1100 | Jump zero                |
| 8                | JNZ         | Register, Addr      | 0000 1101 | Jump not zero            |
| 9                | CPL         | \-                  | 0000 1110 | Complement acc value     |
| 10               | AND         | Register            | 0000 1111 | Acc and Reg  Addition    |
| 11               | OR          | Register            | 0001 0000 | Acc and Reg OR           |
| 12               | XOR         | Register            | 0001 0001 | Acc and Reg XOR          |
| 13               | CLR         | \-                  | 0001 0010 | Clear Acc                |
| 14               | RSHIFT      | \-                  | 0001 0011 | Right shift value in Acc |
| 15               | LSHIFT      | \-                  | 0001 0100 | Left shift value in Acc  |
| 16               | NOP         | \-                  | 0000 0000 | Do nothing               |
