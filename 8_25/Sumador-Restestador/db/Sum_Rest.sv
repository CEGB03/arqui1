module Sum_Rest#(parameter WIDTH=4)
					(input logic [WIDTH-1:0] a, b,
					input logic cin,
					output logic [WIDTH-1:0] y,
					output logic cout);
	//assign b= cin ? ~b : b;
	//assign {cout, y} = a+b+cin;
	assign {cout, y} = cin ? a + ~b + 1 : a + b + ~cin;
endmodule 