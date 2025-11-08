// opcodes.vh - Instruction Set Architecture Definitions

// Single-byte instruction formats (top 2 bits)
`define MOV_OP      2'b01

// Multi-byte instruction identifiers (top 5 bits)  
`define LDA_OP      5'b00001
`define STA_OP      5'b00010
`define LXI_OP      5'b00011
`define JMP_OP      5'b00100

// ALU operations (for future use)
`define ALU_ADD     2'b00
`define ALU_SUB     2'b01  
`define ALU_CMP     2'b10
`define ALU_INR     2'b11