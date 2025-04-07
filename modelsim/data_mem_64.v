module data_mem_64(
    input clk, rst, 
/*     input [1: 0] write_mem, 
    input [2: 0] read_mem, */ 
    input write_mem,
    input read_mem,	

    input [63: 0] address, write_data,

    output reg [63: 0] out_mem
);


reg [63: 0] data [255: 0];
wire [7:0] memindex;

assign memindex = address>>2;

always @(*) begin
    case (read_mem)
      1'b0: begin
        out_mem = 64'b0;
      end
      //lw
      1'b1: begin
        out_mem = data[memindex];
      end
/*       //lh
      2'b10: begin
        if(read_mem[2]) out_mem = {32'b0, data[memindex][31:0]};
        else out_mem = {{32{data[memindex][31]}}, data[memindex][31:0]};
      end
      //lb
      2'b11: begin
        if(read_mem[2]) out_mem = {56'b0, data[memindex][7:0]};
        else out_mem = {{56{data[memindex][7]}}, data[memindex][7:0]};
      end */
      default: begin
        out_mem = 64'b0;
      end
    endcase
end

always @(posedge clk) begin
  if(rst) begin
    data[73] <= 64'h0000_0000_0000_0008; //8
    data[74] <= 64'h0000_0000_0000_000A; //10
    data[75] <= 64'hFFFF_FFFF_FFFF_FFFE; //-2
    data[76] <= 64'h0000_0000_0000_0006; //6
    data[77] <= 64'h0000_0000_0000_0004; //4
  end else begin
      case (write_mem)
        1'b1: begin
        data[memindex] <= write_data;
        end
 /*        2'b10: begin
        data[memindex][31:0] <= write_data[31:0];
        end
        2'b11: begin
        data[memindex][7:0] <= write_data[7:0];
        end */
        default: begin

        end
      endcase
  end
end

/* initial begin
/*     data[0]=64'h0000_0000_0000_0143; //323
    data[1]=64'h0000_0000_0000_007B; //123
    data[2]=64'h0000_0000_FFFF_FE39; //-455
    data[3]=64'h0000_0000_0000_0002; //2
    data[4]=64'h0000_0000_0000_0062; //98
    data[5]=64'h0000_0000_0000_007D; //125
    data[6]=64'h0000_0000_0000_000A; //10
    data[7]=64'h0000_0000_0000_0041; //65
    data[8]=64'h0000_0000_FFFF_FFC8; //-56
    data[9]=64'h0000_0000_0000_0000; //0 */
/* 	data[73]=64'h0000_0000_0000_0008; //8
    data[74]=64'h0000_0000_0000_000A; //10
    data[75]=64'hFFFF_FFFF_FFFF_FFFE; //-2
    data[76]=64'h0000_0000_0000_0006; //6
    data[77]=64'h0000_0000_0000_0004; //4
end */ 

endmodule

