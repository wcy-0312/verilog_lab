module testbench;

    reg x,y,c_in;

    wire s,c;

    FA adder(.x(x),.y(y),.c_in(c_in),.sum(s),.c_out(c));

    initial begin

        x = 0;

        y = 0;

        c_in = 0;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 1;

        y = 0;

        c_in = 0;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 0;

        y = 1;

        c_in = 0;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 1;

        y = 1;

        c_in = 0;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 0;

        y = 0;

        c_in = 1;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 1;

        y = 0;

        c_in = 1;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 0;

        y = 1;

        c_in = 1;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        #20 

        x = 1;

        y = 1;

        c_in = 1;

        #5

        $display ("X = %d , Y = %d , C_in = %d , C_out = %d , S = %d\n",x,y,c_in,c,s);

        $finish;

    end

endmodule



module HA(a, b, sum, carry);

input a, b;

output sum, carry;

reg sum, carry;

always@(a or b)

begin

sum = a^b;

carry = a&b;

end

endmodule



module FA(x,y,c_in,sum,c_out);

    input x,y,c_in;
    reg s1, c1, c2;
    output reg sum,c_out;

    /* modify the code here*/
    always@(*)
    begin
    
        s1 = x ^ y;
        c1 = x & y;
        
        sum = s1 ^ c_in;
        c2 = s1 & c_in;
        c_out = c1 | c2;
    
    end
    
    
    

endmodule

