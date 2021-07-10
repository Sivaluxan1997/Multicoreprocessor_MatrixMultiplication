module regrinc(clk,write_en,data_in,inc_en,data_out);
	input clk, write_en, inc_en;
	input [15:0] data_in;
	output reg [15:0] data_out = 16'd0;
	
	always @(negedge clk)
		begin
			if (write_en==1)
				data_out <= data_in;
			if (inc_en==1)
				data_out <= data_out + 16'd1;
		end
endmodule
