`timescale 1ns / 1ps

module memory_interface(
    input clk, rst,
    // Address sources
    input [15:0] pc_addr,
    input [15:0] hl_addr,
    // Data from registers (for stores)
    input [7:0] reg_data_out,
    // Control signals
    input mem_rd, mem_wr,
    input addr_sel,  // 0=PC, 1=HL
    // Outputs to processor
    output reg [7:0] mem_data_in,
    output reg [7:0] instruction_data,
    // External memory bus
    output reg [15:0] addr_bus,
    inout [7:0] data_bus,
    output reg rd_n, wr_n
);

// Internal signals
reg [7:0] data_out_reg;
reg drive_bus;

// Tri-state data bus handling
assign data_bus = (drive_bus) ? data_out_reg : 8'bzzzz_zzzz;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        addr_bus <= 16'h0000;
        data_out_reg <= 8'b00;
        drive_bus <= 1'b0;
        mem_data_in <= 8'b00;
        instruction_data <= 8'b00;
        rd_n <= 1'b1;
        wr_n <= 1'b1;
    end else begin
        // Default control signals
        rd_n <= 1'b1;
        wr_n <= 1'b1;
        drive_bus <= 1'b0;
        
        // Address selection
        if (addr_sel)
            addr_bus <= hl_addr;
        else
            addr_bus <= pc_addr;
        
        // Memory operations
        if (mem_rd) begin
            // Read cycle
            rd_n <= 1'b0;
            drive_bus <= 1'b0;
            if (!addr_sel) 
                instruction_data <= data_bus;
            else
                mem_data_in <= data_bus;
        end 
        else if (mem_wr) begin
            // Write cycle
            wr_n <= 1'b0;
            data_out_reg <= reg_data_out;
            drive_bus <= 1'b1;
        end
    end
end

endmodule