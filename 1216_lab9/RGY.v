`define TimeExpire 32'd2500
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

module counter16(clk, rst, recount_counter16, count_out);
input clk, rst, recount_counter16;
output reg[3:0] count_out;

always@(posedge clk) begin
if(!rst) count_out=0;
else begin
 if(recount_counter16) count_out=0;
 else count_out=count_out+1;
 end
end
endmodule

module compare(curr_t, RGY, recount_counter16);
input[2:0] RGY;
input[3:0] curr_t;
output reg recount_counter16;
parameter R_t=10, G_t=15, Y_t=5;

always@(RGY) begin
case(RGY)
 3'b100:begin
  if(curr_t==R_t) recount_counter16=1;
  else recount_counter16=0;
  end
  
 3'b001:begin
  if(curr_t==Y_t) recount_counter16=1;
  else recount_counter16=0;
  end
 
 3'b010:begin
  if(curr_t==G_t) recount_counter16=1;
  else recount_counter16=0;
  end
 default recount_counter16=1;
endcase
end
endmodule

module traffic_control(clk, rst, recount_counter16, R, G, Y);
input clk, rst, recount_counter16;
output reg R, G, B;
reg[1:0] curr_state, next_state;
reg[2:0] count;

parameter[1:0] R_light=0, G_light=1, Y_light=2;

always@(posedge clk) begin
if(!rst) begin
curr_state=G_light;
count=3'd15;
else curr_state=next_state;
end

always@(curr_state) begin
case(curr_state)
 R_light:begin
  if(recount_counter16) next_state=G_light;
  else next_state=R_light;
  end
  
 G_light:begin
  if(recount_counter16) next_state=Y_light;
  else next_state=G_light;
  end
 
 Y_light:begin
  if(recount_counter16) next_state=Y_light;
  else next_state=Y_light;
  end
 default: next_state=R_light;
endcase
end

always@(curr_state) begin
case(curr_state)
 R_light: begin
  R=1'b1;
  Y=1'b0;
  G=1'b0;
  end
  
 G_light: begin
  R=1'b0;
  Y=1'b0;
  G=1'b1;
  end
  
 Y_light: begin
  R=1'b0;
  Y=1'b1;
  G=1'b0;
  end
 default:begin
  R=1'b0;
  Y=1'b0;
  G=1'b0;
  end
endcase
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

module RGY_LED(clk,reset, curr_state, dot_row, dot_col);
input clk,reset;
input[2:0] curr_state;
output reg[7:0] dot_row, dot_col;
reg [2:0]row_count;
wire clk_div;
cli_div c(.clk(clk),.rst(reset),.div_clk(clk_div));

always@(posedge clk_div or negedge reset)
begin
 if(!reset) begin
  dot_row <= 8'b0;
  dot_col <= 8'b0;
  row_count <= 0;
 end
 else begin
  row_count <= row_count+1;
  
 case(row_count)
 3'd0: dot_row <= 8'b01111111;
 3'd1: dot_row <= 8'b10111111;
 3'd2: dot_row <= 8'b11011111;
 3'd3: dot_row <= 8'b11101111;
 3'd4: dot_row <= 8'b11110111;
 3'd5: dot_row <= 8'b11111011;
 3'd6: dot_row <= 8'b11111101;
 3'd7: dot_row <= 8'b11111110;
 endcase
 
 if(curr_state==3'b100) begin
  case(row_count)
  3'd0: dot_col <= 8'b00011000;
  3'd1: dot_col <= 8'b00011000;
  3'd2: dot_col <= 8'b00111100;
  3'd3: dot_col <= 8'b00111100;
  3'd4: dot_col <= 8'b01011010;
  3'd5: dot_col <= 8'b00011000;
  3'd6: dot_col <= 8'b00011000;
  3'd7: dot_col <= 8'b00100100;
  endcase
  end
  
 if(curr_state==3'b010) begin
  case(row_count)
  3'd0: dot_col <= 8'b00001100;
  3'd1: dot_col <= 8'b00001100;
  3'd2: dot_col <= 8'b00011001;
  3'd3: dot_col <= 8'b01111110;
  3'd4: dot_col <= 8'b10011000;
  3'd5: dot_col <= 8'b00011000;
  3'd6: dot_col <= 8'b00101000;
  3'd7: dot_col <= 8'b01001000;
  endcase
  end
  
 if(curr_state==3'b001) begin
  case(row_count)
  3'd0: dot_col <= 8'b00000000;
  3'd1: dot_col <= 8'b00100100;
  3'd2: dot_col <= 8'b00111100;
  3'd3: dot_col <= 8'b10111101;
  3'd4: dot_col <= 8'b11111111;
  3'd5: dot_col <= 8'b00111100;
  3'd6: dot_col <= 8'b00111100;
  3'd7: dot_col <= 8'b00000000;
  endcase
  end
  
 end
end

endmodule


module traffic(clk, rst, R, G, Y);
input clk, rst;
output R, G, Y;
wire recount_counter;
wire[3:0] counter_num;

Traffic_Control tc(.clk(clk), .rst(rst), .recount_counter16(recount_counter), .R(R), .G(G), .Y(Y));
Datapath(.clk(clk), .rst(rst), .RGY({R, G, Y}), .recount(recount_counter));

endmodule

module Datapath(clk, rst, RGY, recount);
input clk, rst;
input[2:0]RGY;
output recount;
wire count_num;

Compare c1(.curr_t(count_num), .RGY(RGY), .recount_counter16(recount));
compare16 c2(.clk,(clk), .rst(rst), .recount_counter16(recount), .count_out(count_num));
endmodule





















