`define Time_Expire 32'd500000
`define Time_Expire_dot 32'd5000
module lab10(clk, rst, keypadRow, keypadCol, dot_col, dot_row);
	input clk, rst;
	input[3:0] keypadCol;
	output[3:0] keypadRow;
	output reg[7:0] dot_col;
	output reg[7:0] dot_row;
	reg [2:0] row_count;
	
	reg[3:0] keypadBuf;
	reg[3:0] keypadRow;
	reg[31:0] keypadDelay;
	reg[31:0] dotDelay;
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			dot_col <= 8'b0;
			dot_row <= 8'b0;
			row_count <= 3'b0;
			keypadRow <= 4'b1110;
			keypadBuf <= 4'b0;
			keypadDelay <= 31'd0;
			dotDelay <= 31'd0;
		end
		else
		begin
			if(keypadDelay == `Time_Expire)
			begin
				keypadDelay = 31'd0;
				case({keypadRow, keypadCol})
					8'b1110_1110:keypadBuf <= 4'h7;
					8'b1110_1101:keypadBuf <= 4'h4;
					8'b1110_1011:keypadBuf <= 4'h1;
					8'b1110_0111:keypadBuf <= 4'h0;
					
					8'b1101_1110:keypadBuf <= 4'h8;
					8'b1101_1101:keypadBuf <= 4'h5;
					8'b1101_1011:keypadBuf <= 4'h2;
					8'b1101_0111:keypadBuf <= 4'ha;
				
					8'b1011_1110:keypadBuf <= 4'h9;
					8'b1011_1101:keypadBuf <= 4'h6;
					8'b1011_1011:keypadBuf <= 4'h3;
					8'b1011_0111:keypadBuf <= 4'hb;
					
					8'b0111_1110:keypadBuf <= 4'hc;
					8'b0111_1101:keypadBuf <= 4'hd;
					8'b0111_1011:keypadBuf <= 4'he;
					8'b0111_0111:keypadBuf <= 4'hf;
					
					default:keypadBuf <= keypadBuf;
				endcase
				
				case(keypadRow)
					4'b1110:keypadRow <= 4'b1101;
					4'b1101:keypadRow <= 4'b1011;
					4'b1011:keypadRow <= 4'b0111;
					4'b0111:keypadRow <= 4'b1110;
					default:keypadRow <= 4'b1110;
				endcase
			end
			else
			begin
				keypadDelay <= keypadDelay + 31'd1;
			end
			
			if(dotDelay == `Time_Expire_dot)
			begin
				dotDelay = 31'd0;
				row_count <= row_count + 1;
				case(row_count)
					3'd0:   dot_row <= 8'b01111111;
					3'd1:	dot_row <= 8'b10111111;
					3'd2:	dot_row <= 8'b11011111;
					3'd3:	dot_row <= 8'b11101111;
					3'd4:	dot_row <= 8'b11110111;
					3'd5:	dot_row <= 8'b11111011;
					3'd6:	dot_row <= 8'b11111101;
					3'd7:	dot_row <= 8'b11111110;
				endcase
				case(keypadBuf)
				4'h0:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b11000000;
						3'd7:	dot_col <= 8'b11000000;
					endcase
				end
				4'h1:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00110000;
						3'd7:	dot_col <= 8'b00110000;
					endcase
				end
				4'h2:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00110000;
						3'd5:	dot_col <= 8'b00110000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'h3:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00110000;
						3'd3:	dot_col <= 8'b00110000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'h4:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00001100;
						3'd7:	dot_col <= 8'b00001100;
					endcase
				end
				4'h5:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00001100;
						3'd5:	dot_col <= 8'b00001100;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'h6:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00001100;
						3'd3:	dot_col <= 8'b00001100;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'h7:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000011;
						3'd7:	dot_col <= 8'b00000011;
					endcase
				end
				4'h8:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000011;
						3'd5:	dot_col <= 8'b00000011;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'h9:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000011;
						3'd3:	dot_col <= 8'b00000011;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'ha:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1: 	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b11000000;
						3'd5:	dot_col <= 8'b11000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'hb:
				begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000000;
						3'd1:	dot_col <= 8'b00000000;
						3'd2:	dot_col <= 8'b11000000;
						3'd3:	dot_col <= 8'b11000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'hc:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00000011;
						3'd1:	dot_col <= 8'b00000011;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'hd:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00001100;
						3'd1:	dot_col <= 8'b00001100;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'he:begin
					case(row_count)
						3'd0:   dot_col <= 8'b00110000;
						3'd1:	dot_col <= 8'b00110000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				4'hf:begin
					case(row_count)
						3'd0:   dot_col <= 8'b11000000;
						3'd1:	dot_col <= 8'b11000000;
						3'd2:	dot_col <= 8'b00000000;
						3'd3:	dot_col <= 8'b00000000;
						3'd4:	dot_col <= 8'b00000000;
						3'd5:	dot_col <= 8'b00000000;
						3'd6:	dot_col <= 8'b00000000;
						3'd7:	dot_col <= 8'b00000000;
					endcase
				end
				endcase
			end
			else
			begin
				dotDelay <= dotDelay + 31'd1;
			end
		end
	end
endmodule
