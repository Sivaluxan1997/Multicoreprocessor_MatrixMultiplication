module alu(clk,in1,in2,alu_op,alu_out,z);
	input clk;
	input [15:0] in1;
	input [15:0] in2;
	input [2:0] alu_op;
	output reg [15:0] alu_out;
	output reg [15:0] z;
	
	always @(posedge clk)
		begin
			case(alu_op)
				3'd1: alu_out <= in1+in2;
				3'd2: alu_out <= in1-in2;
				3'd3: alu_out <= in1*in2;
			endcase
			
			if(alu_out[15]==1 || alu_out==0)begin
				z <= 1;
			end
			else begin
				z <= 0;
			end
		end
endmodule