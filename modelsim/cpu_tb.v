`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg rst;
reg [31:0] cmd_in;
reg [31:0] din_low;
reg [31:0] din_high;

wire [31:0] cmd_out;
wire [31:0] dout_low;
wire [31:0] dout_high;

cpu uut(
    .clk(clk),
    .rst(rst),
    .cmd_in(cmd_in),
	.din_low(din_low),
	.din_high(din_high),
	.cmd_out(cmd_out),
	.dout_low(dout_low),
	.dout_high(dout_high)
);

always begin
    #5 clk = ~clk;
end

task regwrite;
  input [31:0] cmd_reg;
  begin
    @(posedge clk);
	cmd_in <= cmd_reg;
  end
endtask
	

initial begin
    clk = 1'b0;
    rst = 1'b0;
	cmd_in = 32'b0;
	din_low = 32'b0;
	din_high = 32'b0;
    #10;
	//reset the pipeline
	regwrite(32'h10000000);
    #10;
	//read data memory before starting the pipeline
	regwrite(32'h60000049);//data[73] = 8
    #10;
 	regwrite(32'h6000004A);//data[74] = 10
	#10;
	regwrite(32'h6000004B);//data[75] = -2
	#10;
	regwrite(32'h6000004C);//data[76] = 6
	#10;
	regwrite(32'h6000004D);//data[77] = 4
	#10;
	//start the pipeline
	regwrite(32'h80000000);
	#6500;
	//disable the pipeline
	regwrite(32'h00000000);
	#10;
	//read data memory after processing
	regwrite(32'h60000014);//data[20] = -2
    #10;
	regwrite(32'h60000015);//data[21] = 4
	#10;
	regwrite(32'h60000016);//data[22] = 6
	#10;
	regwrite(32'h60000017);//data[23] = 8
	#10;
	regwrite(32'h60000018);//data[24] = 10
    #10;
	
	//reset the pipeline
	regwrite(32'h10000000);
	#10;
	//write data memory
	regwrite(32'h40000049);
	din_low = 32'h00000005;
	
	regwrite(32'h4000004a);
	din_low = 32'h00000004;
	
	regwrite(32'h4000004b);
	din_low = 32'h00000003;
	
	regwrite(32'h4000004c);
	din_low = 32'h00000002;
	
	regwrite(32'h4000004d);
	din_low = 32'h00000001;
	//read modified data
	regwrite(32'h60000049);
	regwrite(32'h6000004a);
	regwrite(32'h6000004b);
	regwrite(32'h6000004c);
	regwrite(32'h6000004d);
	
	//restart the pipeline
	regwrite(32'h80000000);
	#8000;
	//disable the pipeline
	regwrite(32'h00000000);
	#10;
	//read data memory after processing
	regwrite(32'h60000014);//data[20] = 1
    #10;
	regwrite(32'h60000015);//data[21] = 2
	#10;
	regwrite(32'h60000016);//data[22] = 3
	#10;
	regwrite(32'h60000017);//data[23] = 4
	#10;
	regwrite(32'h60000018);//data[24] = 5
    #10;
end

endmodule
