//1. definir modulo y sus I/O
module Registros(
	input clk,
	input RegWrite,
	input [4:0]RA1,
	input [4:0]RA2,
	input [4:0]WA,
	input [31:0]WD,
	output [31:0]RD1,
	output [31:0]RD2
);

//2. componente interno: 32 registros de 32 bits
reg [31:0] banco [0:31];
integer i;

//3. cuerpo del modulo
//lectura sin reloj; el registro 0 ($zero) siempre vale 0
assign RD1 = (RA1==0) ? 32'd0 : banco[RA1];
assign RD2 = (RA2==0) ? 32'd0 : banco[RA2];

//escritura en el flanco de subida; no se escribe en $zero
always @(posedge clk)
begin
	if (RegWrite && WA!=0)
		banco[WA] <= WD;
end

initial
begin
	for (i=0; i<32; i=i+1)
		banco[i] = 32'd0;
end

endmodule
