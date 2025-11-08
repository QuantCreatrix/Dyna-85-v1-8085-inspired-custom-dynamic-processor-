`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 13:13:49
// Design Name: 
// Module Name: alu
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

module alu(
    input [7:0] a, b,
    input carry_in,
    input [3:0] alu_sel,
    output reg [7:0] result,
    output reg [3:0] flags  // flags[3:0] = {Zero, Carry, Sign, Parity}
);
    
    reg [8:0] temp_result; 
    
    always @(*) begin
        flags = 4'b0000;
        result = 8'b0;
        temp_result = 9'b0;
        case (alu_sel)
            // ADD 
            4'b0000: begin 
                temp_result = a + b;
                result = temp_result[7:0];
                flags[2] = temp_result[8]; 
            end
            // ADDC
            4'b0001: begin
                temp_result = a + b + carry_in;
                result = temp_result[7:0];
                flags[2] = temp_result[8]; 
            end
            
            // SUB 
            4'b0010: begin
                temp_result = a - b;
                result = temp_result[7:0];
                flags[2] = (a < b) ? 1'b1 : 1'b0; 
            end
            // SUBC
            4'b0011: begin
                temp_result = a - b - carry_in;
                result = temp_result[7:0];
                flags[2] = (a < (b + carry_in)) ? 1'b1 : 1'b0;
            end
            
            // Logical operations
            4'b0100: begin
                result = a & b;
                flags[2] = 1'b0; 
            end
            4'b0101: begin
                result = a | b;
                flags[2] = 1'b0;
            end
            4'b0110: begin
                result = a ^ b;
                flags[2] = 1'b0;
            end
            
            // CMP
            4'b0111: begin
                temp_result = a - b;
                result = 8'bxxxx_xxxx; 
                flags[2] = (a < b) ? 1'b1 : 1'b0; 
                flags[3] = ^temp_result[7:0]; 
                flags[1] = temp_result[7];    
                flags[0] = (temp_result[7:0] == 8'b0);
            end
            
            4'b1000: begin // INR
                temp_result = a + 1;
                result = temp_result[7:0];
                flags[2] = temp_result[8]; 
            end
            4'b1001: begin // DCR
                temp_result = a - 1;
                result = temp_result[7:0];
                flags[2] = (a == 8'b0) ? 1'b1 : 1'b0; 
            end
            
            4'b1010: begin // RLC
                result = {a[6:0], carry_in};
                flags[2] = a[7]; 
            end
            
            default: begin
                result = 8'b0;
                flags[2] = 1'b0;
            end
        endcase
        
        // Set common flags 
        if (alu_sel != 4'b0111) begin
            flags[3] = ^result;        
            flags[1] = result[7];      
            flags[0] = (result == 0);  
        end
    end
endmodule
