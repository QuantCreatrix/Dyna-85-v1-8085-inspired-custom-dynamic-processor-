// controlStates.vh - Control Unit State Definitions

// Main states
`define STATE_FETCH     4'b0000
`define STATE_DECODE    4'b0001

// Single-byte instruction states
`define STATE_MOV_EXEC  4'b0010

// Multi-byte instruction states  
`define STATE_READ_LOW  4'b0100
`define STATE_READ_HIGH 4'b0101
`define STATE_LDA_DATA  4'b0110
`define STATE_STA_DATA  4'b0111
`define STATE_JMP_EXEC  4'b1000

`define STATE_HALT      4'b1111