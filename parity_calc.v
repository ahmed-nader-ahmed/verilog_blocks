module parity_calc #(parameter IN_WIDTH = 8) (
	input 	wire 							CLK,
	input 	wire 							RST,
	input 	wire 	[IN_WIDTH - 1 : 0] 		DATA,
	input 	wire 							Data_Valid,
	input   wire 							parity_enable,
 	input   wire 							parity_type,
 	output  reg                   			parity 
	);

	reg parity_next;
	reg [IN_WIDTH - 1 : 0] DATA_reg;

	// register the input
	always @ (negedge RST or posedge CLK)
		begin
			if (!RST)
				begin
					DATA_reg <= 'b0;
				end
			else if (Data_Valid)
				begin
					DATA_reg <= DATA;
				end
		end

	// output
	always @ (negedge RST or posedge CLK)
		begin
			if (!RST)
				begin
					parity <= 'b0;
				end
			else
				begin
					parity <= parity_next;
				end
		end

	always @ (*)
		begin
			if (parity_enable)
				begin
					case (parity_type)
						1'b0 : begin                 
								parity_next = ^DATA_reg;     // Even Parity
							end
						1'b1 : begin
								parity_next = ~^DATA_reg;     // Odd Parity
							end		
              		endcase 
				end
			else
				begin
					parity_next = parity;
				end
		end

endmodule

