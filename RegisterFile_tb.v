`timescale 1ns / 1ps

module RegisterFile_tb;

    // Testbench signals
    reg clk;
    reg reg_write;
    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg [4:0] write_reg;
    reg [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate the Register File module
    RegisterFile RF (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test procedure
    initial begin
        // Monitor outputs
        $monitor("Time = %0t | write_reg = %d | write_data = %h | read_reg1 = %d | read_data1 = %h | read_reg2 = %d | read_data2 = %h | reg_write = %b", 
                 $time, write_reg, write_data, read_reg1, read_data1, read_reg2, read_data2, reg_write);

        // Initial state: disable write
        reg_write = 0;
        write_reg = 0;
        write_data = 0;
        read_reg1 = 0;
        read_reg2 = 0;
        #10;

        // Test case 1: Write to register x1 and read it back
        reg_write = 1;         // Enable write
        write_reg = 5'd1;      // Write to register x1
        write_data = 32'hA5A5A5A5; // Data to write
        #10;                   // Wait for one clock cycle

        // Test case 2: Read from register x1
        reg_write = 0;         // Disable write
        read_reg1 = 5'd1;      // Read from register x1
        read_reg2 = 5'd0;      // Read from register x0 (should always be zero)
        #10;

        // Test case 3: Write to register x2 and read it back
        reg_write = 1;         // Enable write
        write_reg = 5'd2;      // Write to register x2
        write_data = 32'h12345678; // Data to write
        #10;

        // Test case 4: Read from register x2
        reg_write = 0;         // Disable write
        read_reg1 = 5'd2;      // Read from register x2
        read_reg2 = 5'd1;      // Read from register x1 (should still contain 0xA5A5A5A5)
        #10;

        // Test case 5: Attempt to write to register x0 (should remain zero)
        reg_write = 1;         // Enable write
        write_reg = 5'd0;      // Attempt to write to register x0
        write_data = 32'hFFFFFFFF; // Data to write (should be ignored)
        #10;

        // Test reading from register x0
        reg_write = 0;         // Disable write
        read_reg1 = 5'd0;      // Read from register x0
        #10;

        // Stop the simulation
        #50;
        $stop;
    end

endmodule
