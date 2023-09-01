
module UART_TX #(parameter IN_WIDTH = 8, SEL_WIDTH = 2) (
	input   wire                  				CLK,
	input   wire                  				RST,
	input   wire     [IN_WIDTH - 1 : 0]        	P_DATA,
	input   wire                  				Data_Valid,
	input   wire                  				parity_enable,
	input   wire                  				parity_type, 
	output  wire                  				TX_OUT,
	output  wire                  				busy
	);

wire          seriz_en    , 
              seriz_done  ,
		 	  ser_data    ,
		 	  parity      ;		
wire  [SEL_WIDTH - 1 : 0]   mux_sel ;
 
fsm_uart_tx  U0_fsm (
	.CLK(CLK),
	.RST(RST),
	.Data_Valid(Data_Valid), 
	.ser_done(seriz_done), 
	.parity_enable(parity_enable),
	.Enable(seriz_en),
	.mux_SEL(mux_sel), 
	.Busy(busy)
);

Serializer U0_Serializer (
	.CLK(CLK),
	.RST(RST),
	.DATA(P_DATA),
	.Enable(seriz_en), 
	.Busy(busy),
	.Data_Valid(Data_Valid), 
	.ser_out(ser_data),
	.ser_done(seriz_done)
);

mux U0_mux (
	.CLK(CLK),
	.RST(RST),
	.mux_IN({1'b1, parity, ser_data, 1'b0}),
	.mux_SEL(mux_sel),
	.mux_OUT(TX_OUT) 
);

parity_calc U0_parity_calc (
	.CLK(CLK),
	.RST(RST),
	.DATA(P_DATA),
	.Data_Valid(Data_Valid), 
	.parity_enable(parity_enable),
	.parity_type(parity_type),
	.parity(parity)
); 



endmodule
 