`timescale 1ns / 1ps

module ALU_tb;

    // Testbench signals
    reg [31:0] A, B;
    reg [3:0] ALUControl;
    wire [31:0] Result;
    wire Zero;

    // Instantiate the ALU module
    ALU alu (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    // Test procedure
    initial begin
        // Monitor output
        $monitor("Time = %0t | A = %h | B = %h | ALUControl = %b | Result = %h | Zero = %b", 
                 $time, A, B, ALUControl, Result, Zero);

        // Test case 1: Addition (A + B)
        A = 32'h00000010;  // 16
        B = 32'h00000020;  // 32
        ALUControl = 4'b0010;  // ADD operation
        #10;  // Wait for results

        // Test case 2: Subtraction (A - B)
        A = 32'h00000030;  // 48
        B = 32'h00000010;  // 16
        ALUControl = 4'b0110;  // SUB operation
        #10;

        // Test case 3: AND operation (A & B)
        A = 32'hF0F0F0F0;  // Pattern for testing bitwise AND
        B = 32'h0F0F0F0F;  // Complementary pattern
        ALUControl = 4'b0000;  // AND operation
        #10;

        // Test case 4: OR operation (A | B)
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        ALUControl = 4'b0001;  // OR operation
        #10;

        // Test case 5: Check Zero output (A - A = 0)
        A = 32'h12345678;  // Arbitrary value
        B = 32'h12345678;  // Same value for subtraction
        ALUControl = 4'b0110;  // SUB operation
        #10;

        // Test case 6: Check an undefined ALU operation (default case)
        A = 32'h00000001;  // 1
        B = 32'h00000001;  // 1
        ALUControl = 4'b1111;  // Undefined operation (testing the default case)
        #10;

        // Stop the simulation
        #50;
        $stop;
    end

endmodule
