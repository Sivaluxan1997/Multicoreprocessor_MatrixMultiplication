module regrinc_rst(clk,inc_en,rst_en,data_out);
	input clk, rst_en, inc_en;
	//input [15:0] data_in;
	output reg [15:0] data_out = 16'd0;
	
	always @(negedge clk)
		begin
			if (rst_en==1)
				data_out <= 16'd0;
			if (inc_en==1)
				data_out <= data_out + 16'd1;
		end
endmodule