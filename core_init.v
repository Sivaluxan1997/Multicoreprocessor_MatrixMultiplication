module core_init(clk,ins_in1,ins_in2,ins_in3,ins_in4,ins_out1,ins_out2,ins_out3,ins_out4,f_out);

input [15:0] ins_in1,ins_in2,ins_in3,ins_in4;
input clk;
output reg [15:0] ins_out1,ins_out2,ins_out3,ins_out4;
output reg [3:0] f_out=4'b1111;

reg [4:0]count = 5'd0;
 
always @(posedge clk)
		begin
		ins_out1 <= ins_in1;
		ins_out2<=ins_in2;
		ins_out3 <= ins_in3;
		ins_out4<=ins_in4;
		f_out <= 4'b1111;
		//count <= 5'd0;
		if (ins_in1==16'd49) begin
			if(count==3)
				f_out <= 4'b1110;
			if(count==7)
				f_out <= 4'b1100;
			if(count==11)
				f_out <= 4'b1000;
			count <= count +5'd1;
		end
			
		end

endmodule