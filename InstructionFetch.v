module InstructionFetch(
    input clk,
    input reset,
    input predict_taken,
    input [31:0] branch_target,
    output reg [31:0] pc,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:31]; // 指令存储器

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else if (predict_taken) begin
            pc <= branch_target; // 分支跳转
        end else if (pc < 32) begin
            pc <= pc + 4; // 顺序执行
        end
    end


    initial begin
        // 指令初始化
        memory[0] = 32'b0000000_00001_00010_000_00011_0110011; // ADD x3, x1, x2
        memory[1] = 32'b0000000_00011_00001_000_00100_0110011; // ADD x4, x3, x1

        memory[2] = 32'b0000000_00010_00001_000_00000_1100011; // BEQ x2, x1, offset
        memory[3] = 32'b0000000_00000_00000_000_00000_0000000; 
    end

    always @(*) begin
        instruction = memory[pc >> 2];
    end

endmodule