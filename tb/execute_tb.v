`timescale 1ns / 1ps

module execute_tb;

    reg        clk, rst, reg_dst, alu_src;
    reg [1:0]  wb_ctl, alu_op;
    reg [2:0]  mem_ctl;
    reg [31:0] npc, read_data1, read_data2, sign_extended;
    reg [5:0]  instr_5_0;
    reg [4:0]  instr_20_16, instr_15_11;


    wire [1:0]  wb_ctl_out;
    wire        branch, mem_read, mem_write, zero;
    wire [31:0] add_result, alu_result, read_data2_out;
    wire [4:0]  write_register;

    execute uut (
        .clk            (clk),
        .rst            (rst),
        .reg_dst        (reg_dst),
        .alu_src        (alu_src),

        .wb_ctl         (wb_ctl),
        .alu_op         (alu_op),
        .mem_ctl        (mem_ctl),

        .npc            (npc),
        .read_data1     (read_data1),
        .read_data2     (read_data2),
        .sign_extended  (sign_extended),

        .instr_5_0      (instr_5_0),
        .instr_20_16    (instr_20_16),
        .instr_15_11    (instr_15_11),

        .wb_ctl_out     (wb_ctl_out),
        .branch         (branch),
        .mem_read       (mem_read),
        .mem_write      (mem_write),
        .zero           (zero),

        .add_result     (add_result),
        .alu_result     (alu_result),
        .read_data2_out (read_data2_out),
        .write_register (write_register)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1'b0;

        reg_dst       = 1'b0;
        alu_src       = 1'b0;
        wb_ctl        = 2'b00;
        alu_op        = 2'b00;
        mem_ctl       = 3'b000;

        npc           = 32'b0;
        read_data1    = 32'b0;
        read_data2    = 32'b0;
        sign_extended = 32'b0;

        instr_5_0     = 6'b0;
        instr_20_16   = 5'b0;
        instr_15_11   = 5'b0;


        #12;
        rst = 1'b1;


        @(negedge clk);

        wb_ctl        = 2'b01;
        mem_ctl       = 3'b010;       
        alu_op        = 2'b00;       
        alu_src       = 1'b1;
        reg_dst       = 1'b0;

        npc           = 32'd100;
        read_data1    = 32'd20;
        read_data2    = 32'h12345678;
        sign_extended = 32'd12;

        instr_20_16   = 5'd9;
        instr_15_11   = 5'd17;
        instr_5_0     = 6'b000000;

        @(posedge clk);
        #1;

        @(negedge clk);

        wb_ctl        = 2'b00;
        mem_ctl       = 3'b001;       
        alu_op        = 2'b00;
        alu_src       = 1'b1;
        reg_dst       = 1'b0;

        npc           = 32'd200;
        read_data1    = 32'd40;
        read_data2    = 32'hDEADBEEF;
        sign_extended = 32'd8;

        instr_20_16   = 5'd10;
        instr_15_11   = 5'd20;

        @(posedge clk);
        #1;

        @(negedge clk);

        wb_ctl        = 2'b00;
        mem_ctl       = 3'b100;       
        alu_op        = 2'b01;        
        alu_src       = 1'b0;

        npc           = 32'd300;
        read_data1    = 32'd55;
        read_data2    = 32'd55;
        sign_extended = 32'd16;

        @(posedge clk);
        #1;

        @(negedge clk);

        wb_ctl        = 2'b10;
        mem_ctl       = 3'b000;
        alu_op        = 2'b10;        
        alu_src       = 1'b0;
        reg_dst       = 1'b1;

        npc           = 32'd400;
        read_data1    = 32'd15;
        read_data2    = 32'd7;
        sign_extended = 32'd0;

        instr_20_16   = 5'd8;
        instr_15_11   = 5'd12;
        instr_5_0     = 6'b100000;    

        @(posedge clk);
        #1;

        @(negedge clk);

        read_data1 = 32'd15;
        read_data2 = 32'd7;
        instr_5_0  = 6'b100010;       

        @(posedge clk);
        #1;

        @(negedge clk);

        read_data1 = 32'hFF00FF00;
        read_data2 = 32'h0F0F0F0F;
        instr_5_0  = 6'b100100;       

        @(posedge clk);
        #1;

        if (alu_result !== 32'h0F000F00)

        @(negedge clk);

        read_data1 = 32'hFF00FF00;
        read_data2 = 32'h0F0F0F0F;
        instr_5_0  = 6'b100101;       

        @(posedge clk);
        #1;

        @(negedge clk);
        rst = 1'b0;

        @(posedge clk);
        #1;

        $finish;
    end

endmodule
