module Serializer #(parameter IN_WIDTH = 8) (
	input 	wire 							CLK,
	input 	wire 							RST,
	input 	wire 	[IN_WIDTH - 1 : 0] 		DATA,
	input 	wire 							Enable,
	input 	wire 							Busy,
	input 	wire 							Data_Valid,
	output 	wire 							ser_out,
	output	wire 							ser_done
	);

	localparam MAX_VALUE_IN_WIDTH = (2**$clog2(IN_WIDTH) - 1);

	reg [$clog2(IN_WIDTH) - 1: 0] Q;
	reg [IN_WIDTH - 1 : 0] DATA_reg;
	//wire ser_done_next;

	// register the input
	always @ (negedge RST or posedge CLK)
		begin
			if (!RST)
				begin
					DATA_reg <= 'b0;
				end
			else if (Data_Valid && !Busy)
				begin
					DATA_reg <= DATA;
				end
			else if (Enable) // so enable signal is on for 8 cycles
				begin
					DATA_reg <= (DATA_reg >> 1);
				end
		end

	// $clog2(IN_WIDTH) bit counter
	// counter is needed for ser_done
	always @ (negedge RST or posedge CLK)
		begin
			if (!RST)
				begin
					Q <= 'b0;
				end
			else if (Enable) // so enable signal is on for 8 cycles
				begin
					Q <= Q + 1'b1;
				end
			else
				begin
					Q <= 'b0;
				end
		end

	// always @ (negedge RST or posedge CLK)
	// 	begin
	// 		if (!RST)
	// 			begin
	// 				ser_done <= 'b0;
	// 			end
	// 		else if (Enable) // so enable signal is on for 8 cycles
	// 			begin
	// 				ser_done <= ser_done_next;
	// 			end
	// 		else
	// 			begin
	// 				ser_done <= 'b0;
	// 			end
	// 	end

	assign ser_out = DATA_reg[0];
	assign ser_done = (Q == MAX_VALUE_IN_WIDTH);
	//assign ser_done_next = (DATA_reg == 'b0); // after 8 cycles // and get rid-off counter but deassert the enable after it to stop shifting // but the enable must be 0 in order to prevent DATA_reg <= (DATA_reg >> 1); @ this moment



	// serial_out appears 1 cycle before serial_done
	// enable signal should be asserted for 8 cycles => serializer will not send to fsm_uart_tx serial_done = 1 except after 8 cycles then fsm deassert the enable signal thats why we will make seriallizer to assert the serial_done in the beginning of 7th cycle so fsm read it in the beginning of 8th cycle so serializer in the beginning of 8th cycle will shift the last bit and then fsm deassert the enable signal in the beginning of 8th cycle and then serializer reades it in the beginning of 9th cycle so stop shifting
endmodule
