//1. definir modulo y sus I/O
module Extensor(
	input [15:0]Inm,
	input ExtCero,
	output [31:0]Ext
);

//3. cuerpo del modulo
//ExtCero=1 (andi, ori): rellena con ceros. ExtCero=0: extiende el signo (bit 15)
assign Ext = ExtCero ? {16'd0, Inm} : {{16{Inm[15]}}, Inm};

endmodule
