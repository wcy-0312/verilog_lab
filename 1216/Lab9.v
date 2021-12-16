module lab9(clock,reset,dot_row,dot_col,out);

input clock,reset;
reg [2:0]row_count;
reg [3:0] counter;
reg[1:0] state;
output reg [7:0] dot_row;
output reg [7:0] dot_col;
output [6:0] out;
parameter green=2'd0, yellow=2'd1, red=2'd2;

clk_div_matrix clk_div_u_matrix(.clk(clock),.rst(reset),.div_clk(freq_matrix));
clk_div_seven clk_div_u_seven(.clk(clock),.rst(reset),.div_clk(freq_seven));
seven useven(.count(counter),.out(out));

always@(posedge freq_seven or negedge reset)
begin
if(!reset)
begin
counter=4'd15;
state=green;
end

else
begin
if(state==green && counter==4'd0)
begin
state=yellow;
counter=4'd5;
end
else if(state==yellow && counter==4'd0)
begin
state=red;
counter=4'd10;
end
else if(state==red && counter==4'd0)
begin
state=green;
counter=4'd15;
end
else
counter=counter-1;
end
  
end

always@(posedge freq_matrix or negedge reset)
begin
if(!reset)
begin
dot_row<=8'b0;
dot_col<=8'b0;
row_count<=0;
end
else
begin
row_count<=row_count+1;
case(row_count)
3'd0:dot_row<=8'b01111111;
3'd1:dot_row<=8'b10111111;
3'd2:dot_row<=8'b11011111;
3'd3:dot_row<=8'b11101111;
3'd4:dot_row<=8'b11110111;
3'd5:dot_row<=8'b11111011;
3'd6:dot_row<=8'b11111101;
3'd7:dot_row<=8'b11111110;
endcase
case(State)

green:case(row_count)
3'd0:dot_col<=8'b00001100;
3'd1:dot_col<=8'b00001100;
3'd2:dot_col<=8'b00011001;
3'd3:dot_col<=8'b01111110;
3'd4:dot_col<=8'b10011000;
3'd5:dot_col<=8'b00011000;
3'd6:dot_col<=8'b00101000;
3'd7:dot_col<=8'b01001000;
endcase

yellow:case(row_count)
3'd0:dot_col<=8'b00000000;
3'd1:dot_col<=8'b00100100;
3'd2:dot_col<=8'b00111100;
3'd3:dot_col<=8'b10111101;
3'd4:dot_col<=8'b11111111;
3'd5:dot_col<=8'b00111100;
3'd6:dot_col<=8'b00111100;
3'd7:dot_col<=8'b00000000;
endcase

red:case(row_count)
3'd0:dot_col<=8'b00011000;
3'd1:dot_col<=8'b00011000;
3'd2:dot_col<=8'b00111100;
3'd3:dot_col<=8'b00111100;
3'd4:dot_col<=8'b01011010;
3'd5:dot_col<=8'b00011000;
3'd6:dot_col<=8'b00011000;
3'd7:dot_col<=8'b00100100;
endcase
endcase
end
end
endmodule


module clk_div_matrix(clk,rst,div_clk);

input clk,rst;
output reg div_clk;

reg [31:0] count;

always@(posedge clk)
begin
if(!rst)
begin
count<=32'd0;
div_clk<=1'b0;
end
else
begin
if(count == 32'd2500)
begin
count <='d0;
div_clk<=~div_clk;
end
else
begin
count<=count+32'd1;
end
end
end
endmodule

module clk_div_seven(clk,rst,div_clk);

input clk,rst;
output reg div_clk;

reg [31:0] count;

always@(posedge clk)
begin
if(!rst)
begin
count<=32'd0;
div_clk<=1'b0;
end
else
begin
if(count == 32'd25000000)
begin
count <='d0;
div_clk<=~div_clk;
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
always@(count) begin
case(count)
 4'd0 : out =  7'b1000000 ;
 4'd1 : out =  7'b1111001 ;
 4'd2 : out =  7'b0100100 ;
 4'd3 : out =  7'b0110000 ;
 4'd4 : out =  7'b0011001 ;
 4'd5 : out =  7'b0010010 ;
 4'd6 : out =  7'b0000010 ;
 4'd7 : out =  7'b1111000 ;
 4'd8 : out =  7'b0000000 ;
 4'd9 : out =  7'b0010000 ;
 4'd10 : out = 7'b0001000 ;
 4'd11 : out = 7'b0000011 ;
 4'd12 : out = 7'b1000110 ;
 4'd13 : out = 7'b0100001 ;
 4'd14 : out = 7'b0000110 ;
 4'd15 : out = 7'b0001110 ;
endcase
end
endmodule
