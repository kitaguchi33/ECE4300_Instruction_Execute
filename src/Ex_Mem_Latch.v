`timescale 1ns / 1ps

module Ex_Mem_Latch (
    input wire        clk, rst, aluzero_in,

    input wire [1:0]  ctlwb_in,
    input wire [2:0]  ctlm_in,

    input wire [31:0] adder_in, aluout_in, readdat2_in,       
    input wire [4:0]  muxout_in,

    output reg [1:0]  ctlwb_out,
    output reg        branch, memread, memwrite, zero,

    output reg [31:0] add_result, alu_result, readdat2_out,
    output reg [4:0]  five_bit_muxout
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ctlwb_out     <= 2'b00;
            branch        <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b0;

            add_result    <= 32'b0;
            zero          <= 1'b0;
            alu_result    <= 32'b0;
            readdat2_out  <= 32'b0;
            five_bit_muxout <= 5'b0;
        end
        else begin
            ctlwb_out     <= ctlwb_in;
            
            branch        <= ctlm_in[2];
            memread       <= ctlm_in[1];
            memwrite      <= ctlm_in[0];

            add_result    <= adder_in;
            zero          <= aluzero_in;
            alu_result    <= aluout_in;
            readdat2_out  <= readdat2_in;
            five_bit_muxout <= muxout_in;
        end
    end

endmodule
