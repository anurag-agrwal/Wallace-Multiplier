module Wallace (A, B, Mul);

parameter N=8;

input [N-1:0] A;
input [N-1:0] B;
output [2*N-1:0] Mul;
wire Cout;

reg p [N-1:0][N-1:0];

wire w01, w02, w03, w04, w05, w141, w12, w142, w13, w23, w14, w24, w34, w15, w25, w35, w45, w155;
wire [1:0] w11, w131, w22, w132, w33, w43, w133, w143, w44, w54, w64, w144, w55, w65, w75, w85, w95, w105, w115, w125, w135, w145;
wire [2:0] w21, w121, w32, w42, w53, w63, w113, w123, w74, w84, w94, w104, w114, w124, w134;
wire [3:0] w31, w111, w52, w102, w112, w122, w73, w83, w93, w103;
wire [4:0] w41, w101, w62;
wire [5:0] w51, w91 , w72, w82, w92;
wire [6:0] w61, w81;
wire [7:0] w71;


// Initialize all the partial products
integer i,j;

always @(*)
begin

	for(i=0;i<N;i=i+1)
	begin
	
		for(j=0;j<N;j=j+1)
		begin
		
			p[i][j] = A[i] & B[j];
			
		end
	end
end



/*
					Stage 1

															a7 a6 a5 a4 a3 a2 a1 a0
														x	b7 b6 b5 b4 b3 b2 b1 b0
														------------------------------------------------------------------------------------
														a7b0 a6b0 a5b0 a4b0 a3b0 a2b0 a1b0 a0b0
												   a7b1 a6b1 a5b1 a4b1 a3b1 a2b1 a1b1 a0b1
											  a7b2 a6b2 a5b2 a4b2 a3b2 a2b2 a1b2 a0b2
							----------------------------------------------------------------------------------------------------------------
									     a7b3 a6b3 a5b3 a4b3 a3b3 a2b3 a1b3 a0b3
								    a7b4 a6b4 a5b4 a4b4 a3b4 a2b4 a1b4 a0b4
							   a7b5 a6b5 a5b5 a4b5 a3b5 a2b5 a1b5 a0b5
				----------------------------------------------------------------------------------------------------------------------------
						  a7b6 a6b6 a5b6 a4b6 a3b6 a2b6 a1b6 a0b6
				     a7b7 a6b7 a5b7 a4b7 a3b7 a2b7 a1b7 a0b7

---------------------------------------------------------------------------------------------------------------------------------------------
			
			
			Stage 2

														w92[0] w82[0] w72[0] w62[0] w52[0] w42[0] w32[0] w22[0] w12 w02		[weight-bit] [stage]
														w92[1] w82[1] w72[1] w62[1] w52[1] w42[1] w32[1] w22[1]
								w122[0] w112[0] w102[0] w92[2] w82[2] w72[2] w62[2] w52[2] w42[2] w32[2]
				----------------------------------------------------------------------------------------------------------------------------								
								w122[1] w112[1] w102[1] w92[3] w82[3] w72[3] w62[3] w52[3]
						w132[0] w122[2] w112[2] w102[2] w92[4] w82[4] w72[4] w62[4]
				w142[0] w132[1] w122[3] w112[3] w102[3] w92[5] w82[5] w72[5]

---------------------------------------------------------------------------------------------------------------------------------------------								
								
								
								
*/



// Stage 1			// [Weight-bit] [Stage]

assign w01 = p[0][0];
assign w02 = w01;

HA H1 (p[1][0], p[0][1], w12, w22[0]);

FA F1 (p[2][0], p[1][1], p[0][2], w22[1], w32[0]);

FA F2 (p[3][0], p[2][1], p[1][2], w32[1], w42[0]);
assign w32[2]  = p[0][3];

FA F3 (p[4][0], p[3][1], p[2][2], w42[1], w52[0]);
HA H2 (p[1][3], p[0][4], w42[2], w52[1]);


FA F4 (p[5][0], p[4][1], p[3][2], w52[2], w62[0]);
FA F5 (p[2][3], p[1][4], p[0][5], w52[3], w62[1]);

FA F6 (p[6][0], p[5][1], p[4][2], w62[2], w72[0]);
FA F7 (p[3][3], p[2][4], p[1][5], w62[3], w72[1]);
assign w62[4]  = p[0][6];

FA F8 (p[7][0], p[6][1], p[5][2], w72[2], w82[0]);
FA F9 (p[4][3], p[3][4], p[2][5], w72[3], w82[1]);
assign w72[4]  = p[1][6];
assign w72[5]  = p[0][7];

HA H3  (p[7][1], p[6][2], w82[2], w92[0]);
FA F10 (p[5][3], p[4][4], p[3][5], w82[3], w92[1]);
assign w82[4]  = p[2][6];
assign w82[5]  = p[1][7];

assign w92[2]  = p[7][2];
FA F11 (p[6][3], p[5][4], p[4][5], w92[3], w102[0]);
assign w92[4]  = p[3][6];
assign w92[5]  = p[2][7];

FA F12 (p[7][3], p[6][4], p[5][5], w102[1], w112[0]);
assign w102[2]  = p[4][6];
assign w102[3]  = p[3][7];

HA H4 (p[7][4], p[6][5], w112[1], w122[0]);
assign w112[2]  = p[5][6];
assign w112[3]  = p[4][7];

assign w122[1]  = p[7][5];
assign w122[2]  = p[6][6];
assign w122[3]  = p[5][7];

assign w132[0]  = p[7][6];
assign w132[1]  = p[6][7];

assign w142  = p[7][7];





// Stage 2			// [Weight-bit] [Stage]

assign w03 = w02;
assign w13 = w12;

HA H5 (w22[0], w22[1], w23, w33[0]);

