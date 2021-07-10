module data_memory(clk,dm_write_en,dm_input_data,dm_addr,write_en1,write_en2,write_en3,write_en4,addr1,addr2,addr3,addr4,data_in1,data_in2,data_in3,data_in4,dm_output_data,data_out1,data_out2,data_out3,data_out4);
	input clk;
	input dm_write_en;
	input write_en1,write_en2,write_en3,write_en4;
	input [15:0] dm_addr;
	input [15:0] dm_input_data;
	input [15:0] addr1,addr2,addr3,addr4;
	input [15:0] data_in1,data_in2,data_in3,data_in4;
	output reg [15:0] dm_output_data;
	output reg [15:0] data_out1,data_out2,data_out3,data_out4;
	
	reg [15:0] data_ram [2047:0];
	
	always @(posedge clk)
		begin
	//input data write to memory 
			if (dm_write_en == 1) begin
				data_ram[dm_addr]<=dm_input_data;
			end
			else begin
				dm_output_data<=data_ram[dm_addr];
			end

	//processing
			if (write_en1==1)begin
				data_ram[addr1]<= data_in1[15:0];	
			end
			else begin
				data_out1 <= data_ram[addr1];
			end

			if (write_en2==1)begin
				data_ram[addr2]<= data_in2[15:0];	
			end
			else begin
				data_out2 <= data_ram[addr2];
			end
			
			if (write_en3==1)begin
				data_ram[addr3]<= data_in3[15:0];
				
			end
			else begin
				data_out3 <= data_ram[addr3];
			end

			if (write_en4==1)begin
				data_ram[addr4]<= data_in4[15:0];
				
			end
			else begin
				data_out4 <= data_ram[addr4];
			end
			
		end
endmodule