module regrrst(clk,write_en,data_in,rst_en,data_out);
	input clk, write_en,rst_en;
	input [15:0] data_in;
	output reg [15:0] data_out;
	always @(negedge clk)
		begin 
			if (write_en==1)
				data_out <= data_in;
			if (rst_en==1)
				data_out <= 16'd0;
		end
endmodule