`timescale 1ns / 1ps

module parity_calc_tb #(parameter IN_WIDTH_tb = 8) (
	);

	reg 							CLK_tb;
	reg 							RST_tb;
	reg 	[IN_WIDTH_tb - 1:0] 	DATA_tb;
	reg 							Data_Valid_tb;
	reg 							parity_enable_tb;
	reg 							parity_type_tb;
	wire 							parity_tb;
	
	localparam  CLK_PERIOD = 10; // half clk period

	reg [IN_WIDTH_tb - 1:0] DATA_to_test, reg_DATA_at_pos_edge;

	// -------INITIAL BLOCK--------
	initial
		begin
			// -------INITIALIZE--------
			INITIALIZE ();

			// -------RESET--------
			RESET();

			// -------INPUT REGISTERS FETCH THE DATA--------
			
			// -------TEST 1--------
			INPUT_REGISTERS_FETCH('d5, 1'b1, 1'b1, 1'b1, 'd1);

			// -------TEST 2--------
			INPUT_REGISTERS_FETCH('d3, 1'b0, 1'b1, 1'b0, 'd2);

			// -------TEST 3--------
			INPUT_REGISTERS_FETCH('d7, 1'b1, 1'b1, 1'b1, 'd3);

			// -------PARITY--------
			
			// -------TEST 4 => NO PARITY--------
			PAR_MODE('d5, 1'b1, 1'b1, 1'b0, 'd4);
			
			// -------TEST 4 => NO PARITY--------
			PAR_MODE('d6, 1'b0, 1'b0, 1'b1, 'd5);
			
			// -------TEST 5 => EVEN PARITY--------
			PAR_MODE('d7, 1'b1, 1'b1, 1'b0, 'd6);
			
			// -------TEST 6 => ODD PARITY--------
			PAR_MODE('d1, 1'b0, 1'b1, 1'b1, 'd7);
			

		end

	// -------TASKS--------
	task INITIALIZE (
		);
		begin
			RST_tb 				= 1'b1;
			DATA_tb 			= 'd4;
			Data_Valid_tb 		= 1'b0;
			parity_enable_tb 	= 1'b0;
			parity_type_tb 		= 1'b0;
			repeat(3) @(negedge CLK_tb);
		end
	endtask

	task RESET (
		);
		begin
			RST_tb = 1'b0;
			@(negedge CLK_tb);
			RST_tb = 1'b1;
		end
	endtask

	task INPUT_REGISTERS_FETCH (
		input 	[IN_WIDTH_tb - 1:0] 	DATA_task,
		input							Data_Valid_task,
		input							parity_enable_task,
		input							parity_type_task,
		input 	[15:0]					num
		);
		begin
			DATA_tb 			= DATA_task;
			Data_Valid_tb 		= Data_Valid_task;
			parity_enable_tb 	= parity_enable_task;
			parity_type_tb 		= parity_type_task;
			@(negedge CLK_tb);
			if (DUT_parity_calc.DATA_reg == DATA_tb)
				begin
					$display("TEST %2d PASSED @ time = ", num, , $time);
				end
			else
				begin
					$display("TEST %2d FAILED @ time = ", num, , $time);
				end
		end
	endtask

	task PAR_MODE (
		input 	[IN_WIDTH_tb - 1:0] 	DATA_task,
		input							Data_Valid_task,
		input							parity_enable_task,
		input							parity_type_task,
		input 	[15:0]					num
		);
		begin
			DATA_tb 			= DATA_task;
			Data_Valid_tb 		= Data_Valid_task;
			parity_enable_tb 	= parity_enable_task;
			parity_type_tb 		= parity_type_task;
			@(negedge CLK_tb);
			if (Data_Valid_tb)
				DATA_to_test = reg_DATA_at_pos_edge;
			else
				DATA_to_test = DUT_parity_calc.DATA_reg;

			case (parity_enable_tb)
				1'b0 : begin
						if (parity_tb == DUT_parity_calc.parity)
							$display("TEST %2d PASSED @ time = ", num, , $time); 
						else
							$display("TEST %2d FAILED @ time = ", num, , $time);
					end
				1'b1 : begin
						if (parity_type_tb)
							if (parity_tb == ~^DATA_to_test)
								$display("TEST %2d PASSED @ time = ", num, , $time); 
							else
								$display("TEST %2d FAILED @ time = ", num, , $time);
						else
							if (parity_tb == ^DATA_to_test)
								$display("TEST %2d PASSED @ time = ", num, , $time); 
							else
								$display("TEST %2d FAILED @ time = ", num, , $time);
					end		
			endcase
		end
	endtask

	always
		begin
			reg_DATA_at_pos_edge = DUT_parity_calc.DATA_reg;
			@(posedge CLK_tb - 1);
		end

	// -------CLK GENERATOR--------
	always
		begin
			CLK_tb = 1'b0;
			#(CLK_PERIOD / 2);
			CLK_tb = 1'b1;
			#(CLK_PERIOD / 2);
		end

	// -------INSTANSIATION--------
	parity_calc #(.IN_WIDTH(IN_WIDTH_tb)) DUT_parity_calc (
		.CLK(CLK_tb),
		.RST(RST_tb),
		.DATA(DATA_tb),
		.Data_Valid(Data_Valid_tb),
		.parity_enable(parity_enable_tb),
		.parity_type(parity_type_tb),
		.parity(parity_tb)
		);

endmodule



