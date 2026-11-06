`timescale 1ns / 1ps

/*
Takes in rdata1 as its input as well as "b," which is the output of top_mux.
It outputs result, later known as aluout, and zero, which is then aluzero for ex_mem.v.
This handles the logical and arithmetic correspondence.
*/

module alu(
    input wire [31:0] read_data1,     // source from register
    input wire [31:0] top_mux_out,    // target from register
    input wire [2:0] control,         // select from alu_control
    output reg [31:0] result,         // goes to MEM Data memory and MEM/WB latch
    output reg zero                   // goes to MEM Branch
    );
    
    parameter ALUadd = 3'b010,
    ALUsub = 3'b110,
    ALUand = 3'b000,     
    ALUor = 3'b001,
    ALUslt = 3'b111;
    
    // Handles negative inputs
    wire sign_mismatch;
    
    assign sign_mismatch = read_data1[31] ^ top_mux_out[31]; //XOR operation; only returns 1 if bits are different 
    
    initial result <= 0;
    
    always@ (*) begin
        case(control)
            ALUadd: result = read_data1 + top_mux_out;
            ALUsub: result = read_data1 - top_mux_out;
            ALUand: result = read_data1 & top_mux_out; // bit-wise AND
            ALUor: result = read_data1 | top_mux_out;  // bit-wise OR
            ALUslt: result = read_data1 < top_mux_out ? 1 - sign_mismatch // (1)
            : 0 + sign_mismatch; // (0)
            default: result = 32'bX; // control = ALUx | *
        endcase
        
        // check to see if result is equal to zero. if it is assign it true (1), false (0) otherwise, meaning it is a non-zero number
        zero = (result == 32'd0) ? 1 : 0;
    end
endmodule

// If the input information does not correspond to any valid instruction,
// aluop = 2'b11 which sets control = ALUx = 3'b011 
// and ALU output is 32 x's 
