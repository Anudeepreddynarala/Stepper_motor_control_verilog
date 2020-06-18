`timescale 1ns/10ps
`include "step_motor_control.v"

module stepper_tb();
	
	reg clk=0,rst,en,cw=1;
	
	wire [3:0]signal;
	always
		begin
			#5; 
			clk = ~clk; //100MHz frequency clock 1
		end
		
	step_motor_control UUT (clk,rst,en,cw,signal);
	
	initial begin
	rst = 1;
	#20;
	rst = 0;
	en = 1;
	#150;
	en=0;
	end
	
endmodule