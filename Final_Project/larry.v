module clk_divider_25MHz(
input clk,
input reset,
output reg divided_clk
);

always@(posedge clk or negedge reset) begin
	if(!reset) begin
		divided_clk <= 1'b0;
	end
	else begin
		divided_clk <= ~divided_clk;
	end
end
endmodule
module clk_divider_2Hz(
input clk,
input reset,
output reg divided_clk
);

reg [31:0] counter=31'd0;
always@(posedge clk or negedge reset) begin
	if(!reset) begin
		counter <= 31'd0;
		divided_clk <= 1'd0;
	end
	else begin
		if(counter == 31'd12500000) begin
			counter <= 31'd0;
			divided_clk <= ~divided_clk;
		end
		else begin
			counter <= counter + 31'd1;
		end
	end

end
endmodule
module clk_divider_100Hz(
input clk,
input reset,
output reg divided_clk
);

reg [31:0] counter=31'd0;
always@(posedge clk or negedge reset) begin
	if(!reset) begin
		counter <= 31'd0;
		divided_clk <= 1'd0;
	end
	else begin
		if(counter == 31'd250000) begin
			counter <= 31'd0;
			divided_clk <= ~divided_clk;
		end
		else begin
			counter <= counter + 31'd1;
		end
	end

end
endmodule
module h_sync_signal(
input [15:0] h_count_value,
output h_sync
);

parameter h_pixel = 640,
			 h_front_porch = 16,
			 h_sync_pulse = 96,
			 h_back_porch = 48;

assign h_sync = (h_count_value < h_sync_pulse);
endmodule

module horizontal_counter(
input clk_25MHz,
input reset,
output reg [15:0] h_count_value = 16'd0,
output enable_v_counter
);

assign enable_v_counter = (h_count_value == 16'd799);
always@(posedge clk_25MHz or negedge reset) begin
	if(!reset) begin
		h_count_value <= 16'd0;
	end
	else if(h_count_value == 16'd799) begin
		h_count_value <= 16'd0;
	end
	else begin
		h_count_value <= h_count_value + 16'd1;
	end
end
endmodule

module v_sync_signal(
input [16:0] v_count_value,
output v_sync
);

parameter v_pixel = 480,
			 v_front_porch = 10,
			 v_sync_pulse = 2,
			 v_back_porch = 33;
assign v_sync = (v_count_value<v_sync_pulse);
endmodule

module vertical_counter(
input clk_25MHz,
input reset,
input enable_v_counter,
output reg [15:0] v_count_value = 16'd0
);

always@(posedge clk_25MHz or negedge reset) begin
	if(!reset) begin
		v_count_value <= 16'd0;
	end
	else begin
		if(enable_v_counter) begin
			if(v_count_value == 16'd524) begin
				v_count_value <= 16'd0;
			end
			else begin
				v_count_value <= v_count_value + 16'd1;
			end
		end
	end
end
endmodule

module check_on_display(
input [15:0] h_count_value,
input [15:0] v_count_value,
output on_display
);
parameter h_pixel = 640,
			 h_front_porch = 16,
			 h_sync_pulse = 96,
			 h_back_porch = 48;

parameter h_wait_time = h_sync_pulse + h_back_porch,
			 h_display_over_time = h_wait_time + h_pixel - 1;
			 
parameter v_pixel = 480,
			 v_front_porch = 10,
			 v_sync_pulse = 2,
			 v_back_porch = 33;
parameter v_wait_time = v_sync_pulse + v_back_porch,
			 v_display_over_time = v_wait_time + v_pixel - 1;
assign on_display = (h_count_value >= h_wait_time && h_count_value <= h_display_over_time && v_count_value >= v_wait_time && v_count_value <= v_display_over_time);
endmodule

module output_rgb_signal(
input on_display,
input [3:0] red_input,
input [3:0] green_input,
input [3:0] blue_input,
output [3:0] red_output,
output [3:0] green_output,
output [3:0] blue_output
);

assign red_output = (on_display) ? red_input:4'h0;
assign green_output = (on_display) ? green_input:4'h0;
assign blue_output = (on_display) ? blue_input:4'h0;
endmodule


module KeypadController(clk_100Hz, reset, keypadCol, keypadRow, direction);
    input clk_100Hz, reset;
    input [3:0]keypadCol;
    output reg [3:0]keypadRow;
    
    output reg [1:0]direction;
    parameter UP = 2'd0, DOWN = 2'd1, RIGHT = 2'd2, LEFT = 2'd3;
    
    always@(posedge clk_100Hz or negedge reset)
    begin
        if(!reset)
        begin
            keypadRow = 4'b1110;
            direction = RIGHT;// default direction: right
        end
        else
        begin
            case({keypadRow, keypadCol})
                8'b1011_1101:begin
                    direction <= UP;
                end// press 6
                8'b1110_1101:begin
                    direction <= DOWN;
                end// press 4
                8'b1101_1110:begin
                    direction <= RIGHT;
                end// press 8
                8'b1101_1011:begin
                    direction <= LEFT;
                end// press 2
                default:begin
                    direction <= direction;// maintain previous direction
                end// press invalid buttons
            endcase
            // decide direction
            
            case(keypadRow)
                4'b1110:begin
                    keypadRow <= 4'b1101;
                end
                4'b1101:begin
                    keypadRow <= 4'b1011;
                end
                4'b1011:begin
                    keypadRow <= 4'b0111;
                end
                4'b0111:begin
                    keypadRow <= 4'b1110;
                end
                default:begin
                    keypadRow <= 4'b1110;
                end
            endcase
            // next row
        end
    end
endmodule

module snake(
input clk,
input reset,
input [3:0] keypadCol,
output [3:0] keypadRow,
output H_sync,
output V_sync,
output [3:0] red,
output [3:0] green,
output [3:0] blue
);

wire clk_25MHz;
wire clk_2Hz;
wire clk_100Hz;
wire enable_v_counter;
wire [15:0] h_count_value;
wire [15:0] v_count_value;
wire on_display;
wire [3:0] red_wire;
wire [3:0] green_wire;
wire [3:0] blue_wire;
wire [1:0] direction;
clk_divider_2Hz my_clk_divider_2Hz(clk,reset,clk_2Hz);
clk_divider_25MHz my_clk_divider_25MHz(clk,reset,clk_25MHz);
clk_divider_100Hz my_clk_divider_100Hz(clk,reset,clk_100Hz);
horizontal_counter my_horizontal_counter(clk_25MHz,reset,h_count_value,enable_v_counter);
vertical_counter my_vertical_counter(clk_25MHz,reset,enable_v_counter,v_count_value);
h_sync_signal my_h_sync_signal(h_count_value,H_sync);
v_sync_signal my_v_sync_signal(v_count_value,V_sync);
check_on_display my_check_on_display(h_count_value,v_count_value,on_display);
output_rgb_signal my_output_rgb_signal(on_display,red_wire,green_wire,blue_wire,red,green,blue);
KeypadController (clk_100Hz, reset, keypadCol, keypadRow, direction);
parameter h_pixel = 640,
			 h_front_porch = 16,
			 h_sync_pulse = 96,
			 h_back_porch = 48;

parameter h_wait_time = h_sync_pulse + h_back_porch,
			 h_display_over_time = h_wait_time + h_pixel - 1;
			 
parameter v_pixel = 480,
			 v_front_porch = 10,
			 v_sync_pulse = 2,
			 v_back_porch = 33;
parameter v_wait_time = v_sync_pulse + v_back_porch,
			 v_display_over_time = v_wait_time + v_pixel - 1;

reg [6:0] snake_len=7'd0;
reg [6:0] array_of_snake_x_position[127:0];
reg [6:0] array_of_snake_y_position[127:0];
reg [3:0] green_reg;
reg found;

reg x_OK [63:0] = 1;
reg y_OK [47:0] = 1;

assign green_wire = green_reg;
integer len_counter_s;
initial begin
array_of_snake_x_position[0]=7'd5;
array_of_snake_y_position[0]=7'd0;
array_of_snake_x_position[1]=7'd4;
array_of_snake_y_position[1]=7'd0;
array_of_snake_x_position[2]=7'd3;
array_of_snake_y_position[2]=7'd0;
array_of_snake_x_position[3]=7'd2;
array_of_snake_y_position[3]=7'd0;
array_of_snake_x_position[4]=7'd1;
array_of_snake_y_position[4]=7'd0;
array_of_snake_x_position[5]=7'd0;
array_of_snake_y_position[5]=7'd0;

y_OK[0] = 0;
x_OK[0] = 0;
x_OK[1] = 0;
x_OK[2] = 0;
x_OK[3] = 0;
x_OK[4] = 0;
x_OK[5] = 0;
end
always@(posedge clk_25MHz or negedge reset) begin
	if(!reset) begin
		green_reg <= 4'h0;
	end
	else begin
		found = 1'd0;
		for(len_counter_s = 0;len_counter_s < 128;len_counter_s = len_counter_s + 1) begin
			if(!found && len_counter_s <= snake_len) begin
				if((h_count_value > h_wait_time + array_of_snake_x_position[len_counter_s] * 10) && (h_count_value < h_wait_time + (array_of_snake_x_position[len_counter_s] + 1) * 10) && (v_count_value > v_wait_time + array_of_snake_y_position[len_counter_s] * 10) && (v_count_value < v_wait_time + (array_of_snake_y_position[len_counter_s] + 1) * 10)) begin
					green_reg <= 4'hf;
					found = 1'd1;
				end
				else begin
					green_reg <= 4'h0;
				end
			end
		end
	end
end

integer len_counter_p;
integer ok_count;
reg [9:0] rand;

always@(posedge clk_2Hz or negedge reset) begin
	if(!reset) begin
		//
	end
	else begin
		for(len_counter_p = 127;len_counter_p > 0;len_counter_p=len_counter_p - 1) begin
			if(len_counter_p <= snake_len + 1) begin
				array_of_snake_x_position[len_counter_p] <= array_of_snake_x_position[len_counter_p-1];
				array_of_snake_y_position[len_counter_p] <= array_of_snake_y_position[len_counter_p-1];
			end
		end
		case(direction)
			2'd0: begin
				array_of_snake_y_position[0] <= array_of_snake_y_position[0] - 7'd1;
			end
			2'd1: begin
				array_of_snake_y_position[0] <= array_of_snake_y_position[0] + 7'd1;
			end
			2'd2: begin
				array_of_snake_x_position[0] <= array_of_snake_x_position[0] + 7'd1;
			end
			2'd3: begin
				array_of_snake_x_position[0] <= array_of_snake_x_position[0] - 7'd1;
			end
		endcase
		
		x_OK[array_of_snake_x_position[snake_len]] = 1; // set tail to 0
		y_OK[array_of_snake_x_position[snake_len]] = 1; // set tail to 0
		x_OK[array_of_snake_x_position[0]] = 0; // set head to 0
		y_OK[array_of_snake_x_position[0]] = 0; // set head to 0
		
		if(is_collision) begin
			snake_len <= snake_len + 7'd1;
			rand = {$random} % 64;
			for (ok_count = 0; ok_count < 64; ok_count = ok_count + 1) begin
			    rand = rand + ok_count;
			    if (rand >= 10'd64) begin
			        rand = rand - 10'd64;
			    end
			    else begin
			        rand = rand;
			    end
			    if (x_OK[rand]) begin
			        apple_x_position = x_OK[rand];
			        ok_count = 64;
			    end
			end
			for (ok_count = 0; ok_count < 48; ok_count = ok_count + 1) begin
			    rand = rand + ok_count;
			    if (rand >= 10'd96) begin
			        rand = rand - 10'd96;
			    end
			    else if (rand >= 10'd48) begin
			        rand = rand - 10'd48;
			    end
			    else begin
			        rand = rand;
			    end
			    if (y_OK[rand]) begin
			        apple_y_position = y_OK[rand];
			        ok_count = 48;
			    end
			end
		end
	end
end

reg [3:0] red_reg;
reg [6:0] apple_x_position=7'd30;
reg [6:0] apple_y_position=7'd20;

wire is_collision;
assign is_collision = ((array_of_snake_x_position[0] == apple_x_position) && (array_of_snake_y_position[0] == apple_y_position));
assign red_wire = red_reg;
always@(posedge clk_25MHz or negedge reset) begin
	if(!reset) begin
		red_reg <= 4'h0;
	end
	else begin
		if((h_count_value > h_wait_time + apple_x_position * 10) && (h_count_value < h_wait_time + (apple_x_position + 1) * 10) && (v_count_value > v_wait_time + apple_y_position * 10) && (v_count_value < v_wait_time + (apple_y_position + 1) * 10)) begin
			red_reg <= 4'hf;
		end
		else begin
			red_reg <= 4'h0;
		end
	end
end

endmodule
