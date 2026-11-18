`timescale 1ns / 1ps

module top_mux(
    output reg [31:0] out,
    input [31:0] in0, in1,
    input sel
    );

    // Whenever any of the inputs change, the sel bit chooses the output
   always @(in0, in1, sel) begin
	if (sel)
	  out = in1;
	else
	  out = in0;
    end
endmodule
