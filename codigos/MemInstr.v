//1. definir modulo y sus I/O
module MemInstr(
	input [31:0]Dir,
	output [31:0]Instr
);

//2. componente interno: ROM de 64 palabras de 32 bits (indice = PC/4)
reg [31:0] srom [0:63];
integer i;

//3. cuerpo del modulo
assign Instr = srom[Dir[7:2]];

//precarga: programa de prueba del proyecto (el resto de la ROM queda en 0 = NOP)
//AUTOGENERADO por scripts/generar.py
initial
begin
	for (i=0; i<64; i=i+1)
		srom[i] = 32'd0;
	srom[0] = 32'h20080005; //0x00  addi $t0,$zero,5
	srom[1] = 32'h20090007; //0x04  addi $t1,$zero,7
	srom[2] = 32'h01095020; //0x08  add $t2,$t0,$t1
	srom[3] = 32'hac0a0010; //0x0C  sw $t2,16($zero)
	srom[4] = 32'h8c0b0010; //0x10  lw $t3,16($zero)
	srom[5] = 32'h8c110020; //0x14  lw $s1,32($zero)
	srom[6] = 32'h114b0001; //0x18  beq $t2,$t3,1
	srom[7] = 32'h200c0063; //0x1C  addi $t4,$zero,99
	srom[8] = 32'h0109682a; //0x20  slt $t5,$t0,$t1
	srom[9] = 32'h01097022; //0x24  sub $t6,$t0,$t1
	srom[10] = 32'h0800000c; //0x28  j 0x00000030
	srom[11] = 32'h200f0063; //0x2C  addi $t7,$zero,99
	srom[12] = 32'h01097825; //0x30  or $t7,$t0,$t1
	srom[13] = 32'h0800000d; //0x34  j 0x00000034
end

endmodule
