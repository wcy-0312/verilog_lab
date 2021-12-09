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


module Lab8(clk,reset, dot_row, dot_col);
input clk,reset;
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
 
 case(row_count)
 3'd0: dot_col <= 8'b00011000;
 3'd1: dot_col <= 8'b00100100;
 3'd2: dot_col <= 8'b01000010;
 3'd3: dot_col <= 8'b11000011;
 3'd4: dot_col <= 8'b01000010;
 3'd5: dot_col <= 8'b01000010;
 3'd6: dot_col <= 8'b01000010;
 3'd7: dot_col <= 8'b01111110;
 endcase
 end
end

endmodule
