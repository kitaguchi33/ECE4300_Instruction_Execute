`timescale 1ns / 1ps

module execute (
    input  wire        clk, rst, reg_dst, alu_src,
    input  wire [1:0]  wb_ctl, alu_op,
    input  wire [2:0]  mem_ctl,
    input  wire [31:0] npc, read_data1, read_data2, sign_extended,
    input  wire [5:0]  instr_5_0,
    input  wire [4:0]  instr_20_16, instr_15_11,


    output wire [1:0]  wb_ctl_out,
    output wire        branch, mem_read, mem_write, zero,
    output wire [31:0] add_result, alu_result, read_data2_out,
    output wire [4:0]  write_register
);

    wire [31:0] branch_address, alu_input_b, alu_result_internal;
    wire [2:0] alu_control_signal;
    wire       zero_internal;
    wire [4:0] destination_register;

    adder branch_adder (
        .add_in1(npc),
        .add_in2(sign_extended),
        .add_out(branch_address)
    );


    top_mux alu_input_mux (
        .a(sign_extended),
        .b(read_data2),
        .sel(alu_src),
        .y(alu_input_b)
    );


    alu_control alu_control_unit (
        .funct(instr_5_0),
        .alu_op(alu_op),
        .select(alu_control_signal)
    );

    alu alu_unit (
        .a(read_data1),
        .b(alu_input_b),
        .control(alu_control_signal),
        .result(alu_result_internal),
        .zero(zero_internal)
    );

    
    bottom_mux destination_mux (
        .a(instr_15_11),
        .b(instr_20_16),
        .sel(reg_dst),
        .y(destination_register)
    );


    Ex_Mem_Latch ex_mem_latch (
        .clk(clk),
        .reset(reset),

        .wb_ctl_in(wb_ctl),
        .mem_ctl_in(mem_ctl),
        .branch_address_in(branch_address),
        .zero_in(zero_internal),
        .alu_result_in(alu_result_internal),
        .read_data2_in(read_data2),
        .write_register_in(destination_register),

        .wb_ctl_out(wb_ctl_out),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .add_result(add_result),
        .zero(zero),
        .alu_result(alu_result),
        .read_data2_out(read_data2_out),
        .write_register_out(write_register)
    );

endmodule
