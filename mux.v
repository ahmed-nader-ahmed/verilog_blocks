module mux #(parameter SEL_WIDTH = 2) (
	input   wire 								CLK,
 	input   wire 								RST,
	input 	wire	[2**SEL_WIDTH - 1 : 0] 		mux_IN,
	input 	wire	[SEL_WIDTH - 1 : 0] 		mux_SEL,
	output 	reg									mux_OUT
	);

	wire [SEL_WIDTH - 1 : 0] mux_OUT_next;

	assign mux_OUT_next = mux_IN[mux_SEL];
	/*
	always @ (*)
		begin
			case (mux_SEL)
				'd0 : 	begin
							mux_OUT_next = mux_IN[0];
						end
				'd1 : 	begin
							mux_OUT_next = mux_IN[1];
						end
				'd2 : 	begin
							mux_OUT_next = mux_IN[2];
						end
				'd3 : 	begin
							mux_OUT_next = mux_IN[3];
						end
				default : 	begin
							mux_OUT_next = 1'b0	;
						end
			endcase
		end
	*/
	
	//register mux output
	always @ (negedge RST or posedge CLK)
		begin
			if (!RST)
				begin
					mux_OUT <= 'b0 ;
				end
			else
				begin
					mux_OUT <= mux_OUT_next ;
				end 
		end 

endmodule
