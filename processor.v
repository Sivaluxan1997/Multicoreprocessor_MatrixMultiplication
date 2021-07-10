module processor(clk,f_in,dm_out,im_out,status,dm_en,pc_out,dar_out,bus_out,end_process);
//module processor(clk,dm_out,im_out,status,dm_en,im_en,pc_out,dar_out,bus_out,end_process);
	input clk,f_in;
	input status;
	input [15:0] dm_out;
	input [15:0] im_out;
	
	output [15:0] bus_out;
	output dm_en;
	//output reg im_en;
	output [15:0] pc_out;
	output [15:0] dar_out;
	output end_process;
	
	wire [2:0] alu_op;
	wire [15:0] alu_out;
	wire [15:0] r_out;
	wire [15:0] tr_out;
	wire [15:0] ri_out;
	wire [15:0] rj_out;
	wire [15:0] rk_out;
	wire [15:0] ti_out;
	wire [15:0] tj_out;
	wire [15:0] tk_out;
	wire [15:0] ao_out;
	wire [15:0] tar_out;
	wire [15:0] e_out;
	wire [15:0] ac_out;
	wire [15:0] ir_out;
	
	wire [15:0] write_en;
	wire [4:0] read_en;
	wire [7:0] inc_en;
	wire [7:0] rst_en;
	
	wire [15:0] z;
	
	
	
	regrinc pc(.clk(clk),.write_en(write_en[0]),.data_in(bus_out),.inc_en(inc_en[0]),.data_out(pc_out));
	regrinc ao(.clk(clk),.write_en(write_en[9]),.data_in(bus_out),.inc_en(inc_en[6]),.data_out(ao_out));
	
	
	regr r(.clk(clk),.write_en(write_en[4]),.data_in(bus_out),.data_out(r_out));
	regr ir(.clk(clk),.write_en(write_en[2]),.data_in(bus_out),.data_out(ir_out));
	regr ti(.clk(clk),.write_en(write_en[6]),.data_in(bus_out),.data_out(ti_out));
	regr tj(.clk(clk),.write_en(write_en[7]),.data_in(bus_out),.data_out(tj_out));
	regr tk(.clk(clk),.write_en(write_en[8]),.data_in(bus_out),.data_out(tk_out));
	regr tar(.clk(clk),.write_en(write_en[10]),.data_in(bus_out),.data_out(tar_out));
	regr e(.clk(clk),.write_en(write_en[11]),.data_in(bus_out),.data_out(e_out));
	
	
	regrrst tr(.clk(clk),.write_en(write_en[5]),.data_in(bus_out),.rst_en(rst_en[2]),.data_out(tr_out));
	
	regrinc_rst ri(.clk(clk),.inc_en(inc_en[3]),.rst_en(rst_en[3]),.data_out(ri_out));
	regrinc_rst rj(.clk(clk),.inc_en(inc_en[4]),.rst_en(rst_en[4]),.data_out(rj_out));
	regrinc_rst rk(.clk(clk),.inc_en(inc_en[5]),.rst_en(rst_en[5]),.data_out(rk_out));
	
	regrinc_rst_we dar(.clk(clk),.write_en(write_en[1]),.data_in(bus_out),.inc_en(inc_en[1]),.rst_en(rst_en[0]),.data_out(dar_out));
	
	bus bus1(.ri(ri_out),.rj(rj_out),.rk(rk_out),.ti(ti_out),.tj(tj_out),.tk(tk_out),.ao(ao_out),.tar(tar_out),.e(e_out),.tr(tr_out),.r(r_out),.dar(dar_out),.ir(ir_out),.pc(pc_out),.ac(ac_out),.dm(dm_out),.im(im_out),.bus_out(bus_out),.read_en(read_en));
	
	ac ac1(.clk(clk),.data_in(bus_out),.write_en(write_en[3]),.inc_en(inc_en[2]),.rst_en(rst_en[1]),.alu_to_ac(write_en[13]),.alu_out(alu_out),.data_out(ac_out));
	
	alu alu1(.clk(clk),.in1(ac_out),.in2(r_out),.alu_op(alu_op),.alu_out(alu_out),.z(z));
	
	control_unit cu1(.clk(clk),.f_in(f_in),.z(z),.ins(ir_out),.status(status),.alu_op(alu_op),.write_en(write_en),.read_en(read_en),.inc_en(inc_en),.rst_en(rst_en),.end_process(end_process));
	
	
	assign dm_en=write_en[12];
	/*always @(posedge clk)
		if (status==2'b01)begin
			dm_en <=write_en[15];
			//im_en <=write_en[17];
		end*/
endmodule