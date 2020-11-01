/*
    Tarea 3: Potencia
    Microelectrónica
    Creado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/


`ifndef _LIBRERIA_
`define _LIBRERIA_
`include "./src/libreria.v"
`endif

/* 
 -----------------------------------------------
 Sumador completo de un bit
 -----------------------------------------------
 Definicion estructural de un sumador completo, su diseno se 
 extrajo del documento de especificaciones de la tarea. 

 Entradas: A, B, Cin
 Salidas:  Cout y S
*/
module sumador_completo ( x, y, cent, s, csal);
  parameter
    PwrC = 0;

  // Se definen las entradas y salidas del sumador
  input x;
  input y;
  input cent;

  output s;
  output csal;

  wire out_XOR_0;
  wire out_AND_0;
  wire out_AND_1;
  wire out_AND_2;

  xor2_p XOR_0 ( out_XOR_0, x, y );
  xor2_p XOR_1 ( s, cent, out_XOR_0 );

  and2_p AND_0 ( out_AND_0, cent, x );
  and2_p AND_1 ( out_AND_1, cent, y );
  and2_p AND_2 ( out_AND_2, x, y );

  or3_p OR_0 ( csal, out_AND_0, out_AND_1, out_AND_2 );

endmodule


/* 
 -----------------------------------------------
 Sumador rizado de 8 bits
 -----------------------------------------------
 Definicion coonductual de un sumador de rizado de 8 bits.

 Entradas: a, b, ci
 Salidas:  co y s
*/
module SUM_RIZADO(a, b, ci, s, co);
  parameter
    PwrC = 0;

  input [7:0] a;
  input [7:0] b;
  input       ci;

  output [7:0] s;
  output       co;

  wire [7:0] out_co;
  wire [7:0] in_ci;

  assign co = out_co[7];
  assign in_ci[0] = ci;

  /* 
  Este codigo repite 8 veces el sumador completo de un bit junto con sus cables,
  luego se conectan 
  */
  genvar i;  
  generate

    for (i=0; i<8; i=i+1) 
    begin   

      // Se conectan los carry input con los carry output del sumador anterior
      if ( i != 7 )
        assign in_ci[i+1] = out_co[i];

      sumador_completo #(PwrC) BLOCK 
      ( 
        .x    ( a[i] ), 
        .y    ( b[i] ), 
        .cent ( in_ci[i] ), 
        .s    ( s[i] ), 
        .csal ( out_co[i] ) 
      );
    end

  endgenerate

endmodule