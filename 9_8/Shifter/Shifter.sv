//*
module Shifter1 #(parameter N=4)(
					input logic [N-1:0] F,
					input logic [1:0] H,
					input logic IL, IR,
					output logic [N-1:0] S);
	always_comb
	case(H)
		2'b00: S=F;
		2'b01: S={F[N-2:0],IL};
		2'b10: S={IR, F[N-1:1]};
		2'b11: S= { N {1'b0}};
	endcase
endmodule
/*/
/*
module Shifter2 #(parameter N=4)(
					input logic [N-1:0] F,
					input logic [1:0] H,
					//input logic IL, IR,
					output logic [N-1:0] S);
	always_comb
	case(H)
		2'b00: S=F;
		2'b01: S=F<<1;
		2'b10: S=F>>1;
		2'b11: S= { N {1'b0}};
	endcase
endmodule
*/
/*
module Shifter #(parameter N=4)(
					input logic [N-1:0] F,
					input logic [1:0] H,
					input logic IL, IR,
					output logic [N-1:0] S);
	
	assign S=H[1]?(H[0] ? {N {1'b0}} 		//11
								:{IR,F[N-1:1]})	//10
					:(H[0] ? {F[N-2:0],IL}		//01
								:F);					//00
endmodule

*/