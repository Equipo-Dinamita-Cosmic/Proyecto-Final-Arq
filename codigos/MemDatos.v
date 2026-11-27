//1. definir modulo y sus I/O
module MemDatos(
	input clk,
	input MemRead,
	input MemWrite,
	input [31:0]Dir,
	input [31:0]WD,
	output [31:0]RD
);

//2. componente interno: 64 palabras de 32 bits (indice = Dir/4)
reg [31:0] sram [0:63];
integer i;

//3. cuerpo del modulo
assign RD = MemRead ? sram[Dir[7:2]] : 32'd0;

always @(posedge clk)
begin
	if (MemWrite)
		sram[Dir[7:2]] <= WD;
end

//precarga: todo en 0 y la palabra 8 (direccion 0x20) vale 0x2A (la usa el programa de prueba)
initial
begin
	for (i=0; i<64; i=i+1)
		sram[i] = 32'd0;
	sram[8] = 32'h0000002A;
end

endmodule
