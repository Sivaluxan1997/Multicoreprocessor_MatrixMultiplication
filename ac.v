module ac(clk,data_in,write_en,inc_en,rst_en,alu_to_ac,alu_out,data_out);
	input clk, write_en, inc_en, rst_en,alu_to_ac;
	input [15:0] alu_out;
	input [15:0] data_in;
	output reg [15:0] data_out = 16'd0;
	
	always @(posedge clk)
		begin
			if (inc_en==1)
				data_out <= data_out+ 16'd1;
			if (write_en==1)
				data_out <= data_in;
			if (rst_en==1)
				data_out <= 16'd0;
			if (alu_to_ac==1)
				data_out <= alu_out;
		end
endmodule