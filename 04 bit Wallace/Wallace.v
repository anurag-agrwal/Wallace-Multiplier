module Wallace (A, B, Mul);

input [3:0] A;
input [3:0] B;
output [7:0] Mul;

wire A0B0, A0B1, A0B2, A0B3, A1B0, A1B1, A1B2, A1B3, A2B0, A2B1, A2B2, A2B3, A3B0, A3B1, A3B2, A3B3;

wire Wt0_L1, Wt0_L2, Wt0_L3, Wt1_L2, Wt1_L3, Wt2_L3, Wt6_L1, Wt6_L2;
wire [1:0] Wt1_L1, Wt5_L1, Wt2_L2, Wt3_L3, Wt4_L3, Wt5_L3, Wt6_L3;
wire [2:0] Wt2_L1, Wt4_L1, Wt3_L2, Wt4_L2, Wt5_L2;
wire [3:0] Wt3_L1;

assign A0B0 = A[0] & B[0];
assign A0B1 = A[0] & B[1];
assign A0B2 = A[0] & B[2];
assign A0B3 = A[0] & B[3];

assign A1B0 = A[1] & B[0];
assign A1B1 = A[1] & B[1];
assign A1B2 = A[1] & B[2];
assign A1B3 = A[1] & B[3];

assign A2B0 = A[2] & B[0];
assign A2B1 = A[2] & B[1];
assign A2B2 = A[2] & B[2];
assign A2B3 = A[2] & B[3];

assign A3B0 = A[3] & B[0];
assign A3B1 = A[3] & B[1];
assign A3B2 = A[3] & B[2];
assign A3B3 = A[3] & B[3];


// Stage 1

assign Wt0_L1 = A0B0;

assign Wt1_L1 = {A1B0, A0B1};

assign Wt2_L1 = {A2B0, A1B1, A0B2};

assign Wt3_L1 = {A3B0, A2B1, A1B2, A0B3};

assign Wt4_L1 = {A3B1, A2B2, A1B3};

assign Wt5_L1 = {A3B2, A2B3};

assign Wt6_L1 = A3B3;


// Stage 2

assign Wt0_L2 = Wt0_L1;

HA H0 (Wt1_L1[0], Wt1_L1[1], Wt1_L2, Wt2_L2[0]);

FA F0 (Wt2_L1[0], Wt2_L1[1], Wt2_L1[2], Wt2_L2[1], Wt3_L2[0]);

FA F1 (Wt3_L1[0], Wt3_L1[1], Wt3_L1[2], Wt3_L2[1], Wt4_L2[0]);

assign Wt3_L2[2] = Wt3_L1[3];

HA H1 (Wt4_L1[0], Wt4_L1[1], Wt4_L2[1], Wt5_L2[0]);

assign Wt4_L2[2] = Wt4_L1[2];

assign Wt5_L2[2:1] = Wt5_L1[1:0];

assign Wt6_L2 = Wt6_L1;



// Stage 3

assign Wt0_L3 = Wt0_L2;
assign Wt1_L3 = Wt1_L2;

HA H2 (Wt2_L2[0], Wt2_L2[1], Wt2_L3, Wt3_L3[0]);

FA F3 (Wt3_L2[0], Wt3_L2[1], Wt3_L2[2], Wt3_L3[1], Wt4_L3[0]);

FA F4 (Wt4_L2[0], Wt4_L2[1], Wt4_L2[2], Wt4_L3[1], Wt5_L3[0]);

FA F5 (Wt5_L2[0], Wt5_L2[1], Wt5_L2[2], Wt5_L3[1], Wt6_L3[0]);

assign Wt6_L3[1] = Wt6_L2;



// 4-bit ripple carry adder for MSB bits

RCA RC0 ({Wt6_L3[0], Wt5_L3[0], Wt4_L3[0], Wt3_L3[0]}, {Wt6_L3[1], Wt5_L3[1], Wt4_L3[1], Wt3_L3[1]}, Mul[6:3], Mul[7]);

assign Mul[2] = Wt2_L3;
assign Mul[1] = Wt1_L3;
assign Mul[0] = Wt0_L3;

endmodule


module RCA (A, B, Sum, Cout);
input [3:0] A, B;
output Cout;
output [3:0] Sum;

wire [2:0] C;

HA H10 (A[0], B[0], Sum[0], C[0]);
FA F10 (A[1], B[1], C[0], Sum[1], C[1]);
FA F11 (A[2], B[2], C[1], Sum[2], C[2]);
FA F12 (A[3], B[3], C[2], Sum[3], Cout);

endmodule


module HA (A, B, Sum, Cout);
input A, B;
output Sum, Cout;

assign Sum = A ^ B;
assign Cout = A & B;

endmodule


module FA(A, B, Cin, Sum, Cout);
input A, B, Cin;
output Sum, Cout;

assign Sum = A ^ B ^ Cin;
assign Cout = ((A ^ B) & Cin) | (A & B);

endmodule
