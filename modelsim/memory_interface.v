module memory_interface(
  input clk, rst,
  //software register
  input [31:0] cmd_reg_in,
  input [31:0] din_low,
  input [31:0] din_high,
  
  //hardware register
  output [31:0] cmd_reg_out;
  output [31:0] dout_low,
  output [31:0] dout_high
  );

