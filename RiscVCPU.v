module RiscVCPU(
    input clk,
    input reset
);


/*R-type：用于算术运算、逻辑运算等。
	•	I-type：用于立即数运算、数据传送等。
	•	S-type：用于存储操作（如 SW 指令）。
	•	B-type：用于分支跳转操作。
	•	U-type：用于大立即数加载操作。
	•	J-type：用于跳转指令。
*/
    // 内部信号定义
    wire [31:0] pc, instruction, branch_target, read_data1, read_data2, alu_result, mem_data;
    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode;
    wire [3:0] ALUControl; // 新增 ALUControl 信号
    wire [1:0] ALUOp;
    wire mem_read, mem_write, reg_write, branch, Zero, predict_taken;

    // 模块实例化
    InstructionFetch IF (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
          .predict_taken(predict_taken),
      .branch_target(branch_target)
    );

    InstructionDecode ID (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode)
    );

    RegisterFile RF (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(alu_result),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    ControlUnit CU (
        .opcode(opcode),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .Zero(Zero),
        .branch(branch),
        .predict_taken(predict_taken),
        .reg_write(reg_write),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl) // 新增连接
    );

    ALU ALU (
        .A(read_data1),
        .B(read_data2),
        .ALUControl(ALUControl), // 使用 ControlUnit 生成的 ALUControl
        .Result(alu_result),
        .Zero(Zero)
    );
          DataMemory DM (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(mem_data)
    );
/*
	 always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_pc <= 0;
            IF_ID_instruction <= 0;
        end else begin
            IF_ID_pc <= pc;
            IF_ID_instruction <= instruction;
        end
    end

    // ID 阶段
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_EX_regA <= 0;
            ID_EX_regB <= 0;
            ID_EX_imm <= 0;
            ID_EX_ALUControl <= 0;
            ID_EX_mem_read <= 0;
            ID_EX_mem_write <= 0;
            ID_EX_reg_write <= 0;
            ID_EX_branch <= 0;
            ID_EX_pc <= 0;
        end else begin
            ID_EX_regA <= read_data1;
            ID_EX_regB <= read_data2;
            ID_EX_imm <= {{20{IF_ID_instruction[31]}}, IF_ID_instruction[31:20]};
            ID_EX_ALUControl <= ALUControl;
            ID_EX_mem_read <= mem_read;
            ID_EX_mem_write <= mem_write;
            ID_EX_reg_write <= reg_write;
            ID_EX_branch <= branch;
            ID_EX_pc <= IF_ID_pc;
        end
    end

    // EX 阶段
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_MEM_ALU_result <= 0;
            EX_MEM_mem_address <= 0;
            EX_MEM_mem_read <= 0;
            EX_MEM_mem_write <= 0;
            EX_MEM_reg_write <= 0;
        end else begin
            EX_MEM_ALU_result <= ALU_result;
            EX_MEM_mem_address <= ID_EX_regB;
            EX_MEM_mem_read <= ID_EX_mem_read;
            EX_MEM_mem_write <= ID_EX_mem_write;
            EX_MEM_reg_write <= ID_EX_reg_write;
        end
    end

    // MEM 阶段
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_WB_data <= 0;
            MEM_WB_ALU_result <= 0;
            MEM_WB_reg_write <= 0;
        end else begin
            MEM_WB_data <= DM.read_data;
            MEM_WB_ALU_result <= EX_MEM_ALU_result;
            MEM_WB_reg_write <= EX_MEM_reg_write;
        end
    end

endmodule*/
    assign branch_target = pc + 4;
endmodule
