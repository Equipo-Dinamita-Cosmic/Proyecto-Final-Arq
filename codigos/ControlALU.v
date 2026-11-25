//1. definir modulo y sus I/O
module ControlALU(
	input [2:0]ALUOp,
	input [5:0]funct,
	output reg [3:0]ALUctl
);

//3. cuerpo del modulo
//ALUOp: 0=suma  1=resta  2=tipo R (mira funct)  3=AND  4=OR  5=SLT
//ALUctl (el de MIPSALU): 0=AND 1=OR 2=suma 6=resta 7=slt
always @*
begin
	case(ALUOp)
		3'd0: ALUctl = 4'd2;
		3'd1: ALUctl = 4'd6;
		3'd3: ALUctl = 4'd0;
		3'd4: ALUctl = 4'd1;
		3'd5: ALUctl = 4'd7;
		3'd2:
		begin
			case(funct)
				6'd32: ALUctl = 4'd2; //add
				6'd34: ALUctl = 4'd6; //sub
				6'd36: ALUctl = 4'd0; //and
				6'd37: ALUctl = 4'd1; //or
				6'd42: ALUctl = 4'd7; //slt
				default: ALUctl = 4'd2;
			endcase
		end
		default: ALUctl = 4'd2;
	endcase
end

endmodule
