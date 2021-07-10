//`timescale 1ns/1ps

module multicore_processor(clk,core_status,dm_write_en,im_write_en,dm_addr,im_addr,dm_input_data,im_input_data,terminate,dm_output_data);

input clk;
input [3:0] core_status;
input dm_write_en;
input [15:0] dm_addr;
input [15:0] dm_input_data;

output reg terminate = 1'd0;
output wire [15:0] dm_output_data;

input im_write_en;
input [15:0] im_addr;
input [15:0] im_input_data;
//wire f_in;
wire dm_en1,dm_en2,dm_en3,dm_en4;

wire [15:0] dar_out1,dar_out2,dar_out3,dar_out4;
wire [15:0] bus_out1,bus_out2,bus_out3,bus_out4;
wire [15:0] data_out1,data_out2,data_out3,data_out4;
wire [15:0] pc_out1,pc_out2,pc_out3,pc_out4;
wire [15:0] ins_out1,ins_out2,ins_out3,ins_out4;
wire [15:0] ins_out_c1,ins_out_c2,ins_out_c3,ins_out_c4;
wire [3:0] f_out;
wire end_process1,end_process2,end_process3,end_process4;


processor processor1(.clk(clk), .f_in(f_out[0]),.dm_out(data_out1), .im_out(ins_out_c1), .status(core_status[0]), .dm_en(dm_en1), .pc_out(pc_out1), .dar_out(dar_out1), .bus_out(bus_out1), .end_process(end_process1));
processor processor2(.clk(clk), .f_in(f_out[1]),.dm_out(data_out2), .im_out(ins_out_c2), .status(core_status[1]), .dm_en(dm_en2), .pc_out(pc_out2), .dar_out(dar_out2), .bus_out(bus_out2), .end_process(end_process2));
processor processor3(.clk(clk), .f_in(f_out[2]),.dm_out(data_out3), .im_out(ins_out_c3), .status(core_status[2]), .dm_en(dm_en3), .pc_out(pc_out3), .dar_out(dar_out3), .bus_out(bus_out3), .end_process(end_process3));
processor processor4(.clk(clk), .f_in(f_out[3]),.dm_out(data_out4), .im_out(ins_out_c4), .status(core_status[3]), .dm_en(dm_en4), .pc_out(pc_out4), .dar_out(dar_out4), .bus_out(bus_out4), .end_process(end_process4));



ins_memory im1(.clk(clk), .im_write_en(im_write_en), .im_input_data(im_input_data), .im_addr(im_addr), .addr1(pc_out1), .addr2(pc_out2), .addr3(pc_out3), .addr4(pc_out4), .ins_out1(ins_out1),.ins_out2(ins_out2), .ins_out3(ins_out3),.ins_out4(ins_out4));
data_memory dm1(.clk(clk), .dm_write_en(dm_write_en), .dm_input_data(dm_input_data), .dm_addr(dm_addr), .write_en1(dm_en1), .write_en2(dm_en2), .write_en3(dm_en3), .write_en4(dm_en4), .addr1(dar_out1),.addr2(dar_out2), .addr3(dar_out3),.addr4(dar_out4), .data_in1(bus_out1),.data_in2(bus_out2), .data_in3(bus_out3),.data_in4(bus_out4), .dm_output_data(dm_output_data), .data_out1(data_out1), .data_out2(data_out2),.data_out3(data_out3), .data_out4(data_out4));

core_init core_init1(.clk(clk),.ins_in1(ins_out1),.ins_in2(ins_out2),.ins_in3(ins_out3),.ins_in4(ins_out4),.ins_out1(ins_out_c1),.ins_out2(ins_out_c2),.ins_out3(ins_out_c3),.ins_out4(ins_out_c4),.f_out(f_out));
	

always@(posedge clk) begin
	if(core_status==4'b0001)
		if (end_process1 == 1'd1)
			terminate <= 1'd1;
	
	if(core_status==4'b0011)
		if (end_process1 == 1'd1 & end_process2==1'd1)
			terminate <= 1'd1;
	
	if(core_status==4'b0111)
		if (end_process1 == 1'd1 & end_process2==1'd1 && end_process3==1'd1)
			terminate <= 1'd1;
	
	if(core_status==4'b1111)	
		if (end_process1 == 1'd1 & end_process2==1'd1 && end_process3 ==1'd1 && end_process4 == 1'd1)
			terminate <= 1'd1;
end	
endmodule
