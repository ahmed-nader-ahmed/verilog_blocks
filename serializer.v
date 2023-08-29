
module serializer #(parameter WIDTH = 8) (
	input 	wire 					CLK,
	input 	wire 					RST,
	input 	wire 		[WIDTH - 1 : 0] 	DATA,
	input 	wire 					Enable,
	input 	wire 					Busy,
	input 	wire 					Data_Valid,
	output 	wire 					ser_out,
	output	wire 					ser_done
	);

	localparam MAX_VALUE_WIDTH = (2**$clog2(WIDTH) - 1);

	reg [$clog2(WIDTH) - 1 : 0] Q;
	reg [WIDTH - 1 : 0] DATA_reg;

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
			else if (Enable)
				begin
					DATA_reg <= (DATA_reg >> 1);
				end
		end

	// $clog2(WIDTH) bit counter
	always @ (negedge RST or posedge CLK)
		begin
			if (!RST)
				begin
					Q <= 'b0;
				end
			else if (Enable)
				begin
					Q <= Q + 1'b1;
				end
			else
				begin
					Q <= 'b0;
				end
		end

	assign ser_out = DATA_reg[0];
	assign ser_done = (Q == MAX_VALUE_WIDTH);

endmodule
