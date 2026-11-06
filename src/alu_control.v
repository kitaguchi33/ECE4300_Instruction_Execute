`timescale 1ns / 1ps

// Unit takes in 6-bit funct and alu_op and output the "select" for the ALU

module alu_control(
    input [5:0] funct,
    input [1:0] alu_op,
    
    output reg [2:0] select
    );
    
    // Defining ALUOp
    parameter LW_SW = 2'b00;
    parameter BEQ = 2'b01;
    parameter RTYPE = 2'b10;
    
    // Defining function field
    parameter FUNCTadd = 6'b100000;
    parameter FUNCTsub = 6'b100010;
    parameter FUNCTand = 6'b100100;
    parameter FUNCTor = 6'b100101;
    parameter FUNCTslt = 6'b101010;
    
    // Defining ALU control inputs
    parameter ALUadd = 3'b010;
    parameter ALUsub = 3'b110;
    parameter ALUand = 3'b000;
    parameter ALUor = 3'b001;
    parameter ALUslt = 3'b111;
    
    parameter UNKNOWN = 2'b11;
    parameter ALUx = 3'b011;
    
    // Default value
    initial begin
        select <= 3'd0;
    end
    
    always @ (*) begin
        case(alu_op)       // Assign outputs for each ALUop based on table                    
            LW_SW: select <= ALUadd;       
            BEQ: select <= ALUsub;
            
            RTYPE: begin
                case(funct) // This is for the R-Type instructions
                    FUNCTadd: select <= ALUadd;
                    FUNCTsub: select <= ALUsub;
                    FUNCTand: select <= ALUand;
                    FUNCTor:  select <= ALUor;
                    FUNCTslt: select <= ALUslt;
                    default: select  <= ALUx;
                endcase
            end    
            
            UNKNOWN: select <= ALUx;
            default: select <= select;
        endcase
    end
endmodule
