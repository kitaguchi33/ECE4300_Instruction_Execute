`timescale 1ns / 1ps

module alu_control_tb();

    wire [2:0] select;
    reg [1:0] alu_op;
    reg [5:0] funct;
    
    // Defining ALUOps
    parameter LW_SW = 2'b00;
    parameter BEQ = 2'b01;
    parameter RTYPE = 2'b10;
    
    // Defining function fields
    parameter FUNCTadd = 6'b100000;
    parameter FUNCTsub = 6'b100010;
    parameter FUNCTand = 6'b100100;
    parameter FUNCTor = 6'b100101;
    parameter FUNCTslt = 6'b101010;
    
    alu_control dut(
        .alu_op(alu_op),
        .funct(funct),
        .select(select)
    );
    
    initial begin
        alu_op = 2'b00;     // lwsw
        funct = 6'b100000;  // select = 010
        $monitor("ALUOp = %b\tfunct = %b\tselect = %b", alu_op, funct, select);
        
        #10
        alu_op = BEQ;       // I-type
        funct = FUNCTsub;   // select = 110
        #10
        alu_op = RTYPE;     // R-type, and so are all subsequent opcodes
        funct = FUNCTadd;   // select = 010
        #10
        funct = FUNCTsub;   // select = 110
        #10
        funct = FUNCTand;   // select = 000
        #10
        funct = FUNCTor;    // select = 001
        #10
        funct = FUNCTslt;   // select = 111
        #10
        
        $finish;
    end
endmodule
