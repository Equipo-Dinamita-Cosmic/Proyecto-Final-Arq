//1. definir modulo y sus I/O
module Control(
	input [5:0]opcode,
	output RegDst,
	output ALUSrc,
	output MemtoReg,
	output RegWrite,
	output MemRead,
	output MemWrite,
	output Branch,
	output Jump,
	output ExtCero,
	output [2:0]ALUOp
);

//2. componentes internos
reg [11:0]controles;

//3. cuerpo del modulo
assign {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,ExtCero,ALUOp} = controles;

always @*
begin
	case(opcode)
		//                 RegDst ALUSrc MemtoReg RegWrite MemRead MemWrite Branch Jump ExtCero ALUOp
		6'b000000: controles = 12'b1_0_0_1_0_0_0_0_0_010; //tipo R (add sub slt or and)
		6'b001000: controles = 12'b0_1_0_1_0_0_0_0_0_000; //addi
		6'b001010: controles = 12'b0_1_0_1_0_0_0_0_0_101; //slti
		6'b001100: controles = 12'b0_1_0_1_0_0_0_0_1_011; //andi
		6'b001101: controles = 12'b0_1_0_1_0_0_0_0_1_100; //ori
		6'b100011: controles = 12'b0_1_1_1_1_0_0_0_0_000; //lw
		6'b101011: controles = 12'b0_1_0_0_0_1_0_0_0_000; //sw
		6'b000100: controles = 12'b0_0_0_0_0_0_1_0_0_001; //beq
		6'b000010: controles = 12'b0_0_0_0_0_0_0_1_0_000; //j
		default:   controles = 12'b0_0_0_0_0_0_0_0_0_000;
	endcase
end

endmodule
