module testbench;



    reg     [2:0]   in;

    reg             enable;



    wire    [7:0]   out;



    decoder u1(.in(in),.enable(enable),.out(out));



    initial begin

        

        // enable = 0

        enable = 1'b0;



        in = 3'b000;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b001;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b010;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b011;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b100;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b101;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20



        in = 3'b110;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20





        in = 3'b111;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20



        // enable = 1

        enable = 1'b1;



        in = 3'b000;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b001;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b010;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        

        #20

        in = 3'b011;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b100;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20

        

        in = 3'b101;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20



        in = 3'b110;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);

        #20





        in = 3'b111;



        #5

        $display ("in = %b, enable = %b; out = %b", in, enable, out);



        $finish;



    end



endmodule





module decoder(in, enable, out);



    input       [2:0]   in;

    input               enable;



    output reg  [7:0]   out;



    /* modify the code here*/    
    always@(*)
    begin
        case({enable,in})
        4'b1000: out = 8'b00000001;
        4'b1001: out = 8'b00000010;
        4'b1010: out = 8'b00000100;
        4'b1011: out = 8'b00001000;
        4'b1100: out = 8'b00010000;
        4'b1101: out = 8'b00100000;
        4'b1110: out = 8'b01000000;
        4'b1111: out = 8'b10000000;
        default: out = 8'b00000000;
        endcase
    end


endmodule
