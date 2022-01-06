module clk_divider(
input clk,
output reg divided_clk
);

always@(posedge clk) begin
	divided_clk <= ~divided_clk;
end
endmodule
module clk_divider_2Hz(
input clk,
output reg divided_clk
);

reg [31:0] counter=31'd0;
always@(posedge clk) begin
	if(counter == 31'd12500000) begin
		counter <= 31'd0;
		divided_clk <= ~divided_clk;
	end
	else begin
		counter <= counter + 31'd1;
	end

end
endmodule
module clk_divider_4Hz(
input clk,
output reg divided_clk
);

reg [31:0] counter=31'd0;
always@(posedge clk) begin
	if(counter == 31'd6250000) begin
		counter <= 31'd0;
		divided_clk <= ~divided_clk;
	end
	else begin
		counter <= counter + 31'd1;
	end

end
endmodule

module horizontal_counter(
input clk_25MHz,
output reg enable_v_counter = 1'b0,
output reg [15:0] h_count_value = 16'd0
);
always@(posedge clk_25MHz) begin
	if(h_count_value < 799) begin
		h_count_value <= h_count_value + 16'd1;
		enable_v_counter <= 1'b0;
	end
	else begin
		h_count_value <= 16'd0;
		enable_v_counter <= 1'b1;
	end
end
endmodule

module vertical_counter(
input clk_25MHz,
input enable_v_counter,
output reg [15:0] v_count_value = 16'd0
);
always@(posedge clk_25MHz) begin
	if (enable_v_counter == 1'b1) begin
		if(v_count_value < 524) begin
			v_count_value <= v_count_value + 16'd1;
		end
		else begin
			v_count_value <= 16'd0;
		end
	end
end
endmodule

module snake(
input clk,
output H_sync,
output V_sync,
output [3:0] red,
output [3:0] green,
output [3:0] blue
);

reg [3:0] r_red = 0;
reg [3:0] r_green = 0;
reg [3:0] r_blue = 0;
reg [6:0] snake_x=7'd0;
reg [6:0] snake_y=7'd0;
reg [6:0] snake_x_pre;
reg [6:0] snake_y_pre;
reg [6:0] snake_x_past[127:0];
reg [6:0] snake_y_past[127:0];
reg [6:0] snake_len=7'd0;

wire clk_25MHz;
wire clk_2Hz;
wire clk_4Hz;
wire enable_v_counter;
wire [15:0] h_count_value;
wire [15:0] v_count_value;
wire [31:0] snake_x_f;
wire [31:0] snake_x_s;
wire [31:0] snake_y_f;
wire [31:0] snake_y_s;
wire ondisplay;
wire border;

clk_divider my_clk_divider(clk,clk_25MHz);
clk_divider_2Hz my_clk_divider_2Hz(clk,clk_2Hz);
clk_divider_4Hz my_clk_divider_4Hz(clk,clk_4Hz);
horizontal_counter my_horizontal_counter(clk_25MHz,enable_v_counter,h_count_value);
vertical_counter my_vertical_counter(clk_25MHz,enable_v_counter,v_count_value);


assign snake_x_f = 144 + snake_x * 10;
assign snake_x_s = 144 + (snake_x + 1) * 10;
assign snake_y_f = 35 + snake_y * 10;
assign snake_y_s = 35 + (snake_y + 1) * 10;
integer len_counter;
assign snake_x_f_p = 144 + snake_x_past[len_counter] * 10;
assign snake_x_s_p = 144 + (snake_x_past[len_counter] + 1) * 10;
assign snake_y_f_p = 35 + snake_y_past[len_counter] * 10;
assign snake_y_s_p = 35 + (snake_y_past[len_counter] + 1) * 10;
always@(posedge clk_2Hz) begin
	if(snake_x_past[0] == 7'd64) begin
		snake_x_past[0] <= 7'd0;
	end
	else begin
		snake_x_pre <= snake_x_past[0];
		snake_y_pre <= snake_y_past[0];
		snake_x_past[0] <= snake_x_past[0] + 7'd1;
	end
end
integer len_counter2;
always@(snake_x_past[0] or snake_y_past[0]) begin
	if(snake_len > 7'd0) begin
		for(len_counter2 = 1;len_counter2 < snake_len ;len_counter2 = len_counter2 + 1) begin
			snake_x_past[len_counter2] <= snake_x_past[len_counter2 - 1];
			snake_y_past[len_counter2] <= snake_y_past[len_counter2 - 1];
		end
		snake_x_past[1] <= snake_x_pre;
		snake_y_past[1] <= snake_y_pre;
	end
end

always@(posedge clk_4Hz) begin
	if(snake_len > 7'd64) begin
		snake_len <= 7'd0;
	end
	else begin
		snake_len <= snake_len + 7'd1;
	end
end
reg found;
always@(posedge clk_25MHz) begin
/*	if((h_count_value > snake_x_f) && (h_count_value < snake_x_s) && (v_count_value > snake_y_f) && (v_count_value < snake_y_s)) begin
		r_green <= 4'hf;
	end
	else */
	if (snake_len >= 7'd0)begin
		found = 1'd0;
		for(len_counter = 0;len_counter <= snake_len;len_counter = len_counter+1) begin
			if(!found) begin
				if((h_count_value > 144 + snake_x_past[len_counter] * 10) && (h_count_value < 144 + (snake_x_past[len_counter] + 1) * 10) && (v_count_value > 35 + snake_y_past[len_counter] * 10) && (v_count_value < 35 + (snake_y_past[len_counter] + 1) * 10)) begin
					r_green <= 4'hf;
					found = 1'b1;
				end
				else begin
					r_green <= 4'h0;
				end
			end
		end
	end
	else begin
		r_green <= 4'h0;
	end
end
assign H_sync = (h_count_value < 96) ? 1'b1:1'b0;
assign V_sync = (v_count_value < 2) ? 1'b1:1'b0;
 
assign border = (((h_count_value > 143) && (h_count_value < 153) || (h_count_value > 774) && (h_count_value < 784)) || ((v_count_value > 34) && (v_count_value < 44) || (v_count_value > 505) && (v_count_value < 515)));

assign ondisplay = (h_count_value < 784 && h_count_value > 144 && v_count_value < 515 && v_count_value>35);
assign red = (ondisplay) ? r_red:4'h0;
assign green = (ondisplay) ? r_green:4'h0;
assign blue = (ondisplay) ? r_blue:4'h0;

endmodule
