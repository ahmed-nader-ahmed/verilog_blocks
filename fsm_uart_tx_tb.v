`timescale 1ns / 1ps

module fsm_uart_tx_tb #(parameter SEL_WIDTH_tb = 2) (
	);

	reg 							CLK_tb;
	reg 							RST_tb;
	reg 							Data_Valid_tb;
	reg 							ser_done_tb;
	reg 							parity_enable_tb;
	wire 							Enable_tb;
	wire 	[SEL_WIDTH_tb - 1 : 0] 	mux_SEL_tb;
	wire 							Busy_tb;
	
	localparam  CLK_PERIOD = 10;

	// -------INITIAL BLOCK--------
	initial
		begin
			// -------INITIALIZE--------
			INITIALIZE ();

			// -------RESET--------
			RESET();
			
			// -------TEST 1 => STILL IN IDLE--------
			state('b0, 'b1, 'b0, 'd1);
			
			// -------TEST 2 => STILL IN IDLE--------
			state('b0, 'b0, 'b1, 'd2);
			
			// -------TEST 3 => GO TO START--------
			state('b1, 'b1, 'b0, 'd3);
			
			// -------TEST 4 => GO TO DATA AUTOMATICALLY--------
			state('b0, 'b0, 'b1, 'd4);

			// // -------TEST 5 => GO TO PARITY--------
			// state('b0, 'b1, 'b1, 'd5);

			// // -------TEST 6 => GO TO STOP AUTOMATICALLY--------
			// state('b0, 'b0, 'b1, 'd6);

			// -------TEST 5 => GO TO STOP--------
			state('b0, 'b1, 'b0, 'd6);

			// // -------TEST 6 => GO TO IDLE--------
			// state('b0, 'b0, 'b1, 'd6);

			// -------TEST 6 => GO TO START--------
			state('b1, 'b0, 'b1, 'd6);
			
		end

	// -------TASKS--------
	task INITIALIZE (
		);
		begin
			RST_tb 				= 1'b1;
			Data_Valid_tb 		= 1'b0;
			ser_done_tb 		= 1'd0;
			parity_enable_tb 	= 1'b0;
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

	task state (
		input							Data_Valid_task,
		input							ser_done_task,
		input							parity_enable_task,
		input 		[15:0]				num
		);
		begin
			Data_Valid_tb 			= Data_Valid_task;
			ser_done_tb 			= ser_done_task;
			parity_enable_tb 		= parity_enable_task;
			@(negedge CLK_tb);
			$display("time = %0t,Data_Valid_tb = %1b, ser_done_tb = %1b, parity_enable_tb = %1b, num = %2d", $time, Data_Valid_tb, ser_done_tb, parity_enable_tb, num);
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
	fsm_uart_tx #(.SEL_WIDTH(SEL_WIDTH_tb)) DUT_fsm_uart_tx (
		.CLK(CLK_tb),
		.RST(RST_tb),
		.Data_Valid(Data_Valid_tb),
		.ser_done(ser_done_tb),
		.parity_enable(parity_enable_tb),
		.Enable(Enable_tb),
		.mux_SEL(mux_SEL_tb),
		.Busy(Busy_tb)
		);

endmodule



