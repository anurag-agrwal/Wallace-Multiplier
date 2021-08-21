`timescale 1ns/1ps
module testbench();

parameter N = 4;

reg [N-1:0] A, B;
wire [2*N-1:0] Mul;

Wallace dut_instance (A, B, Mul);

integer i;

initial begin

	for (i=0; i<2**(2*N); i=i+1)
		begin
			{B,A} = i;
			#10;
			if(Mul !== A*B)
				begin
					$display("Error: Wrong Multiplication");
					$stop;
					
				end		
		end
end

endmodule
