/*
 * motor position below assumed
 * 				1
 * 			4		2
 * 				3
 */
module step_motor_control
	(
		input clk,rst,en,cw,
		output reg [3:0]signal
	);
/*
 * clk - clock
 * rst - reset
 * en - enable
 * cw - clockwise if high then clockwise else anti clockwise
 */
	
localparam s_Idle = 3'b000;
localparam s_1    = 3'b001;
localparam s_2    = 3'b010;
localparam s_3    = 3'b011;
localparam s_4    = 3'b100;

reg [2:0]present_state, next_state;


//to enable the state change
always @(posedge clk, posedge rst)
	begin
		if(rst==0)   //when the rst is high the system goes to idle state.
			begin
				present_state = next_state;
			end
		else
			begin
				present_state = s_Idle;
			end
end

//changes states with mealy state machine
always @(present_state,cw,en)
	begin
		case(present_state)
			s_Idle:
			begin
				next_state = en?s_1:s_Idle;
			end
			s_1:
			begin
				next_state = en?(cw?s_2:s_4):s_Idle;
			end
			s_2:
			begin
				next_state = en?(cw?s_3:s_1):s_Idle;
			end
			s_3:
			begin
				next_state = en?(cw?s_4:s_2):s_Idle;
			end
			s_4:
			begin
				next_state = en?(cw?s_1:s_3):s_Idle;
			end
			default:
			begin
				next_state = s_Idle;
			end	
		endcase
	end
	
	
//for the signal to send
always@(posedge clk)
	begin
		case(present_state)
			s_1:
			begin
				signal = 4'b0001;
			end
			s_2:
			begin
				signal = 4'b0010;
			end
			s_3:
			begin
				signal = 4'b0100;
			end
			s_4:
			begin
				signal = 4'b1000;
			end
			default:
			begin
				signal = 4'b0000;
			end
		endcase
			
	end
	
endmodule