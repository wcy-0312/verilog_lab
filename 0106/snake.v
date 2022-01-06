module VGA(
	input clk,
	input rst,
	input red_btn,
	input green_btn,
	input blue_btn,
	output reg [3:0] red,
	output reg [3:0] green,
	output reg [3:0] blue,
	output reg h_sync,
	output reg v_sync
);

reg half_clk;
reg [1:0] h_mode;
reg [1:0] v_mode;
reg [31:0] h_counter;
reg [31:0] v_counter;
reg [3:0] red_amount;
reg [3:0] green_amount;
reg [3:0] blue_amount;
reg red_clicked;
reg green_clicked;
reg blue_clicked;

parameter [31:0] h_a = 32'd95;
parameter [31:0] h_b = 32'd47;
parameter [31:0] h_c = 32'd639;
parameter [31:0] h_d = 32'd15;

parameter [31:0] v_a = 32'd1599;
parameter [31:0] v_b = 32'd26399;
parameter [31:0] v_c = 32'd383999;
parameter [31:0] v_d = 32'd7999;


/* Devide 50MHZ clk into 25MHZ half_clk */
always@(posedge clk) begin
	if(!rst) begin
		half_clk <= 1'd0;
		red_clicked <= 1'd0;
		green_clicked <= 1'd0;
		blue_clicked <= 1'd0;
		red_amount <= 4'd0;
		green_amount <= 4'd0;
		blue_amount <= 4'd0;
	end
	else begin
		half_clk <= ~half_clk;
		
		if(red_btn) begin
			if(!red_clicked) begin
				red_amount <= red_amount + 1;
				red_clicked <= 1'd1;
			end
		end
		else begin
			red_clicked <= 1'd0;
		end
		
		if(green_btn) begin
			if(!green_clicked) begin
				green_amount <= green_amount + 1;
				green_clicked <= 1'd1;
			end
		end
		else begin
			green_clicked <= 1'd0;
		end

		
		if(blue_btn) begin
			if(!blue_clicked) begin
				blue_amount <= blue_amount + 1;
				blue_clicked <= 1'd1;
			end
		end
		else begin
			blue_clicked <= 1'd0;
		end
	end
end


always@(posedge half_clk) begin
	if(!rst) begin
		h_counter <= 32'd0;
		v_counter <= 32'd0;
		h_sync <= 1'd0;
		v_sync <= 1'd0;
		h_mode <= 2'd0;
		v_mode <= 2'd0;
		
		red <= 4'd0;
		green <= 4'd0;
		blue <= 4'd0;
	end
	else begin
		if(h_counter == h_a && h_mode == 2'd0) begin
			h_counter <= 32'd0;
			h_mode <= 2'd1;
			h_sync <= 1'd1;
		end
		else if(h_counter == h_b && h_mode == 2'd1) begin
			h_counter <= 32'd0;
			h_mode <= 2'd2;
			
			red <= red_amount;
			green <= green_amount;
			blue <= blue_amount;
		end
		else if(h_counter == h_c && h_mode == 2'd2) begin
			h_counter <= 32'd0;
			h_mode <= 2'd3;
			
			red <= 4'd0;
			green <= 4'd0;
			blue <= 4'd0;
		end
		else if(h_counter == h_d && h_mode == 2'd3) begin
			h_counter <= 32'd0;
			h_mode <= 2'd0;
			h_sync <= 1'd0;
		end
		else begin
			h_counter <= h_counter + 32'd1;
		end
		
		
		if(v_counter == v_a && v_mode == 2'd0) begin
			v_counter <= 32'd0;
			v_mode <= 2'd1;
			v_sync <= 1'd1;
		end
		else if(v_counter == v_b && v_mode == 2'd1) begin
			v_counter <= 32'd0;
			v_mode <= 2'd2;
		end
		else if(v_counter == v_c && v_mode == 2'd2) begin
			v_counter <= 32'd0;
			v_mode <= 2'd3;	
		end
		else if(v_counter == v_d && v_mode == 2'd3) begin
			v_counter <= 32'd0;
			v_mode <= 2'd0;
			v_sync <= 1'd0;
		end
		else begin
			v_counter <= v_counter + 32'd1;
		end
	end
end


endmodule
