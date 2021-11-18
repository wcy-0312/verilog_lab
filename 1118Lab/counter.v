`define TimeExpire 32'd25000000

module Clk_div(clk,rst,div_clk);
input clk, rst;
output div_clk;

reg div_clk;
reg [31:0]count;

always@(posedge clk)
begin
    if(!rst)
    begin
        count <= 32'd0;
        div_clk <= 1'b0;
    end
    else
    begin
        if(count == `TimeExpire)
        begin
            count <= 32'd0;
            div_clk <= ~div_clk;
        end
        else
        begin
            count <= count + 32'd1;
        end
    end
end
endmodule


module Display(count, out);
input count;
output reg [6:0]out;

always@(*) begin
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


module counter(clk, rst, out)
input clk, rst;
wire clk_div;
output [6:0]out;
reg [3:0]count;

Clk_div clock_div(.clk(clk), .rst(rst), .div_clk(clk_div));
Display display(.count(count), .out(out));

always@(posedge clk_div)
begin
    if(!rst)
    begin
        count <= 4'd0;
    end
    else
    begin
        if(count == 4'd15)
        begin
            count <= 4'd0;
        end
        else
        begin
        count <= count +4'd1;
        end
    end
    
end
endmodule



