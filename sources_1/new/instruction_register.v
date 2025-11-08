`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 13:15:03
// Design Name: 
// Module Name: instruction_register
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

module instruction_register(
    input clk, reset, ir_load,
    input [7:0] data_in,
    output reg [7:0] opcode,
    output reg ir_ready
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            opcode <= 8'h00;
            ir_ready <= 0;
        end
        else if (ir_load) begin
            opcode <= data_in;
            ir_ready <= 1;
        end
    end
endmodule
