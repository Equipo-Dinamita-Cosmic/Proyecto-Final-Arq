//1. definir modulo y sus I/O (datapath monociclo MIPS de 32 bits)
module MIPS(
	input clk
);

//2. definir componentes internos
reg [31:0]PC;
wire [31:0]Instr,PCmas4,PCbeq,PCsig,RD1,RD2,Ext,ALUB,ALUOut,DatoMem,DatoReg;
wire [4:0]RegDest;
wire Zero;
wire RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,ExtCero;
wire [2:0]ALUOp;
wire [3:0]ALUctl;

//3. cuerpo del modulo
//3.1 instancias
MemInstr IM(
	.Dir(PC),
	.Instr(Instr)
);

Control UC(
	.opcode(Instr[31:26]),
	.RegDst(RegDst),
	.ALUSrc(ALUSrc),
	.MemtoReg(MemtoReg),
	.RegWrite(RegWrite),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.Branch(Branch),
	.Jump(Jump),
	.ExtCero(ExtCero),
	.ALUOp(ALUOp)
);

ControlALU UA(
	.ALUOp(ALUOp),
	.funct(Instr[5:0]),
	.ALUctl(ALUctl)
);

Registros RB(
	.clk(clk),
	.RegWrite(RegWrite),
	.RA1(Instr[25:21]),
	.RA2(Instr[20:16]),
	.WA(RegDest),
	.WD(DatoReg),
	.RD1(RD1),
	.RD2(RD2)
);

Extensor EXT(
	.Inm(Instr[15:0]),
	.ExtCero(ExtCero),
	.Ext(Ext)
);

MIPSALU ALU1(
	.ALUctl(ALUctl),
	.A(RD1),
	.B(ALUB),
	.ALUOut(ALUOut),
	.Zero(Zero)
);

MemDatos DM(
	.clk(clk),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.Dir(ALUOut),
	.WD(RD2),
	.RD(DatoMem)
);

//3.2 multiplexores y siguiente PC (assign)
assign RegDest = RegDst ? Instr[15:11] : Instr[20:16];
assign ALUB = ALUSrc ? Ext : RD2;
assign DatoReg = MemtoReg ? DatoMem : ALUOut;

assign PCmas4 = PC + 32'd4;
assign PCbeq = PCmas4 + {Ext[29:0],2'b00};
assign PCsig = Jump ? {PCmas4[31:28],Instr[25:0],2'b00} : ((Branch & Zero) ? PCbeq : PCmas4);

//3.3 secuencial: el PC cambia en el flanco de subida
initial PC = 32'd0;

always @(posedge clk)
begin
	PC <= PCsig;
end

endmodule
