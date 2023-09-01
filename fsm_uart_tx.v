
module fsm_uart_tx #(parameter SEL_WIDTH = 2) (
	input 	wire 							CLK,
	input 	wire 							RST,
	input 	wire 							Data_Valid,
	input	wire 							ser_done,
	input   wire                  			parity_enable, 
	output  reg                   			Enable,
	output 	reg		[SEL_WIDTH - 1 : 0] 	mux_SEL,
	output 	reg 							Busy
	);

	// gray state encoding
	parameter   [2:0]      	IDLE   = 3'b000,
							start  = 3'b001,
							data   = 3'b011,
							parity = 3'b010,
							stop   = 3'b110 ;

	reg Busy_next;
	reg [2:0] current_state , next_state ;

	//register output and state transiton 
	always @ (posedge CLK or negedge RST)
		begin
			if(!RST)
				begin
					Busy <= 1'b0 ;

					current_state <= IDLE ;
				end
			else
				begin
					Busy <= Busy_next ;

					current_state <= next_state ;
				end
		end
	
		// output logic and next state logic
		always @ (*)
			begin
				Enable = 1'b0;
				mux_SEL = 'b00;	
				Busy_next = 1'b0;

				next_state = IDLE ; 

				case (current_state)
					IDLE   : begin
								Enable = 1'b0;
								mux_SEL = 'b11;	
								Busy_next = 1'b0;

								if (Data_Valid)
									next_state = start ;
								else
									next_state = IDLE; 			
							end
					start  : begin
								Enable = 1'b0;
								mux_SEL = 'b00;	
								Busy_next = 1'b1;

								next_state = data;  
							end
					data   : begin
								Enable = 1'b1;
								mux_SEL = 'b01;	
								Busy_next = 1'b1;
								
								if (ser_done)
									begin
										Enable = 1'b0;

										if (parity_enable)
											next_state = parity;
										else
											next_state = stop;			  
									end
								else
									begin
										Enable = 1'b1;

										next_state = data; 			
									end
							end
					parity : begin
								Enable = 1'b0; // you can remove it and depend on its iniitla value
								mux_SEL = 'b10;	
								Busy_next = 1'b1;
								
								next_state = stop ; 
							end
					stop   : begin
								Enable = 1'b0; // you can remove it and depend on its iniitla value
								mux_SEL = 'b11;	
								Busy_next = 1'b1;
								
								if (Data_Valid)
									next_state = start ;
								else
									next_state = IDLE ; 			
							end	
					default: begin
								Enable = 1'b0;
								mux_SEL = 'b00;	
								Busy_next = 1'b0;
								
								next_state = IDLE ; 
							end	
				endcase                 	   
			end 

endmodule
