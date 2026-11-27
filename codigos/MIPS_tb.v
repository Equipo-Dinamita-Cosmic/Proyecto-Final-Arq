//Testbench AUTOGENERADO por scripts/generar.py
//Cada caso: limpia todo, escribe el estado inicial, ejecuta UNA instruccion (un flanco de reloj) y revisa.
//ctl = {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,ExtCero,ALUctl[3:0]}
`timescale 1ns/1ns
module MIPS_tb();

//2. comp internos
reg clk_tb;
reg [12:0]ctl_obs;
integer caso,pruebas,fallas,k;

//3.1 instancias
MIPS DUV(
	.clk(clk_tb)
);

//3.2 tareas
task limpiar; //deja registros, memoria de datos y memoria de instrucciones en 0
	begin
		for (k=0; k<32; k=k+1)
			DUV.RB.banco[k] = 32'd0;
		for (k=0; k<64; k=k+1)
		begin
			DUV.DM.sram[k] = 32'd0;
			DUV.IM.srom[k] = 32'd0;
		end
	end
endtask

task ejecutar; //espera, guarda los controles y da UN flanco de subida
	begin
		#10;
		ctl_obs = {DUV.RegDst,DUV.ALUSrc,DUV.MemtoReg,DUV.RegWrite,DUV.MemRead,DUV.MemWrite,DUV.Branch,DUV.Jump,DUV.ExtCero,DUV.ALUctl};
		clk_tb = 1'b1;
		#10;
		clk_tb = 1'b0;
		#10;
	end
endtask

task revisar_ctl;
	input [12:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (ctl_obs === esperado)
			$display("T%0d ctl esperado=%b observado=%b PASS",caso, esperado, ctl_obs);
		else
		begin
			fallas = fallas + 1;
			$display("T%0d ctl esperado=%b observado=%b FAIL",caso, esperado, ctl_obs);
		end
	end
endtask

task revisar_pc;
	input [31:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (DUV.PC === esperado)
			$display("T%0d pc esperado=%h observado=%h PASS",caso, esperado, DUV.PC);
		else
		begin
			fallas = fallas + 1;
			$display("T%0d pc esperado=%h observado=%h FAIL",caso, esperado, DUV.PC);
		end
	end
endtask

task revisar_reg;
	input [4:0]n;
	input [31:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (DUV.RB.banco[n] === esperado)
			$display("T%0d r%0d esperado=%h observado=%h PASS",caso, n, esperado, DUV.RB.banco[n]);
		else
		begin
			fallas = fallas + 1;
			$display("T%0d r%0d esperado=%h observado=%h FAIL",caso, n, esperado, DUV.RB.banco[n]);
		end
	end
endtask

task revisar_mem;
	input [5:0]n;
	input [31:0]esperado;
	begin
		pruebas = pruebas + 1;
		if (DUV.DM.sram[n] === esperado)
			$display("T%0d m%0d esperado=%h observado=%h PASS",caso, n, esperado, DUV.DM.sram[n]);
		else
		begin
			fallas = fallas + 1;
			$display("T%0d m%0d esperado=%h observado=%h FAIL",caso, n, esperado, DUV.DM.sram[n]);
		end
	end
endtask

//3.3 secuencial initial para evaluar
initial
begin
	$dumpfile("MIPS.vcd");
	$dumpvars(0,MIPS_tb);
	clk_tb = 1'b0;
	pruebas = 0;
	fallas = 0;
	#1;


	//T1  add $t2,$t0,$t1   codigo 0x01095020   (add basico)
	caso = 1;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01095020;
	DUV.RB.banco[8] = 32'h0000000a;
	DUV.RB.banco[9] = 32'h00000014;
	ejecutar;
	revisar_ctl(13'b1001000000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'h0000001e);

	//T2  add $t2,$t0,$t1   codigo 0x01095020   (add con negativo)
	caso = 2;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01095020;
	DUV.RB.banco[8] = 32'hfffffffb;
	DUV.RB.banco[9] = 32'h00000003;
	ejecutar;
	revisar_ctl(13'b1001000000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'hfffffffe);

	//T3  sub $t2,$t0,$t1   codigo 0x01095022   (sub basico)
	caso = 3;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01095022;
	DUV.RB.banco[8] = 32'h00000014;
	DUV.RB.banco[9] = 32'h00000007;
	ejecutar;
	revisar_ctl(13'b1001000000110);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'h0000000d);

	//T4  sub $t2,$t0,$t1   codigo 0x01095022   (sub resultado negativo)
	caso = 4;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01095022;
	DUV.RB.banco[8] = 32'h00000005;
	DUV.RB.banco[9] = 32'h00000009;
	ejecutar;
	revisar_ctl(13'b1001000000110);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'hfffffffc);

	//T5  slt $t2,$t0,$t1   codigo 0x0109502a   (slt verdadero (con signo))
	caso = 5;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h0109502a;
	DUV.RB.banco[8] = 32'hfffffffd;
	DUV.RB.banco[9] = 32'h00000002;
	ejecutar;
	revisar_ctl(13'b1001000000111);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'h00000001);

	//T6  slt $t2,$t0,$t1   codigo 0x0109502a   (slt falso (iguales))
	caso = 6;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h0109502a;
	DUV.RB.banco[8] = 32'h00000007;
	DUV.RB.banco[9] = 32'h00000007;
	DUV.RB.banco[10] = 32'h00000055;
	ejecutar;
	revisar_ctl(13'b1001000000111);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'h00000000);

	//T7  slt $t2,$t0,$t1   codigo 0x0109502a   (slt falso (con signo))
	caso = 7;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h0109502a;
	DUV.RB.banco[8] = 32'h00000002;
	DUV.RB.banco[9] = 32'hfffffffd;
	ejecutar;
	revisar_ctl(13'b1001000000111);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'h00000000);

	//T8  or $t2,$t0,$t1   codigo 0x01095025   (or)
	caso = 8;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01095025;
	DUV.RB.banco[8] = 32'hf0f0f0f0;
	DUV.RB.banco[9] = 32'h0f0f00ff;
	ejecutar;
	revisar_ctl(13'b1001000000001);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'hfffff0ff);

	//T9  and $t2,$t0,$t1   codigo 0x01095024   (and)
	caso = 9;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01095024;
	DUV.RB.banco[8] = 32'hff00ff00;
	DUV.RB.banco[9] = 32'h0ff00ff0;
	ejecutar;
	revisar_ctl(13'b1001000000000);
	revisar_pc(32'h00000004);
	revisar_reg(5'd10,32'h0f000f00);

	//T10  add $zero,$t0,$t1   codigo 0x01090020   (add escribe en $zero)
	caso = 10;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h01090020;
	DUV.RB.banco[8] = 32'h0000000a;
	DUV.RB.banco[9] = 32'h00000014;
	ejecutar;
	revisar_ctl(13'b1001000000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd0,32'h00000000);

	//T11  addi $t1,$t0,25   codigo 0x21090019   (addi positivo)
	caso = 11;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h21090019;
	DUV.RB.banco[8] = 32'h00000064;
	ejecutar;
	revisar_ctl(13'b0101000000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h0000007d);

	//T12  addi $t1,$t0,-1   codigo 0x2109ffff   (addi inmediato negativo)
	caso = 12;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h2109ffff;
	DUV.RB.banco[8] = 32'h00000064;
	ejecutar;
	revisar_ctl(13'b0101000000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h00000063);

	//T13  slti $t1,$t0,3   codigo 0x29090003   (slti verdadero)
	caso = 13;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h29090003;
	DUV.RB.banco[8] = 32'hfffffffb;
	ejecutar;
	revisar_ctl(13'b0101000000111);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h00000001);

	//T14  slti $t1,$t0,-1   codigo 0x2909ffff   (slti falso, inmediato negativo)
	caso = 14;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h2909ffff;
	DUV.RB.banco[8] = 32'h00000000;
	DUV.RB.banco[9] = 32'h00000077;
	ejecutar;
	revisar_ctl(13'b0101000000111);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h00000000);

	//T15  andi $t1,$t0,0x8001   codigo 0x31098001   (andi con bit 15 = 1)
	caso = 15;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h31098001;
	DUV.RB.banco[8] = 32'hffffffff;
	ejecutar;
	revisar_ctl(13'b0101000010000);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h00008001);

	//T16  ori $t1,$t0,0x8000   codigo 0x35098000   (ori con bit 15 = 1)
	caso = 16;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h35098000;
	DUV.RB.banco[8] = 32'h00010000;
	ejecutar;
	revisar_ctl(13'b0101000010001);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h00018000);

	//T17  sw $t1,8($t0)   codigo 0xad090008   (sw)
	caso = 17;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'had090008;
	DUV.RB.banco[8] = 32'h00000010;
	DUV.RB.banco[9] = 32'hcafebabe;
	ejecutar;
	revisar_ctl(13'b0100010000010);
	revisar_pc(32'h00000004);
	revisar_mem(6'd6,32'hcafebabe);

	//T18  sw $t1,-4($t0)   codigo 0xad09fffc   (sw con desplazamiento negativo)
	caso = 18;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'had09fffc;
	DUV.RB.banco[8] = 32'h00000020;
	DUV.RB.banco[9] = 32'ha5a5a5a5;
	ejecutar;
	revisar_ctl(13'b0100010000010);
	revisar_pc(32'h00000004);
	revisar_mem(6'd7,32'ha5a5a5a5);

	//T19  lw $t1,8($t0)   codigo 0x8d090008   (lw)
	caso = 19;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h8d090008;
	DUV.RB.banco[8] = 32'h00000010;
	DUV.DM.sram[6] = 32'h12345678;
	ejecutar;
	revisar_ctl(13'b0111100000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd9,32'h12345678);
	revisar_mem(6'd6,32'h12345678);

	//T20  lw $zero,0($t0)   codigo 0x8d000000   (lw hacia $zero)
	caso = 20;
	limpiar;
	DUV.PC = 32'h00000000;
	DUV.IM.srom[0] = 32'h8d000000;
	DUV.RB.banco[8] = 32'h00000010;
	DUV.DM.sram[4] = 32'h0badf00d;
	ejecutar;
	revisar_ctl(13'b0111100000010);
	revisar_pc(32'h00000004);
	revisar_reg(5'd0,32'h00000000);

	//T21  beq $t0,$t1,3   codigo 0x11090003   (beq tomado)
	caso = 21;
	limpiar;
	DUV.PC = 32'h00000040;
	DUV.IM.srom[16] = 32'h11090003;
	DUV.RB.banco[8] = 32'h00000005;
	DUV.RB.banco[9] = 32'h00000005;
	ejecutar;
	revisar_ctl(13'b0000001000110);
	revisar_pc(32'h00000050);

	//T22  beq $t0,$t1,3   codigo 0x11090003   (beq no tomado)
	caso = 22;
	limpiar;
	DUV.PC = 32'h00000040;
	DUV.IM.srom[16] = 32'h11090003;
	DUV.RB.banco[8] = 32'h00000005;
	DUV.RB.banco[9] = 32'h00000006;
	ejecutar;
	revisar_ctl(13'b0000001000110);
	revisar_pc(32'h00000044);

	//T23  beq $t0,$t1,-2   codigo 0x1109fffe   (beq tomado hacia atras)
	caso = 23;
	limpiar;
	DUV.PC = 32'h00000040;
	DUV.IM.srom[16] = 32'h1109fffe;
	DUV.RB.banco[8] = 32'h00000009;
	DUV.RB.banco[9] = 32'h00000009;
	ejecutar;
	revisar_ctl(13'b0000001000110);
	revisar_pc(32'h0000003c);

	//T24  j 0x00000080   codigo 0x08000020   (j)
	caso = 24;
	limpiar;
	DUV.PC = 32'h00000010;
	DUV.IM.srom[4] = 32'h08000020;
	DUV.RB.banco[8] = 32'h00000001;
	ejecutar;
	revisar_ctl(13'b0000000100010);
	revisar_pc(32'h00000080);

	//T25  j 0x00000080   codigo 0x08000020   (j con bits altos del PC)
	caso = 25;
	limpiar;
	DUV.PC = 32'h30000010;
	DUV.IM.srom[4] = 32'h08000020;
	DUV.RB.banco[8] = 32'h00000001;
	ejecutar;
	revisar_ctl(13'b0000000100010);
	revisar_pc(32'h30000080);

	$display("RESUMEN comprobaciones=%0d fallas=%0d",pruebas,fallas);
	$finish;
end

endmodule
