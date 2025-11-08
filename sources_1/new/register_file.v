`timescale 1ns / 1ps

module register_file(
    input clk, reset,
    input [7:0] data_in,
    input reg_we,
    input [2:0] reg_read_sel, reg_write_sel,
    output reg [7:0] data_out,
    output reg [15:0] hl_out
);
    
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, H = 3'b101, L = 3'b110, RESERVED = 3'b111; 
    reg [7:0] RA, RB, RC, RD, RE, RH, RL, RRESERVED;
    
    // Write logic (synchronous)
    always @(posedge clk) begin 
        if (reset) begin
            RA <= 8'h00;
            RB <= 8'h00;
            RC <= 8'h00;
            RD <= 8'h00;
            RE <= 8'h00;
            RH <= 8'h00;
            RL <= 8'h00;
            RRESERVED <= 8'h00;
        end
        else if (reg_we) begin
            case (reg_write_sel)
                A: RA <= data_in;
                B: RB <= data_in;
                C: RC <= data_in;
                D: RD <= data_in;
                E: RE <= data_in;
                H: RH <= data_in;
                L: RL <= data_in;
                RESERVED: RRESERVED <= data_in;                
            endcase
        end
    end
    
    // Read logic (combinational)
    always @(*) begin    
        case (reg_read_sel)
            A: data_out = RA;
            B: data_out = RB;
            C: data_out = RC;
            D: data_out = RD;
            E: data_out = RE;
            H: data_out = RH;
            L: data_out = RL;
            RESERVED: data_out = RRESERVED;
        endcase
        hl_out = {RH, RL};
    end
endmodule