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
 4'b0000: begin out = 7'b1000000;end 
 4'b0001: begin out = 7'b1111001;end
 4'b0010: begin out = 7'b0100100;end
 4'b0011: begin out = 7'b0110000;end
 4'b0100: begin out = 7'b0011001;end
 4'b0101: begin out = 7'b0010010;end
 4'b0110: begin out = 7'b0000010;end
 4'b0111: begin out = 7'b1111000;end
 4'b1000: begin out = 7'b0000000;end
 4'b1001: begin out = 7'b0010000;end
 4'b1010: begin out = 7'b0001000;end
 4'b1011: begin out = 7'b0000011;end
 4'b1100: begin out = 7'b1000110;end
 4'b1101: begin out = 7'b0100001;end
 4'b1110: begin out = 7'b0000110;end
 4'b1111: begin out = 7'b0001110;end
endcase
end
endmodule

module Lab6(clk,reset,out);
input clk,reset;
reg [3:0] count;
wire clk_div;
output [6:0] out;
cli_div c(.clk(clk),.rst(reset),.div_clk(clk_div));
seven useven(.count(count),.out(out));

always@(posedge clk_div or negedge reset)
begin
 if(!reset) 
 begin
 count <= 4'b0000;
 end
 else 
 begin
 
 //always@(posedge clk_div)
 
 if(count==4'b1111)
 count <= 4'b0000;
 else
 count <= count + 1'b1;
 end
end
endmodule
