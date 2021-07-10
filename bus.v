module bus(ri,rj,rk,ti,tj,tk,ao,tar,e,tr,r,dar,ir,pc,ac,dm,im,bus_out,read_en);
	input [4:0] read_en;
	input [15:0] ri;
	input [15:0] rj;
	input [15:0] rk;
	input [15:0] ti;
	input [15:0] tj;
	input [15:0] tk;
	input [15:0] ao;
	input [15:0] tar;
	input [15:0] e;
	input [15:0] tr;
	input [15:0] r;
	input [15:0] dar;
	input [15:0] ir;
	input [15:0] pc;
	input [15:0] ac;
	input [15:0] dm;
	input [15:0] im;
	output reg [15:0] bus_out;
	
	always @(ri or rj or rk or ti or tj or tk or ao or tar or e or tr or r or dar or ir or pc or ac or dm or im or read_en)
		begin
			case(read_en)
				5'd1: bus_out <= pc;
				5'd2: bus_out <= dar;
				5'd3: bus_out <= ir;
				5'd4: bus_out <= ac;
				5'd5: bus_out <= r;
				5'd6: bus_out <= tr;
				5'd7: bus_out <= ri;
				5'd8: bus_out <= rj;
				5'd9: bus_out <= rk;
				5'd10: bus_out <= ti;
				5'd11: bus_out <= tj;
				5'd12: bus_out <= tk;
				5'd13: bus_out <= ao;
				5'd14: bus_out <= tar;
				5'd15: bus_out <= e;
				5'd16: bus_out <= dm + 16'd0;
				5'd17: bus_out <= im;
				default: bus_out <= 16'd0;
			endcase
		end
endmodule