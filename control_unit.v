module control_unit(clk,z,f_in,ins,status,alu_op,write_en,read_en,inc_en,rst_en,end_process);
	input clk;
	input f_in;
	input [15:0] z;
	input [15:0] ins;
	input status;
	output reg [2:0] alu_op;
	output reg [15:0] write_en;
	output reg [4:0] read_en;
	output reg [7:0] inc_en;
	output reg [7:0] rst_en;
	output reg end_process;
	
	reg [5:0] present = 6'd0;
	reg [5:0] next=6'd0;
	//reg [15:0]inst = ins;
	
	parameter 
	fetch1=6'd1,
	fetch2=6'd2,
	clall1=6'd3,
	nop1=6'd4,
	ldac1=6'd5,
	ldac2=6'd6,
	mvacti1=6'd7,
	mvactj1=6'd8,
	mvactk1=6'd9,
	mvactr1=6'd10,
	mvactar1=6'd11,
	mvacr1=6'd12,
	mvacao1=6'd13,
	mvacdar1=6'd14,
	mvace1=6'd15,
	mvtiac1=6'd16,
	mvtjac1=6'd17,
	mvtkac1=6'd18,
	mvrac1=6'd19,
	add1=6'd20,
	mul1=6'd21,
	sub1=6'd22,
	incac1=6'd23,
	incri1=6'd24,
	incrj1=6'd25,
	incrk1=6'd26,
	incao1=6'd27,
	stac1=6'd28,
	jumpnz1=6'd29,
	jumpnzy1=6'd30,
	jumpnzy2=6'd31,
	jumpnzn1=6'd32,
	mvtarr1=6'd33,
	mver1=6'd34,
	mvtrr1=6'd35,
	mvrir1=6'd36,
	mvrjr1=6'd37,
	mvrkr1=6'd38,
	clac1=6'd39,
	clri1=6'd40,
	clrj1=6'd41,
	clrk1=6'd42,
	mvaodar1=6'd43,
	endop1=6'd44,
	fetch3=6'd45,
	add2=6'd46,
	sub2=6'd47,
	mul2=6'd48,
	core_en1=6'd49,
	mvaor1=6'd50,
	
	jumpz1=6'd51,
	jumpzy1=6'd52,
	jumpzy2=6'd53,
	jumpzn1=6'd54,
	
	idle1=6'd0;
	
	
	always @(posedge clk)
		
			present <= next;
		
	
			
	always @(posedge clk)
		begin
			if (present==endop1)
				end_process <=1'd1;
			else
				end_process <=1'd0;
		end
	always @(present or z or ins && status)
		case(present)
			idle1: begin
				read_en <= 5'd0;
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				if (status==2'b01)
					next<=fetch1;
				else
					next<=idle1;
				end
			
			fetch1:begin
				read_en <= 5'd1; //read pc
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch2;
				end
			fetch2:begin
				read_en <= 5'd17;//read im
				write_en <= 16'b0000000000000100;//write to ir
				inc_en <= 8'b00000001;//inc pc
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch3;
				end
			fetch3:begin
				read_en <= 5'd0;
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				if(f_in==1'd0)
					next<=6'd4;
				else
					next<=ins[5:0];
				end
			clall1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00111101;//rst - ri,rj,rk,tr,dar
				alu_op <=3'd0;
				next<=fetch1;
				end
			core_en1:begin
				read_en <= 5'd0; 
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00001000; //core_enable increment ri
				rst_en <= 8'b00000000; 
				alu_op <=3'd0;
				next<=fetch1;
				end
			ldac1:begin
				read_en <= 5'd2;    //read dar
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=ldac2;
				end
			ldac2:begin
				read_en <= 5'd16;    //dm read
				write_en <= 16'b0000000000001000;//write to ac
				inc_en <= 8'b00000010;//inc dar
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvacti1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000000001000000;//write to ti
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvactj1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000000010000000;//write to tj
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvactk1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000000100000000;//write to tk
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvactr1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000000000100000;//write to tr
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvactar1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000010000000000;//write to tar
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvacr1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvacao1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000001000000000;//write to ao
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvacdar1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000000000000010;//write to dar
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvace1:begin
				read_en <= 5'd4;    //read ac
				write_en <= 16'b0000100000000000;//write to e
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvtiac1:begin
				read_en <= 5'd10;    //read ti
				write_en <= 16'b0000000000001000;//write to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvtjac1:begin
				read_en <= 5'd11;    //read tj
				write_en <= 16'b0000000000001000;//write to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvtkac1:begin
				read_en <= 5'd12;    //read tk
				write_en <= 16'b0000000000001000;//write to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvrac1:begin
				read_en <= 5'd5;    //read r
				write_en <= 16'b0000000000001000;//write to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			add1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd1; //alu_op
				next<=add2;
				end
			add2:begin
				read_en <= 5'd0;    
				write_en <= 16'b0010000000000000;//write to alu to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd1;
				next<=fetch1;
				end
			sub1:begin
				read_en <= 5'd0;   
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd2;//alu_op
				next<=sub2;
				end
			sub2:begin
				read_en <= 5'd0;   
				write_en <= 16'b0010000000000000;//write to alu to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd2;
				next<=fetch1;
				end
			mul1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd3;//alu_op
				next<=mul2;
				end
			mul2:begin
				read_en <= 5'd0;    
				write_en <= 16'b0010000000000000;//write to alu to ac
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd3;
				next<=fetch1;
				end
			incac1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000100; //inc ac
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			incri1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00001000; //inc ri
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			incrj1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00010000; //inc rj
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			incrk1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00100000; //inc rk
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			incao1:begin
				read_en <= 5'd0;    
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b01000000; //inc ao
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			stac1:begin
				read_en <= 5'd4; //read ac   
				write_en <= 16'b0001000000000000; //write to memory
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
				
				
			jumpnz1:begin
				read_en <= 5'd1; // read pc
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				if (z==0)
					next<=jumpnzy1;
				else
					next<=jumpnzn1;
				end
			jumpnzy1:begin
				read_en <= 5'd17; // read im
				write_en <= 16'b0000000000000100;//write to ir
				inc_en <= 8'b00000000;
			   rst_en <= 8'b00000000;	
				alu_op <=3'd0;
				next<=jumpnzy2;
				end
			jumpnzy2:begin
				read_en <= 5'd3; // read ir
				write_en <= 16'b0000000000000001;//write to pc
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			jumpnzn1:begin
				read_en <= 5'd0;
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000001; //inc pc
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
				
				/*if z==1 jump--------------------------------------------------------*/
			jumpz1:begin
				read_en <= 5'd1; // read pc
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				if (z == 1)
					next<=jumpzy1;
				else
					next<=jumpzn1;
				end
			jumpzy1:begin
				read_en <= 5'd17; // read im
				write_en <= 16'b0000000000000100;//write to ir
				inc_en <= 8'b00000000;
			   rst_en <= 8'b00000000;	
				alu_op <=3'd0;
				next<=jumpzy2;
				end
			jumpzy2:begin
				read_en <= 5'd3; // read ir
				write_en <= 16'b0000000000000001;//write to pc
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			jumpzn1:begin
				read_en <= 5'd0;
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000001; //inc pc
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
				
				/*----------------------------------------------------------------------*/
				
			mvtarr1:begin
				read_en <= 5'd14; // read tar
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mver1:begin
				read_en <= 5'd15; // read e
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvtrr1:begin
				read_en <= 5'd6; // read tr
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvrir1:begin
				read_en <= 5'd7; // read ri
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvrjr1:begin
				read_en <= 5'd8; // read rj
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvrkr1:begin
				read_en <= 5'd9; // read rk
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvaor1:begin
				read_en <= 5'd13; // read a0
				write_en <= 16'b0000000000010000;//write to r
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			clac1:begin
				read_en <= 5'd0; 
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000010;//rst ac
				alu_op <=3'd0;
				next<=fetch1;
				end
			clri1:begin
				read_en <= 5'd0; 
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00001000;//rst ri
				alu_op <=3'd0;
				next<=fetch1;
				end
			clrj1:begin
				read_en <= 5'd0; 
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00010000;//rst rj
				alu_op <=3'd0;
				next<=fetch1;
				end
			clrk1:begin
				read_en <= 5'd0; 
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00100000;//rst rk
				alu_op <=3'd0;
				next<=fetch1;
				end
			mvaodar1:begin
				read_en <= 5'd13; // read ao
				write_en <= 16'b0000000000000010;//write to dar
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			nop1:begin
				read_en <= 5'd0; 
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
			endop1:begin
				read_en <= 5'd0; // read dm
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000; 
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=endop1;
				end
			default:begin
				read_en <= 5'd0;
				write_en <= 16'b0000000000000000;
				inc_en <= 8'b00000000;
				rst_en <= 8'b00000000;
				alu_op <=3'd0;
				next<=fetch1;
				end
		endcase
					
endmodule
