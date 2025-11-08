`timescale 1ns / 1ps
`include "opcodes.vh"
`include "registers.vh"
`include "controlStates.vh"

module top_processor(
    input clk, reset,
    inout [7:0] data_bus,
    output [15:0] addr_bus,
    output rd_n, wr_n
);
    
    // Internal wires
    wire [7:0] alu_result;
    wire [7:0] reg_file_data_out;
    wire [7:0] mem_data_in;
    wire [7:0] instruction_data;
    wire [7:0] data_to_reg_file;
    wire [7:0] ir_opcode;
    wire ir_ready;
    
    // Address paths  
    wire [15:0] pc_addr;
    wire [15:0] hl_addr;
    
    // Flags
    wire [3:0] alu_flags;
    wire [3:0] flags_to_control;
    
    // Control signals
    wire pc_inc, pc_load, ir_load, reg_we;
    wire mem_rd, mem_wr, addr_sel;
    wire [2:0] reg_read_sel, reg_write_sel;
    wire [3:0] alu_sel;
    wire alu_carry_in, alu_op1_sel, alu_op2_sel;
    wire data_path_sel;
    wire [15:0] jump_addr;
    wire temp_low_load, temp_high_load;
    wire [7:0] temp_data;
    
    // Temporary registers
    reg [7:0] temp_low, temp_high;
    
    // Debug signals
    wire [3:0] control_unit_state;
    
    // ========== DATA PATH MUX ==========
    assign data_to_reg_file = (data_path_sel == 1'b0) ? alu_result : 
                             (data_path_sel == 1'b1) ? reg_file_data_out : 
                             mem_data_in;
    
    // ========== ALU OPERAND SELECTION ==========
    wire [7:0] alu_operand_b;
    assign alu_operand_b = (alu_op2_sel == 1'b0) ? reg_file_data_out : 
                          temp_data;
    
    // ========== MODULE INSTANTIATIONS ==========
    
    program_counter pc(
        .clk(clk),
        .reset(reset),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .jmp_add(jump_addr),
        .pc_out(pc_addr)
    );
    
    register_file regs(
        .clk(clk),
        .reset(reset),
        .data_in(data_to_reg_file),
        .reg_we(reg_we),
        .reg_read_sel(reg_read_sel),
        .reg_write_sel(reg_write_sel),
        .data_out(reg_file_data_out),
        .hl_out(hl_addr)
    );
    
    alu alu_unit(
        .a(reg_file_data_out),
        .b(alu_operand_b),
        .carry_in(alu_carry_in),
        .alu_sel(alu_sel),
        .result(alu_result),
        .flags(alu_flags)
    );
    
    memory_interface mem_if(
        .clk(clk),
        .rst(reset),
        .pc_addr(pc_addr),
        .hl_addr(hl_addr),
        .reg_data_out(reg_file_data_out),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .addr_sel(addr_sel),
        .mem_data_in(mem_data_in),
        .instruction_data(instruction_data),
        .addr_bus(addr_bus),
        .data_bus(data_bus),
        .rd_n(rd_n),
        .wr_n(wr_n)
    );
    
    instruction_register ir(
        .clk(clk),
        .reset(reset),
        .ir_load(ir_load),
        .data_in(instruction_data),
        .opcode(ir_opcode),
        .ir_ready(ir_ready)
    );
    
    control_unit cu(
        .clk(clk),
        .reset(reset),
        .flags(flags_to_control),
        .opcode(ir_opcode),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .jump_addr(jump_addr),
        .ir_load(ir_load),
        .reg_we(reg_we),
        .reg_read_sel(reg_read_sel),
        .reg_write_sel(reg_write_sel),
        .alu_sel(alu_sel),
        .alu_carry_in(alu_carry_in),
        .alu_op1_sel(alu_op1_sel),
        .alu_op2_sel(alu_op2_sel),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .addr_sel(addr_sel),
        .temp_low_load(temp_low_load),
        .temp_high_load(temp_high_load),
        .temp_data(temp_data),
        .data_path_sel(data_path_sel),
        .state_debug(control_unit_state)
    );
    
    // ========== FLAG REGISTER ==========
    reg [3:0] flag_reg;
    always @(posedge clk) begin
        if (reset) 
            flag_reg <= 4'b0000;
        else 
            flag_reg <= alu_flags;
    end
    assign flags_to_control = flag_reg;
    
    // ========== TEMPORARY REGISTERS ==========
    always @(posedge clk) begin
        if (reset) begin
            temp_low <= 8'b00000000;
            temp_high <= 8'b00000000;
        end else begin
            if (temp_low_load)
                temp_low <= temp_data;
            if (temp_high_load)
                temp_high <= temp_data;
        end
    end
    
endmodule