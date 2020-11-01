// -----------------------------------------------
// Contadores de transiciónes
// -----------------------------------------------
// NumPwrCntr debe tener el numero de contadores N, menos uno: NumPwrCntr = N - 1
// Ndir debe ser tal que (2^(Ndir+1) - 1) > NumPwrCntr.
// Nota: Si no se cumple las condiciones se genera un loop infinito.
`define NumPwrCntr 2
`define Ndir 1


// -----------------------------------------------
// Modulo: Contador de transicion
// -----------------------------------------------

module contador_Transicion (dir, LE, dato);
  input [`Ndir:0] dir;
  input LE;
  inout [31:0] dato;
  reg [31:0] PwrCntr [`NumPwrCntr:0];

  //Control de E/S del puerto de datos
  assign dato = (LE)? PwrCntr[dir] : 32'bz;

  //Ciclo de escritura para la memoria
  always @(dir or negedge LE or dato)
    begin
      if (~LE) //escritura
        PwrCntr[dir] = dato;
    end
endmodule