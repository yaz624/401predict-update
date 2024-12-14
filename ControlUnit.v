module ControlUnit(
    input [6:0] opcode,
    input Zero,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg reg_write,
    output reg [3:0] ALUControl,
    output reg [1:0] ALUOp,
    output reg predict_taken
);
    
    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-Type (ADD, SUB, etc.)
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                reg_write = 1;
                ALUControl = 4'b0010; // R-Type运算
                predict_taken = 0;
            end
            

            7'b1100011: begin // Branch (BEQ)
                mem_read = 0;
                mem_write = 0;
                branch = 1;
                reg_write = 0;
                ALUControl = 4'b0001; // 分支需要比较操作
                predict_taken = Zero; // 基于条件判断跳转预测
            end
            default: begin
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                reg_write = 0;
                ALUControl = 4'b0000;
                predict_taken = 0;
            end
        endcase
    end
endmodule