`timescale 10ps / 1ps
module multicore_processor_tb();
	 
	 localparam CLK_PERIOD = 20;

    reg clk;
    reg [1:0] processor_status;  //state of processor memory write or processing or memory read
	 reg [3:0] core_status = 4'b0000;//state of cores on/off
	 
    reg dm_write_en; 
    reg [15:0] dm_addr= -1;
    reg [15:0] dm_input_data;
	 
	 reg im_write_en;
	 reg [15:0] im_addr = -1;
	 reg [15:0] im_input_data;
	 
	 wire terminate;  //1 if processing is finished
	 wire [15:0] dm_output_data;
	 
    reg [15:0] data;
    reg dm_status = 1'd0;  //to indicate whether data memeory write is finished or not 
	 reg [15:0] instruction;
	 reg im_status = 1'd0;  //to indicate whether ins memeory write is finished or not 
	 
	 parameter 
	 memory_write = 2'd1,  // write to memory from txt file 
    processing = 2'd2,    //  processing state
    memory_read =2'd3;    // write to txt file from memory 

    integer input_data_file;
    integer dm_scan_file;
	 integer output_data_file;
	 integer input_ins_file;
	 integer im_scan_file;
	 
	 reg [2:0] num_cores = 3'd3;  //number of cores 
	 
	 integer fill_ijk = 0;
    reg[15:0] total_i,total_j,total_k;
	 
multicore_processor multicore_processor(.clk(clk), .core_status(core_status), .dm_write_en(dm_write_en), .im_write_en(im_write_en), .dm_addr(dm_addr), .im_addr(im_addr), .dm_input_data(dm_input_data), .im_input_data(im_input_data), .terminate(terminate), .dm_output_data(dm_output_data));

always begin
		#(CLK_PERIOD/2) clk = ~clk;
end

    initial begin
        clk<=1'b0;
        processor_status <= memory_write;
		  
        input_data_file = $fopen("datain.txt", "r");  //Data memory content data file
        
		  
		  if (num_cores == 1)begin
				input_ins_file=$fopen("instructions1.txt", "r");  //assembly code for doing matrix multiplication using only one core
		  end
		  else if (num_cores == 2)begin
				input_ins_file=$fopen("instructions2.txt", "r");//assembly code for doing matrix multiplication using 2 cores
		  end
		  else if (num_cores == 3)begin
				input_ins_file=$fopen("instructions3.txt", "r");//assembly code for doing matrix multiplication using 3 cores
		  end
		  else if (num_cores == 4)begin
				input_ins_file=$fopen("instructions4.txt", "r");//assembly code for doing matrix multiplication using 4 cores
		  end
        
    end

    
   always @(posedge clk) begin
		 //write data memory
       if (processor_status == memory_write)begin
			  
           dm_write_en <= 1'b1;
           dm_scan_file = $fscanf(input_data_file, "%d\n", data);
           if (!$feof(input_data_file) && dm_status==1'd0) begin
               dm_input_data <= data;
               dm_addr <= dm_addr + 16'd1;
					if(fill_ijk == 16'd0)begin
                   total_i <= data;
                   fill_ijk <= fill_ijk + 16'd1;
               end
               else if (fill_ijk == 16'd1)begin
                   total_j <= data;
                   fill_ijk <= fill_ijk + 16'd1;
               end
               else if (fill_ijk == 16'd2)begin
                   total_k <= data;
                   fill_ijk <= fill_ijk + 16'd1;
               end
           end
           else if(dm_status==1'd0) begin
                dm_input_data <= data;
                dm_addr <= dm_addr + 16'd1;
                dm_status <= 1'd1;
           end
			  
			  //write instruction memory 
			  im_write_en<=1'b1;
           im_scan_file = $fscanf(input_ins_file, "%d\n", instruction);
           if (!$feof(input_ins_file) && im_status==1'd0) begin
               im_input_data <= instruction;
               im_addr <= im_addr + 16'd1;
           end
           else if (im_status==1'd0)begin
                im_input_data <= instruction;
                im_addr <= im_addr + 16'd1;
                im_status <= 1'd1;
           end
			  
           if ((im_status & dm_status)==1'd1)begin
                processor_status <= processing;
                dm_write_en <= 1'b0;
                im_write_en <= 1'b0;
					 dm_addr <= dm_addr + 16'd1;
           end
       end
		 //processing state
		 
		 if (processor_status == processing)begin
			//enable cores
			if (num_cores == 1)begin
				core_status <= 4'b0001;	
			end
			else if (num_cores == 2)begin
				core_status <= 4'b0011;	
			end
			else if (num_cores == 3)begin
				core_status <= 4'b0111;	
			end
			else if (num_cores == 4)begin
				core_status <= 4'b1111;	
			end
			//check processing finished or not  
			if (terminate == 1'd1)begin
					processor_status <= memory_read;
					output_data_file = $fopen("dataout.txt", "w");
					dm_addr <= dm_addr + 16'd1;
			end
       end

		 //read data memory to write output to txt file 
		 if (processor_status == memory_read)begin
				if (dm_addr <= (total_i*total_j + total_j*total_k + total_i*total_k + 3)) begin
					$fdisplay(output_data_file,dm_output_data);
					dm_addr <= dm_addr + 1'd1;
				end
				else begin
					$stop;
				end
		 end
   end
	
endmodule
