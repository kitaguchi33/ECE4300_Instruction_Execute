`timescale 1ns / 1ps

module execute_tb;

    reg        clk, rst, reg_dst, alu_src;
    reg  [1:0]  wb_ctl, alu_op;
    reg  [2:0]  mem_ctl;
    reg  [31:0] npc, read_data1, read_data2, sign_extended;
    reg  [5:0]  instr_5_0;
    reg  [4:0]  instr_20_16,instr_15_11;


    wire [1:0]  wb_ctl_out;
    wire        branch, mem_read, mem_write, zero;
    wire [31:0] add_result, alu_result, read_data2_out;
    wire [4:0]  write_register;

    execute uut (
        .clk(clk),
        .rst(rst),

        .wb_ctl(wb_ctl),
        .mem_ctl(mem_ctl),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .alu_op(alu_op),

        .npc(npc),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .sign_extended(sign_extended),

        .instr_5_0(instr_5_0),
        .instr_20_16(instr_20_16),
        .instr_15_11(instr_15_11),

        .wb_ctl_out(wb_ctl_out),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),

        .add_result(add_result),
        .zero(zero),
        .alu_result(alu_result),
        .read_data2_out(read_data2_out),
        .write_register(write_register)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b0;

        wb_ctl = 2'b00;
        mem_ctl = 3'b000;
        reg_dst = 1'b0;
        alu_src = 1'b0;
        alu_op = 2'b00;

        npc = 32'd100;
        read_data1 = 32'd10;
        read_data2 = 32'd20;
        sign_extended = 32'd4;

        instr_5_0 = 6'b100000;
        instr_20_16 = 5'd5;
        instr_15_11 = 5'd10;

        #12;
        rst = 1'b1;

        wb_ctl = 2'b01;
        mem_ctl = 3'b000;
        reg_dst = 1'b1;
        alu_src = 1'b0;
        alu_op = 2'b10;
        instr_5_0 = 6'b100000;

        #10;

        instr_5_0 = 6'b100010;

        #10;

        reg_dst = 1'b0;
        alu_src = 1'b1;
        alu_op = 2'b00;
        sign_extended = 32'd4;

        #10;

        mem_ctl = 3'b100;
        alu_src = 1'b0;
        alu_op = 2'b01;
        read_data2 = 32'd10;

        #10;

        mem_ctl = 3'b000;
        alu_op = 2'b10;
        instr_5_0 = 6'b100100;
        read_data1 = 32'h0000000F;
        read_data2 = 32'h00000003;

        #10;
        instr_5_0 = 6'b100101;

        #10;
        instr_5_0 = 6'b101010;
        read_data1 = 32'd3;
        read_data2 = 32'd8;

        #10;

        $finish;
    end

endmodule
