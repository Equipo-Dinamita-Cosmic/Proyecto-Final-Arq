//Testbench AUTOGENERADO: corre el programa de la ROM (MemInstr.v) y revisa el estado final.
`timescale 1ns/1ns
module Programa_tb();

//2. comp internos
reg clk_tb;
integer pruebas,fallas;

//3.1 instancias
MIPS DUV(
	.clk(clk_tb)
);

//3.2 tareas

task revisar_pc;
	input [31:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (DUV.PC === esperado)
			$display("PROG pc esperado=%h observado=%h PASS", esperado, DUV.PC);
		else
		begin
			fallas = fallas + 1;
			$display("PROG pc esperado=%h observado=%h FAIL", esperado, DUV.PC);
		end
	end
endtask

task revisar_reg;
	input [4:0]n;
	input [31:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (DUV.RB.banco[n] === esperado)
			$display("PROG r%0d esperado=%h observado=%h PASS", n, esperado, DUV.RB.banco[n]);
		else
		begin
			fallas = fallas + 1;
			$display("PROG r%0d esperado=%h observado=%h FAIL", n, esperado, DUV.RB.banco[n]);
		end
	end
endtask

task revisar_mem;
	input [5:0]n;
	input [31:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (DUV.DM.sram[n] === esperado)
			$display("PROG m%0d esperado=%h observado=%h PASS", n, esperado, DUV.DM.sram[n]);
		else
		begin
			fallas = fallas + 1;
			$display("PROG m%0d esperado=%h observado=%h FAIL", n, esperado, DUV.DM.sram[n]);
		end
	end
endtask


//traza: instruccion que se ejecuta en cada flanco
always @(posedge clk_tb)
	$display("TRACE PC=%h Instr=%h",DUV.PC,DUV.Instr);

//3.3 secuencial initial para evaluar
initial
begin
	$dumpfile("Programa.vcd");
	$dumpvars(0,Programa_tb);
	clk_tb = 1'b0;
	pruebas = 0;
	fallas = 0;
	#1;
	DUV.RB.banco[16] = 32'h0000000a; //precarga de registros
	repeat (14)
	begin
		#50;
		clk_tb = 1'b1;
		#50;
		clk_tb = 1'b0;
	end

	revisar_pc(32'h00000034);
	revisar_reg(5'd8,32'h00000005);
	revisar_reg(5'd9,32'h00000007);
	revisar_reg(5'd10,32'h0000000c);
	revisar_reg(5'd11,32'h0000000c);
	revisar_reg(5'd12,32'h00000000);
	revisar_reg(5'd13,32'h00000001);
	revisar_reg(5'd14,32'hfffffffe);
	revisar_reg(5'd15,32'h00000007);
	revisar_reg(5'd16,32'h0000000a);
	revisar_reg(5'd17,32'h0000002a);
	revisar_mem(6'd4,32'h0000000c);
	revisar_mem(6'd8,32'h0000002a);

	if (fallas == 0)
		$display("RES PROGRAMA PASS comprobaciones=%0d",pruebas);
	else
		$display("RES PROGRAMA FAIL fallas=%0d",fallas);
	$finish;
end

endmodule
