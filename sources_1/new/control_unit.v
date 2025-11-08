`timescale 1ns / 1ps
`include "opcodes.vh"
`include "registers.vh"
`include "controlStates.vh"

module control_unit(
    input clk, reset,
    input [3:0] flags,
    input [7:0] opcode,
    
    // Program Counter control
    output reg pc_inc,
    output reg pc_load,  
    output reg [15:0] jump_addr,
    
    // Instruction Register control
    output reg ir_load,
    
    // Register File control
    output reg reg_we,
    output reg [2:0] reg_read_sel,
    output reg [2:0] reg_write_sel,
    
    // ALU control
    output reg [3:0] alu_sel,
    output reg alu_carry_in,
    output reg alu_op1_sel,
    output reg alu_op2_sel,
    
    // Memory Interface control
    output reg mem_rd, mem_wr, addr_sel,
    
    // Temporary registers
    output reg temp_low_load, temp_high_load,
    output reg [7:0] temp_data,
    
    // Data path control
    output reg data_path_sel,
    
    output wire [3:0] state_debug
);
    
    reg [3:0] state, next_state;
    
    always @(*) begin
        // DEFAULT VALUES
        pc_inc = 0;
        pc_load = 0;
        jump_addr = 16'h0000;
        ir_load = 0;
        reg_we = 0;
        reg_read_sel = 3'b000;
        reg_write_sel = 3'b000;
        alu_sel = 4'b0000;
        alu_carry_in = 0;
        alu_op1_sel = 0;
        alu_op2_sel = 0;
        mem_rd = 0;
        mem_wr = 0;
        addr_sel = 0;
        temp_low_load = 0;
        temp_high_load = 0;
        temp_data = 8'h00;
        data_path_sel = 0;
        next_state = state;
        
        case (state)
            `STATE_FETCH: begin
                mem_rd = 1; 
                addr_sel = 0; 
                ir_load = 1; 
                pc_inc = 1;
                next_state = `STATE_DECODE;
            end
            
            `STATE_DECODE: begin
                case (opcode[7:6]) 
                    `MOV_OP: begin
                        reg_read_sel = opcode[2:0];
                        reg_write_sel = opcode[5:3];
                        data_path_sel = 1;
                        next_state = `STATE_MOV_EXEC;
                    end
                    default: begin
                        next_state = `STATE_FETCH;
                    end
                endcase
            end
            
            `STATE_MOV_EXEC: begin
                data_path_sel = 1;
                reg_we = 1;
                next_state = `STATE_FETCH;
            end
            
            default: begin
                next_state = `STATE_FETCH;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state <= `STATE_FETCH;
        end else begin
            state <= next_state;
        end
    end
    
    assign state_debug = state;
endmodule