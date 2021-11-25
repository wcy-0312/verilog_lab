`define TimeExpire 32'd25000000
module cli_div(clk,rst,div_clk);
input clk,rst;
output div_clk;

reg div_clk;
reg [31:0]count;

always@(posedge clk)
begin
 if(!rst)
 begin
 count<=32'd0;
 div_clk<=1'b0;
 end
 else
 begin
 if(count==`TimeExpire)
 begin
 count<=32'd0;
 div_clk<=!div_clk;
 end
 else
 begin
 count<=count+32'd1;
 end 
 end
end

endmodule

module seven(count,out);
input [3:0] count;
output reg[6:0] out;
always@(count)
begin
case(count)
 4'd0 : out =  7'b0000001 ;
 4'd1 : out =  7'b1001111 ;
 4'd2 : out =  7'b0010010 ;
 4'd3 : out =  7'b0000110 ;
 4'd4 : out =  7'b1001100 ;
 4'd5 : out =  7'b0100100 ;
 4'd6 : out =  7'b0100000 ;
 4'd7 : out =  7'b0001111 ;
 4'd8 : out =  7'b0000000 ;
 4'd9 : out =  7'b0000100 ;
 4'd10 : out = 7'b0001000 ;
 4'd11 : out = 7'b1100000 ;
 4'd12 : out = 7'b0110001 ;
 4'd13 : out = 7'b1000010 ;
 4'd14 : out = 7'b0110000 ;
 4'd15 : out = 7'b0111000 ;
endcase
end
endmodule

module Lab7(clk,reset,out,in);
input clk,reset,in;
reg [3:0] count;
reg [2:0]state, next_state;
wire clk_div;
output [6:0] out;
parameter s0=3'd0, s1=3'd1, s2=3'd2,s3=3'd3,s4=3'd4,s5=3'd5;
cli_div c(.clk(clk),.rst(reset),.div_clk(clk_div));
seven useven(.count(count),.out(out));

always@(posedge clk_div or negedge reset)
begin
 if(!reset) 
 begin
  state = s0;
 end
 else 
 begin
  state = next_state;
  
 case(state)
 s0:begin
 if(in==1) next_state = s3;
 else next_state = s1;
 end
 
 s1:begin
 if(in==1) next_state = s5;
 else next_state = s2;
 end
 
 s2:begin
 if(in==1) next_state = s0;
 else next_state = s3;
 end
 
 s3:begin
 if(in==1) next_state = s1;
 else next_state = s4;
 end
 
 s4:begin
 if(in==1) next_state = s2;
 else next_state = s5;
 end
 
 s5:begin
 if(in==1) next_state = s4;
 else next_state = s0;
 end
 endcase
 
 
 end
end

always@(state)
begin
 case(state)
 s0:count=32'd0;
 s1:count=32'd1;
 s2:count=32'd2;
 s3:count=32'd3;
 s4:count=32'd4;
 s5:count=32'd5;
 endcase
end
endmodule
