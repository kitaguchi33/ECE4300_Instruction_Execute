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
        .add_in1  (npc),
        .add_in2  (sign_extended),
        .add_out  (branch_address)
    );


    top_mux alu_input_mux (
        .out  (alu_input_b),
        .in0  (read_data2),
        .in1  (sign_extended),
        .sel  (alu_src)
    );


    alu_control alu_control_unit (
        .funct  (instr_5_0),
        .alu_op (alu_op),
        .select (alu_control_signal)
    );

    alu alu_unit (
        .read_data1  (read_data1),
        .top_mux_out (alu_input_b),
        .control     (alu_control_signal),
        .result      (alu_result_internal),
        .zero        (zero_internal)
    );


    bottom_mux destination_mux (
        .a   (instr_15_11),
        .b   (instr_20_16),
        .sel (reg_dst),
        .y   (destination_register)
    );


    Ex_Mem_Latch ex_mem_latch (
        .clk            (clk),
        .rst            (rst),
        .aluzero_in     (zero_internal),

        .ctlwb_in       (wb_ctl),
        .ctlm_in        (mem_ctl),

        .adder_in       (branch_address),
        .aluout_in      (alu_result_internal),
        .readdat2_in    (read_data2),
        .muxout_in      (destination_register),

        .ctlwb_out      (wb_ctl_out),
        .branch         (branch),
        .memread        (mem_read),
        .memwrite       (mem_write),
        .zero           (zero),

        .add_result     (add_result),
        .alu_result     (alu_result),
        .readdat2_out   (read_data2_out),
        .five_bit_muxout(write_register)
    );

endmodule
