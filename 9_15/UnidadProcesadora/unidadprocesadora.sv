module unidadprocesadora #(parameter N=4)(
                input logic clk,
				input logic [15:0] ctr_word,
				input logic [N-1:0] DATA_in,
				output logic [3:0] stateBits,
				output logic [N-1:0] DATA_out);
        
        logic [N-1:0] busA, busB, RegA, RegB, ALU_cout;
        logic [2:0] A, B, D;
        logic [3:0] Flags;
/*  
    A 1,2,3			=15-13
    B 4,5,6			=12-10
    D 7,8,9			=9-7
    F 10,11,12,13	=6-3
    H 14,15,16		=2-0
*/
    assign A = ctr_word[15:13];
    assign B = ctr_word[12:10];
    assign D = ctr_word[9:7];


    assign busA = ((A!=0) ? RegA : DATA_in);
    assign busB = ((B!=0) ? RegB : DATA_in);
	

    //ram3port files (clk, (D!=0), A, B, D, RegA, RegB, DATA_out);
	ram3port #(3,4) files (clk, (D!=0), A, B, D, RegA, RegB, DATA_out);
	/*parameter N = 2, M = 4
	(input logic clk||,input logic we3||,input logic [N-1:0] a1, a2, a3,output logic [M-1:0] d1, d2,input logic [M-1:0] d3);
	*/

    alu alu (busA, busB, ctr_word[6:3], ALU_cout, Flags);

	 //input logic [N-1:0] F,input logic [N-2:0] H,output logic [N-1:0] S);
    Shifter2 corrimiento(ALU_cout, ctr_word[2:0], DATA_out);

    always_ff @(posedge clk)
        begin//					v    	s		z		c
				//ALUFlags = {overflow, neg, zero, acarreo};
            stateBits <= Flags;
        end


endmodule 

//		La condicion para la utilizacion de la siguiente aplicacion de Alu, es que sean ambos numeros de igual signo
module alu #(parameter N=4)
				(input logic [N-1:0] a,b,
				input logic [3:0] ALUControl,
				output logic [N-1:0] Result,
				output logic [3:0] ALUFlags);
				
		//		Señales Internas
		logic neg, zero, acarreo, overflow;
		logic [N-1:0] y, sum;
		logic cin, cout;
		
		
/*	Tabla de funciones de la parte aritemtica de la alu del PPT 
	|seleccion 	 |   entrada   | F=	A	+	Y	+	CIN   |
	|S1		S0	 |      y	  	| 	cin=0		cin=1  	   |
	|0		0	 	 | solo ceros	|	 F=A		F=A+1  	   |		Falsas
	|0		1	 	 |		  B	  	|	F=A+B		F=A+B+1	   |		Falsas
	|1		0	 	 |		 ~B	  	| F= A+ ~B	F= A + ~B+1 |		Verdaderas
	|1		1	 	 |	 solo unos	|	F=A-1		F=A		   |		Verdaderas
*/
		// Asignaciones
		assign cin = ALUControl[0];
		// y es formas de B
		// [1][2] son los que seleccionan que operaciones se hacen, sindo los S1 y S0
		//	[0] define la parte logica o aritmetica
		assign y = ALUControl[2] ? (ALUControl[1] ? {N{1'b1}}//Verdadera,  11
												: ~b)//Verdadera, 		 10
								: (ALUControl[1] ?  b//Falsa, 				 01
												: {N{1'b0}});//Falsa, 	 00
		// produce el acarreo si hay
		assign {cout, sum}=a+y+cin;
		
		
		always_comb
			casez(ALUControl[3:1])
				3'b0?? : Result = sum;// 		part aritmetica
				3'b100 : Result = a & b;// 	part logica
				3'b101 : Result = a | b;// 	part logica
				3'b110 : Result= a ^ b;//		part logica
				3'b111 : Result= ~a;//  		part logica
			endcase
		//Asignacion de las flags(banderas)
		// en el ppt son z(zero) y s(neg)
		assign neg = Result[N-1];
		assign zero = ( Result == {N{1'b0}});
		
		// en el ppt son  v(overflow) y c(acarreo)
		assign acarreo = (ALUControl[3] == 1'b0) && cout;
		assign overflow = (ALUControl[3] == 1'b0) &&//Parte aritmetica, no importa v en logica
							   (~a[N-1] & ~y[N-1] &  sum[N-1] + // Suma de positivos
							     a[N-1] &  y[N-1] & ~sum[N-1]); // Suma de negativos
		//							 v    	s		z		c
		assign ALUFlags = {overflow, neg, zero, acarreo};
endmodule 

module Shifter2 #(parameter N=4)(
        input logic [N-1:0] F,
        input logic [N-2:0] H,
        input logic IL, IR,
        output logic [N-1:0] S);
	always_comb
	case(H)
		3'b000: S=F;
		3'b001: S=F<<1;
		3'b010: S=F>>1;
		3'b011: S={ N {1'b0}};
        3'b101: S={F[2:0], F[3]}; 
        3'b110: S={F[0],F[3:1]};
		default: S=F;
	endcase
endmodule

module ram3port #(parameter N = 2, M = 4)
                (input logic clk,
                input logic we3,
                input logic [N-1:0] a1, a2, a3,
                output logic [M-1:0] d1, d2,
                input logic [M-1:0] d3);

    logic [M-1:0] mem[2**N-1:0];

    always @(posedge clk)
        if (we3) mem[a3] <= d3;

    assign d1 = mem[a1];
    assign d2 = mem[a2];
endmodule
