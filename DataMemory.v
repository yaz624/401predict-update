module DataMemory(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    // 定义一个 256 字长的内存，每个字是 32 位
    reg [31:0] memory [0:255];

    // 写操作
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address >> 2] <= write_data; // 按字对齐写入
        end
    end

    // 读操作
    assign read_data = mem_read ? memory[address >> 2] : 32'h0; // 按字对齐读取
endmodule