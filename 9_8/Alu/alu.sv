//		La condicion para la utilizacion de la siguiente aplicacion de Alu, es que sean ambos numeros de igual signo
module alu#(parameter N=4)
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
							   (~a[N-1] & ~y[N-1] &  sum[N-1] | // Suma de positivos
							     a[N-1] &  y[N-1] & ~sum[N-1]); // Suma de negativos
		//							 v    	s		z		c
		assign ALUFlags = {overflow, neg, zero, acarreo};
endmodule 
