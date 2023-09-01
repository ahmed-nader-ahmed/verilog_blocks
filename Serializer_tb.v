`timescale 1ns / 1ps

module Serializer_tb #(parameter IN_WIDTH_tb = 8) (
	);

	reg 							CLK_tb;
	reg 							RST_tb;
	reg 	[IN_WIDTH_tb - 1:0] 	DATA_tb;
	reg 							Enable_tb;
	reg 							Busy_tb;
	reg 							Data_Valid_tb;
	wire 							ser_out_tb;
	wire 							ser_done_tb;
	
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
			INPUT_REGISTERS_FETCH('d5, 1'b0, 1'b0, 1'b1, 'd1);

			// -------TEST 2--------
			INPUT_REGISTERS_FETCH('b10, 1'b1, 1'b0, 1'b1, 'd2);

			// -------TEST 3--------
			INPUT_REGISTERS_FETCH('b1111_1111, 1'b0, 1'b0, 1'b1, 'd3);

			// -------SERIALIZER SEND THE DATA--------
			
			// -------TEST 4--------
			SERIALIZER_SEND('d5, 1'b1, 1'b1, 1'b0, 'd4);

			// -------INPUT REGISTERS FETCH THE DATA--------
			
			// -------TEST 13--------
			INPUT_REGISTERS_FETCH('d5, 1'b0, 1'b0, 1'b1, 'd13);

			/*
			// -------TEST 5--------
			SERIALIZER_SEND('d3, 1'b1, 1'b1, 1'b0, 'd5);

			// -------TEST 6--------
			SERIALIZER_SEND('d7, 1'b1, 1'b1, 1'b0, 'd6);*/

			

		end

	// -------TASKS--------
	task INITIALIZE (
		);
		begin
			RST_tb 			= 1'b1;
			DATA_tb 		= 'd4;
			Enable_tb 		= 1'b0;
			Busy_tb 		= 1'b0;
			Data_Valid_tb 	= 1'b0;
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
		input							Enable_task,
		input							Busy_task,
		input							Data_Valid_task,
		input 	[15:0]					num
		);
		begin
			DATA_tb 		= DATA_task;
			Enable_tb 		= Enable_task;
			Busy_tb 		= Busy_task;
			Data_Valid_tb 	= Data_Valid_task;
			@(negedge CLK_tb);
			if (DUT_Serializer.DATA_reg == DATA_tb)
				begin
					$display("TEST %2d PASSED @ time = ", num, , $time);
				end
			else
				begin
					$display("TEST %2d FAILED @ time = ", num, , $time);
				end
		end
	endtask

	task SERIALIZER_SEND (
		input 	[IN_WIDTH_tb - 1:0] 	DATA_task,
		input							Enable_task,
		input							Busy_task,
		input							Data_Valid_task,
		input 	[15:0]					num
		);
		begin
			DATA_tb 		= DATA_task;
			Enable_tb 		= Enable_task;
			Busy_tb 		= Busy_task;
			Data_Valid_tb 	= Data_Valid_task;
			while (!ser_done_tb)  
				begin
					@(negedge CLK_tb);
					if (ser_out_tb == DUT_Serializer.DATA_reg[0])
						begin
							$display("TEST %2d PASSED @ time = ", num, , $time);
						end
					else
						begin
							$display("TEST %2d FAILED @ time = ", num, , $time);
						end
					num = num + 1;
					// JUST TO CHECK IT WILL NOT TAKE NEW INPUT
					DATA_tb = num;
				end 
			Enable_tb = 1'b0;
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
	Serializer #(.IN_WIDTH(IN_WIDTH_tb)) DUT_Serializer (
		.CLK(CLK_tb),
		.RST(RST_tb),
		.DATA(DATA_tb),
		.Enable(Enable_tb),
		.Busy(Busy_tb),
		.Data_Valid(Data_Valid_tb),
		.ser_out(ser_out_tb),
		.ser_done(ser_done_tb)
		);

endmodule



