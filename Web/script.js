const M={
pc:["PC","Registro que guarda la dirección de la instrucción actual."],
add4:["Sumador PC+4","Calcula la dirección de la siguiente instrucción secuencial."],
imem:["Memoria de Instrucciones","Entrega la instrucción de 32 bits según el PC."],
shj:["Shift Left (jump)","Desplaza 2 bits el campo index (26 bits → 28) para la dirección de salto tipo J."],
shb:["Shift Left (branch)","Multiplica por 4 el inmediato extendido para el salto condicional."],
ctrl:["Unidad de Control","Decodifica el opcode (bits 31:26) y genera las señales de control."],
regs:["Banco de Registros","Lee dos registros (AR1, AR2) y escribe uno (AW, DW) cuando en_BR está activo."],
mux2:["Mux2 (RegDst)","Elige el registro destino entre rt [20:16] y rd [15:11]."],
sext:["Sign Ext","Extiende de 16 a 32 bits el inmediato conservando el signo."],
mux3:["Mux3 (ALU_Src)","Elige entre DR2 y el inmediato como segundo operando de la ALU."],
alu:["ALU","Realiza la operación aritmética o lógica y genera la bandera zf."],
aluc:["ALU Control","Combina ALU Op y funct [5:0] para definir la operación de la ALU."],
dmem:["Memoria de Datos","Lectura y escritura de datos (Address_In, Data_In) para lw / sw."],
mux1:["Mux1 (MemToReg)","Elige entre el dato leído de memoria y el resultado de la ALU."],
addb:["Sumador de salto","Suma PC+4 con el desplazamiento para obtener la dirección de branch."],
mux4:["Mux4 (Branch)","Elige entre PC+4 y la dirección de salto condicional (Branch AND zf)."],
mux5:["Mux5 (Jump)","Elige entre la dirección del Mux4 y la dirección de jump."]};
const S=[["RegDst","Selecciona rt o rd como registro destino."],["ALU_Src","Selecciona registro o inmediato para la ALU."],["MemToReg","Selecciona el dato que se escribe al registro."],["en_BR","Habilita escritura en el banco de registros."],["MemRead","Habilita lectura de la memoria de datos."],["MemWrite","Habilita escritura en la memoria de datos."],["Branch","Activa el salto condicional junto con zf."],["Jump","Activa el salto incondicional."],["ALU Op","Indica a ALU Control el tipo de operación."]];
const $=s=>document.querySelector(s);
const code=(k,n)=>`// Módulo: ${n}\n// TODO: reemplazar con el código real\nmodule ${k}(\n  input  wire clk,\n  input  wire [31:0] in,\n  output wire [31:0] out\n);\n  // placeholder\n  assign out = in;\nendmodule`;
$("#mods").innerHTML=Object.values(M).map(v=>`<div class="card"><b>${v[0]}</b><p class="mut">${v[1]}</p></div>`).join("");
$("#sig").innerHTML=S.map(s=>`<tr><td><code>${s[0]}</code></td><td>${s[1]}</td></tr>`).join("");
function openM(k){const v=M[k];$("#t").textContent=v[0];$("#d").textContent=v[1];$("#k").textContent=code(k,v[0]);$("#ov").classList.add("on");$("#x").focus()}
document.querySelectorAll(".m").forEach(g=>{
  g.addEventListener("click",()=>openM(g.dataset.m));
  g.addEventListener("keydown",e=>{if(e.key==="Enter"||e.key===" "){e.preventDefault();openM(g.dataset.m)}});
});
const closeM=()=>$("#ov").classList.remove("on");
$("#x").onclick=closeM;
$("#ov").onclick=e=>{if(e.target.id==="ov")closeM()};
document.addEventListener("keydown",e=>{if(e.key==="Escape")closeM()});