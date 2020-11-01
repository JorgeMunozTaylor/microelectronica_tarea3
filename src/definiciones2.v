/*
    Tarea 3: Potencia
    Microelectrónica
    Modificado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

/******************Definiciones***********/
// ---------------------
// Retardo de compuertas
// ---------------------

`define d_inv  1
`define d_and2 1
`define d_and3 1
`define d_and4 1
`define d_and5 1
`define d_or2  1
`define d_or3  1
`define d_or4  1
`define d_or5  1
`define d_xor2 1
`define d_xor3 1

// ----------------------------------------------
//"Ponderaciones" de potencia para las compuertas
// ----------------------------------------------

`define Pinv  60
`define Pand2 2*`Pinv
`define Pand3 3*`Pinv
`define Pand4 4*`Pinv
`define Pand5 5*`Pinv
`define Por2  1/2*`Pinv
`define Por3  1/3*`Pinv
`define Por4  1/4*`Pinv
`define Por5  1/5*`Pinv
`define Pxor2 1*`Pinv
`define Pxor3 2*`Pinv
