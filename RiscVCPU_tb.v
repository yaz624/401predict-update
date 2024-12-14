
`include "InstructionFetch.v"
`include "InstructionDecode.v"
`include "ALU.v"
`include "RegisterFile.v"
`include "ControlUnit.v"
`include "DataMemory.v"

module RiscVCPU_tb;
    // 测试信号
    reg clk;
    reg reset;

    // 中间信号
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] reg_x3, reg_x4;
    wire predict_taken;

    // 实例化 CPU
    RiscVCPU cpu (
        .clk(clk),
        .reset(reset)
    );

    // 时钟信号生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns 时钟周期
    end

    // 提取需要监控的信号
    assign pc = cpu.IF.pc;
    assign instruction = cpu.IF.memory[cpu.IF.pc >> 2];
    assign reg_x3 = cpu.RF.registers[3];
    assign reg_x4 = cpu.RF.registers[4];
    assign predict_taken = cpu.CU.predict_taken;

    // 初始化测试
    initial begin
        reset = 1;
        #10 reset = 0;

        // 初始化寄存器
        cpu.RF.registers[1] = 32'h00000001; // x1 = 1
        cpu.RF.registers[2] = 32'h00000002; // x2 = 2

        cpu.IF.memory[0] = 32'b0000000_00010_00001_000_00011_0110011; // ADD x3, x1, x2
        cpu.IF.memory[1] = 32'b0000000_00001_00010_000_00100_0110011; // ADD x4, x2, x1
        cpu.IF.memory[2] = 32'b0000000_00000_00000_000_00000_0000000; // NOP
        cpu.IF.memory[3] = 32'b0000000_00100_00011_000_00010_0100011; // SW x4, 4(x3)
        cpu.IF.memory[4] = 32'b0000000_00010_00010_000_00000_1100011; // BEQ x3, x4, offset

        // 等待执行完成
        #100;

        // 验证结果
        $display("Register x1 = %h", cpu.RF.registers[1]);
        $display("Register x2 = %h", cpu.RF.registers[2]);
        $display("Register x3 = %h", cpu.RF.registers[3]);
        $display("Register x4 = %h", cpu.RF.registers[4]);
 if (cpu.RF.registers[3] == 32'h00000004 && cpu.RF.registers[4] == 32'h00000005) begin
            $display("TEST PASSED");
        end else begin
            $display("TEST FAILED");
        end

        $finish;
    end

    // 监控输出（用于调试）
    initial begin
        $monitor("Time = %0t | PC = %h | Instruction = %h | x3 = %h | x4 = %h | Predict_Taken = %b",
                 $time, pc, instruction, reg_x3, reg_x4, predict_taken);
    end
endmodule