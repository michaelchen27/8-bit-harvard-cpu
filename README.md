# 8-bit-harvard-cpu
Digital System Design Group Project.
### Author:
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
| 7                | CLR         | \-                  | 0001 0010 | Clear Acc                |
| 8                | NOP         | \-                  | 0000 0000 | Do nothing               |
