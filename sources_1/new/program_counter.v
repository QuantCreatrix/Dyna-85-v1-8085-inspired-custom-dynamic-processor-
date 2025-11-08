`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 13:13:11
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module program_counter(
    input clk,
    input pc_inc, pc_load, reset,
    input [15:0] jmp_add,
    output reg [15:0] pc_out
);
    
    always @(posedge clk) begin
        if (reset) pc_out <= 16'h0000;
        else if (pc_load) pc_out <= jmp_add;
        else if (pc_inc) pc_out <= pc_out + 1;
    end
    
endmodule
