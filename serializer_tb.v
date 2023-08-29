`timescale 1us / 1ns

module serializer_tb #(parameter WIDTH_tb = 8) (
	);

	reg 						CLK_tb;
	reg 						RST_tb;
	reg 		[WIDTH_tb - 1:0] 		DATA_tb;
	reg 						Enable_tb;
	reg 						Busy_tb;
	reg 						Data_Valid_tb;
	wire 						ser_out_tb;
	wire 						ser_done_tb;
	
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
			INPUT_REGISTERS_FETCH('d3, 1'b1, 1'b0, 1'b1, 'd2);

			// -------TEST 3--------
			INPUT_REGISTERS_FETCH('d7, 1'b0, 1'b0, 1'b1, 'd3);

			// -------SERIALIZER SEND THE DATA--------
			
			// -------TEST 4--------
			SERIALIZER_SEND('d5, 1'b1, 1'b1, 1'b0, 'd4);

		end

	// -------TASKS--------
	task INITIALIZE (
		);
		begin
			RST_tb 			= 1'b1;
			DATA_tb 		= 'd4;
			Enable_tb 		= 1'b0;
			Busy_tb 		= 1'b0;
			Data_Valid_tb 		= 1'b0;
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
		input 		[WIDTH_tb - 1:0] 		DATA_task,
		input						Enable_task,
		input						Busy_task,
		input						Data_Valid_task,
		input 		[WIDTH_tb - 1:0]		num
		);
		begin
			DATA_tb 	= DATA_task;
			Enable_tb 	= Enable_task;
			Busy_tb 	= Busy_task;
			Data_Valid_tb 	= Data_Valid_task;
			@(negedge CLK_tb);
			if (DUT_serializer.DATA_reg == DATA_tb)
				begin
					$display("TEST %2d PASSED @ time = ", num, , $time);
				end
			else
				begin
					$display("TEST %2d PASSED @ time = ", num, , $time);
				end
		end
	endtask

	task SERIALIZER_SEND (
		input 		[WIDTH_tb - 1:0] 		DATA_task,
		input						Enable_task,
		input						Busy_task,
		input						Data_Valid_task,
		input 		[WIDTH_tb - 1:0]		num
		);
		begin
			DATA_tb 	= DATA_task;
			Enable_tb 	= Enable_task;
			Busy_tb 	= Busy_task;
			Data_Valid_tb 	= Data_Valid_task;
			while (!ser_done_tb)  
				begin
					if (ser_out_tb == DATA_tb[0])
						begin
							$display("TEST %2d PASSED @ time = ", num, , $time);
						end
					else
						begin
							$display("TEST %2d PASSED @ time = ", num, , $time);
						end
					num = num + 1;
					// JUST TO CHECK IT WILL NOT TAKE NEW INPUT
					DATA_tb = num;
					@(negedge CLK_tb);
				end 
			Enable_tb = 1'b0;
		end
	endtask

	// -------CLK GENERATOR--------
	localparam  CLK_PERIOD = 5;
	always
		begin
			CLK_tb = 1'b0;
			#(CLK_PERIOD);
			CLK_tb = 1'b1;
			#(CLK_PERIOD);
		end

	// -------INSTANSIATION--------
	serializer #(.WIDTH(WIDTH_tb)) DUT_serializer (
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



