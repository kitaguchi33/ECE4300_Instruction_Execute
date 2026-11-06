`timescale 1ns / 1ps

module alu_tb();

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] control;
    // Outputs
    wire [31:0] result;
    wire zero;
    
    alu dut (
        .read_data1(a), 
        .top_mux_out(b), 
        .control(control), 
        .result(result), 
        .zero(zero)
    );
    
    initial begin
        a = 'b1010; // 10
        b = 'b0111; // 7
        
        control <= 'b011;
        $display("A = %b\t B = %b", a, b);
        $monitor("ALUop = %b\t result = %b\t zero = %b", control, result, zero);
        
        #10 
        
        control = 'b100;
        #10 
        control = 'b010;
        #10 
        control = 'b111; // result = 0 check slt
        #10 
        control = 'b011;
        #10 
        control = 'b110;
        #10 
        control = 'b001; // result = 'b1111, check or
        #10 
        control = 'b000; // result = 'b10, check and
        #10
        
        $finish;
    end 
endmodule
