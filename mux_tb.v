`timescale 1ns / 1ps

module mux_tb #(parameter SEL_WIDTH_tb = 2) (
	);

	reg 									CLK_tb;
 	reg 									RST_tb;
	reg		[2**SEL_WIDTH_tb - 1 : 0] 		mux_IN_tb;
	reg		[SEL_WIDTH_tb - 1 : 0] 			mux_SEL_tb;
	wire									mux_OUT_tb;
	
	localparam  CLK_PERIOD = 10;

	// -------INITIAL BLOCK--------
	initial
		begin
			// -------INITIALIZE--------
			INITIALIZE ();

			// -------RESET--------
			RESET();

			// -------INPUT REGISTERS FETCH THE DATA--------
			
			// -------TEST 1--------
			IN_TO_OUT('b1010, 'd0, 'd1);

			// -------TEST 2--------
			IN_TO_OUT('b1111, 'd0, 'd2);

			// -------TEST 3--------
			IN_TO_OUT('b0110, 'd1, 'd3);

			// -------TEST 4--------
			IN_TO_OUT('b0101, 'd1, 'd4);
			
			// -------TEST 5--------
			IN_TO_OUT('b1010, 'd2, 'd5);

			// -------TEST 6--------
			IN_TO_OUT('b1110, 'd2, 'd6);

			// -------TEST 7--------
			IN_TO_OUT('b0110, 'd3, 'd7);

			// -------TEST 8--------
			IN_TO_OUT('b1101, 'd3, 'd8);
		end

	// -------TASKS--------
	task INITIALIZE (
		);
		begin
			RST_tb 			= 1'b1;
			mux_IN_tb 		= 'b1111;
			mux_SEL_tb 		= 'b0;
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

	task IN_TO_OUT (
		input 	[2**SEL_WIDTH_tb - 1 : 0] 		mux_IN_task,
		input 	[SEL_WIDTH_tb - 1 : 0]				mux_SEL_task,
		input 	[15:0]							num
		);
		begin
			mux_IN_tb 		= mux_IN_task;
			mux_SEL_tb 		= mux_SEL_task;
			@(negedge CLK_tb);
			if (mux_OUT_tb == mux_IN_tb[mux_SEL_tb])
				begin
					$display("TEST %2d PASSED @ time = ", num, , $time);
				end
			else
				begin
					$display("TEST %2d FAILED @ time = ", num, , $time);
				end
		end
	endtask

	// -------CLK GENERATOR--------
	always
		begin
			CLK_tb = 1'b0;
			#(CLK_PERIOD / 2);
			CLK_tb = 1'b1;
			#(CLK_PERIOD / 2);
		end

	// -------INSTANSIATION--------
	mux DUT_mux (
		.CLK(CLK_tb),
		.RST(RST_tb),
		.mux_IN(mux_IN_tb),
		.mux_SEL(mux_SEL_tb),
		.mux_OUT(mux_OUT_tb)
		);

endmodule