FA F15 (w32[0], w32[1], w32[2], w33[1], w43[0]);

FA F16 (w42[0], w42[1], w42[2], w43[1], w53[0]);

FA F17 (w52[0], w52[1], w52[2], w53[1], w63[0]);
assign w53[2] = w52[3];

FA F18 (w62[0], w62[1], w62[2], w63[1], w73[0]);
HA H6  (w62[3], w62[4], w63[2], w73[1]);

FA F19 (w72[0], w72[1], w72[2], w73[2], w83[0]);
FA F20 (w72[3], w72[4], w72[5], w73[3], w83[1]);

FA F21 (w82[0], w82[1], w82[2], w83[2], w93[0]);
FA F22 (w82[3], w82[4], w82[5], w83[3], w93[1]);

FA F23 (w92[0], w92[1], w92[2], w93[2], w103[0]);
FA F24 (w92[3], w92[4], w92[5], w93[3], w103[1]);

assign w103[2] = w102[0];
FA F25 (w102[1], w102[2], w102[3], w103[3], w113[0]);

assign w113[1] = w112[0];
FA F26 (w112[1], w112[2], w112[3], w113[2], w123[0]);

assign w123[1] = w122[0];
FA F40 (w122[1], w122[2], w122[3], w123[2], w133[0]);

HA H7  (w132[0], w132[1], w133[1], w143[0]);

assign w143[1] = w142;






// Stage 3			// [Weight-bit] [Stage]

assign w04 = w03;
assign w14 = w13;
assign w24 = w23;

HA H8 (w33[0], w33[1], w34   , w44[0]);
HA H9 (w43[0], w43[1], w44[1], w54[0]);

FA F27 (w53[0], w53[1], w53[2], w54[1], w64[0]);
FA F28 (w63[0], w63[1], w63[2], w64[1], w74[0]);

FA F29 (w73[0], w73[1], w73[2], w74[1], w84[0]);
assign w74[2] = w73[3];

FA F30 (w83[0], w83[1], w83[2], w84[1], w94[0]);
assign w84[2] = w83[3];

FA F31 (w93[0], w93[1], w93[2], w94[1], w104[0]);
assign w94[2] = w93[3];

FA F32 (w103[0], w103[1], w103[2], w104[1], w114[0]);
assign w104[2] = w103[3];

HA H10 (w113[0], w113[1], w114[1], w124[0]);
assign w114[2] = w113[2];

HA H11 (w123[0], w123[1], w124[1], w134[0]);
assign w124[2] = w123[2];

assign w134[1] = w133[0];
assign w134[2] = w133[1];

assign w144[0] = w143[0];
assign w144[1] = w143[1];





// Stage 4			// [Weight-bit] [Stage]

assign w05 = w04;
assign w15 = w14;
assign w25 = w24;
assign w35 = w34;

HA H12 (w44[0], w44[1], w45, w55[0]);
HA H13 (w54[0], w54[1], w55[1], w65[0]);
HA H14 (w64[0], w64[1], w65[1], w75[0]);

FA F33 (w74[0], w74[1], w74[2], w75[1], w85[0]);
FA F34 (w84[0], w84[1], w84[2], w85[1], w95[0]);
FA F35 (w94[0], w94[1], w94[2], w95[1], w105[0]);
FA F36 (w104[0], w104[1], w104[2], w105[1], w115[0]);
FA F37 (w114[0], w114[1], w114[2], w115[1], w125[0]);
FA F38 (w124[0], w124[1], w124[2], w125[1], w135[0]);
FA F39 (w134[0], w134[1], w134[2], w135[1], w145[0]);

HA H15 (w144[0], w144[1], w145[1], w155);
//HA H15 (w144[0], w144[1], w145[1], w155); 	Used to ckeck validity by making an error


// 11-bit ripple carry adder for MSB bits

RCA RC0 ({w155, w145[0], w135[0], w125[0], w115[0], w105[0], w95[0], w85[0], w75[0], w65[0], w55[0]}, {1'b0, w145[1], w135[1], w125[1], w115[1], w105[1], w95[1], w85[1], w75[1], w65[1], w55[1]}, Mul[15:5], Cout);

assign Mul[4] = w45;
assign Mul[3] = w35;
assign Mul[2] = w25;
assign Mul[1] = w15;
assign Mul[0] = w05;

endmodule


module RCA (A, B, Sum, Cout);
input [10:0] A, B;
output Cout;
output [10:0] Sum;

wire [9:0] C;

HA H60 (A[0], B[0], Sum[0], C[0]);
FA F60 (A[1], B[1], C[0], Sum[1], C[1]);
FA F61 (A[2], B[2], C[1], Sum[2], C[2]);
FA F62 (A[3], B[3], C[2], Sum[3], C[3]);
FA F63 (A[4], B[4], C[3], Sum[4], C[4]);
FA F64 (A[5], B[5], C[4], Sum[5], C[5]);
FA F65 (A[6], B[6], C[5], Sum[6], C[6]);
FA F66 (A[7], B[7], C[6], Sum[7], C[7]);
FA F67 (A[8], B[8], C[7], Sum[8], C[8]);
FA F68 (A[9], B[9], C[8], Sum[9], C[9]);

FA F69 (A[10], B[10], C[9], Sum[10], Cout);

endmodule


// Half_Adder

module HA (A, B, Sum, Cout);
input A, B;
output Sum, Cout;

assign Sum = A ^ B;
assign Cout = A & B;

endmodule


// Full_Adder

module FA(A, B, Cin, Sum, Cout);
input A, B, Cin;
output Sum, Cout;

assign Sum = A ^ B ^ Cin;
assign Cout = ((A ^ B) & Cin) | (A & B);

endmodule
