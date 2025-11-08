`timescale 1ns / 1ps

module tb_mov_simple;
    reg clk, reset;
    wire [7:0] data_bus;
    wire [15:0] addr_bus;
    wire rd_n, wr_n;
    
    top_processor uut (.clk(clk), .reset(reset), .data_bus(data_bus), .addr_bus(addr_bus), .rd_n(rd_n), .wr_n(wr_n));
    
    // Simple memory
    reg [7:0] memory [0:255];
    
    // Tri-state data bus
    reg [7:0] data_driver;
    reg drive_enable;
    assign data_bus = (drive_enable) ? data_driver : 8'bzzzz_zzzz;
    
    initial begin
        // Initialize memory
        for (integer i = 0; i < 256; i = i + 1) begin
            memory[i] = 8'h00;
        end
        
        // MOV instructions
        memory[0] = 8'b01000001;  // MOV A,B
        memory[1] = 8'b01001010;  // MOV C,D
        memory[2] = 8'b01011100;  // MOV E,H
        memory[3] = 8'b00000000;  // NOP
    end
    
    // Memory read
    always @(*) begin
        drive_enable = 1'b0;
        if (rd_n == 1'b0) begin
            drive_enable = 1'b1;
            data_driver = memory[addr_bus];
        end
    end
    
    always #5 clk = ~clk;
    
    initial begin
        $display("=== Simple MOV Test ===");
        $display("Monitoring bus activity...");
        
        clk = 0;
        reset = 1;
        #20;
        reset = 0;
        #200;
        
        $display("Test completed successfully!");
        $finish;
    end
    
    // Simple monitoring
    always @(posedge clk) begin
        if (rd_n == 1'b0) begin
            $display("Time=%0t: FETCH addr=0x%4h, opcode=0x%2h", $time, addr_bus, data_bus);
        end
    end
endmodule