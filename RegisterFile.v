module RegisterFile(
    input clk,
    input reg_write,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] registers [31:0]; // 32个32位寄存器

    always @(posedge clk) begin
        if (reg_write && write_reg != 5'b00000) begin  // x0寄存器始终为0
            registers[write_reg] <= write_data;
        end
    end

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
endmodule