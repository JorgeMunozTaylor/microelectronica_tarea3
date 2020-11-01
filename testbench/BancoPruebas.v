/*
    Tarea 3: Potencia
    Microelectrónica
    Modificado por Jorge Muñoz Taylor
    Carné A53863
    II-2020
*/

`timescale 1ns/1ps

`ifndef _LIBRERIA_
`define _LIBRERIA_
`include "./src/libreria.v"
`endif

`include "./src/sumador_logico.v"
`include "./src/sumador_look.v"
`include "./src/contador_Transicion.v"


// -----------------------------------------------
// Banco de pruebas
// -----------------------------------------------

module BancoPruebas;

  reg [7:0] oprA, oprB;
  reg [31:0] Contador;
  reg [`Ndir:0] dir;
  reg LE;
  integer Contador_sumas, valor;
  wire [31:0] dato;
  wire [7:0] Suma, Suma_logico, Suma_look;
  wire carry_rizado, carry_logico, carry_look;

  //Conexion a la memoria de contadores de transicion
  contador_Transicion mem_trans (dir, LE, dato);
  //Control de E/S del puerto de dato de la memoria de contadores
  assign dato = (~LE)? Contador : 32'bz;

  integer PRUEBA       = 1; // Variable utilizada para saber que mensaje se imprime en la terminal.
  integer repeticion   = 0; // Se usa para determinar en cual repeticion de la prueba se esta
  integer NUMERO_SUMAS = 50; // Define cuantas sumas se haran 
  integer loops; // Dependiendo en que repeticion estemos, vale 1 o 3, solo vale 1 la primera vez que se ejecuta la prueba
  integer SEMILLA =10; // La semilla que se usa para generar los numeros aleatorios

  // ---------------------------------------------------------------
  // Nota:
  // Sumador de rizado usa contador 0 de la memoria
  // Sumador de logico usa contador 1 de la memoria
  // Sumador lookahead usa contador 2 de la memoria
  // ---------------------------------------------------------------

  SUM_RIZADO #(0)  sumadorRizado (oprA, oprB, 1'b0, Suma, carry_rizado);
  SUM8_LOGICO #(1)  sumadorLogico (oprA, oprB, 1'b0, Suma_logico, carry_logico);
  SUM8_LOOKAHEAD #(2) sumadorLookahead (oprA, oprB, 1'b0, Suma_look, carry_look);
  
  // Variables que se utilizan en la parte 3 para medir el retardo de los contadores
  integer retardo_rizado; // Retardo del sumador de rizado
  integer retardo_logico; // Retardo del sumador de logico
  integer retardo_look; // Retardo del sumador de lookaside

  initial
  begin

      // Se repite 6 veces la prueba original.
      repeat (6)
      begin
            $display ("\n\n**********************************************************************");

            // Estos if se encargan de determinar el mensaje que se desplegara en la terminal.
            if ( repeticion == 0) 
            begin
              loops = 1;
              $display ("   Comprueba el funcionamiento del sumador de rizado");
              $display ("**********************************************************************\n");
            end
            else if ( repeticion == 1) 
            begin
              loops = 3;
              $display ("   Potencia para 500 sumas y 3 semillas");
              $display ("**********************************************************************");            
            end
            else if ( repeticion == 2) 
            begin
              loops = 3;
              $display ("   Potencia para 1000 sumas y 3 semillas");
              $display ("**********************************************************************");
            end
            else if ( repeticion == 3) 
            begin
              loops = 3;
              $display ("   Potencia para 2000 sumas y 3 semillas");
              $display ("**********************************************************************");
            end
            else if ( repeticion == 4) 
            begin
              loops = 3;
              $display ("   Potencia para 5000 sumas y 3 semillas");
              $display ("**********************************************************************");
            end


            // Cuando se llegue a la ultima repeticion se ejecuta un codigo diferente, el cual es
            // el que se encarga de determinar los tiempos de retardo de los sumadores.
            if ( repeticion != 5)
            begin
                
                // Si se encuentra en la primera repeticion solo se ejecutara el codigo una vez, ya que
                // la primera repeticion solo comprueba que el sumador sume correctamente, en el resto de simulaciones
                // se ejecuta 3 veces porque las pruebas se corren con 3 semillas diferentes.
                repeat(loops)
                begin

                    // Borrar memoria de transiciones
                    #1 LE = 0;
                    Contador = 0;
                    Contador_sumas = 0;

                    for (dir=0; dir<=`NumPwrCntr; dir=dir+1)
                      #1 Contador = 0;

                    // ------------------------------------------------------
                    //SEMILLA inicial para el generador de numeros aleatorios
                    // ------------------------------------------------------

                    SEMILLA = SEMILLA + $random%255;

                    #50;
                    //Primer par de operandos para los sumadores
                    oprA = $random(SEMILLA);
                    oprB = $random(SEMILLA);


                    // Código ciclico por el número de sumas deseadas.
                    repeat ( NUMERO_SUMAS )
                    begin
                      #50 
                      
                      if ( PRUEBA == 1)
                        $display ("No. Suma = %d: Operador A = %d, Operador B = %d, Sumador_1 = %d, Sumador_2 = %d, Sumador_3=%d",Contador_sumas,oprA,oprB,Suma,Suma_logico,Suma_look);
                      
                      Contador_sumas = Contador_sumas + 1;
                      oprB = $random(SEMILLA);
                      oprA = $random(SEMILLA);
                    end


                    if ( PRUEBA != 1)
                    begin
                      #50 $display ("\n-> No. Sumas:%d", Contador_sumas);

                      //Lea y despliegue la memoria con contadores de transicion
                      $display ("-> Semilla: ", SEMILLA);
                    end
                    
                    #50 LE = 1;


                    for (dir=0; dir<=`NumPwrCntr; dir=dir+1)
                    begin
                      #1 Contador = dato;
                      if ( PRUEBA != 1) $display(,,"-> PwrCntr[%d]: %d", dir, Contador);
                    end

                    if ( repeticion == 0 ) 
                      NUMERO_SUMAS = 500;
                    

                    PRUEBA       = 0;

                    if(repeticion==0)
                    begin
                      $dumpfile ("./bin/Sumadores.vcd");
                      $dumpvars;
                    end
                end //Repeat end


                // Cambia la cantidad de sumas que se haran en base a la repeticion de la prueba 
                if ( repeticion == 1 ) NUMERO_SUMAS = 1000;
                else if ( repeticion == 2 ) NUMERO_SUMAS = 2000;
                else if ( repeticion == 3 ) NUMERO_SUMAS = 5000;

                repeticion = repeticion + 1;
            end

            /**/
            else
            begin
              
              /* Se miden los retardos de cada sumador, el procedimiento que se siguio:
                1. Se resetea la salida del sumador con 1's, esto se consigue sumando FF a 0.
                2. Se mide el tiempo en el que se encuentra la simulacion.
                3. Se ponen las entradas corespondientes.
                4. Se espera a que la salida llegue al valor que debe dar.
                5. Se mide el tiempo en el que se llega al valor correcto y se le resta el tiempo inicial.
                6. Se repite el proceso con otro sumador, asi hasta que se analizen los 3 casos solicitados:
                      6.1. oprA == 00 oprB == 00
                      6.2. oprA == 00 oprB == 01
                      6.3. oprA == FF oprB == 01
              */
              $display ("   Medición de los retardos");
              $display ("\n**********************************************************************");

              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              $display ("\n-> Sumador de rizado:");
              #50 retardo_rizado = $realtime;
              oprA = 8'b0; 
              oprB = 8'b0;

              @( Suma == 8'b0 )
                retardo_rizado = $realtime - retardo_rizado;
                $display ("\n----> A = B = 00:       %f", retardo_rizado );


              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              #50  retardo_rizado = $realtime;
              oprA = 8'b0; 
              oprB = 8'b1;

              @( Suma == 8'b1 )
                retardo_rizado = $realtime - retardo_rizado;
                $display ("----> A = 00, B = 01:   %f", retardo_rizado );


              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              #50  retardo_rizado = $realtime;
              oprA = 8'hff; 
              oprB = 8'b01;

              @( Suma == 8'b0000_0000 )
                retardo_rizado = $realtime - retardo_rizado;
                $display ("----> A = FF, B = 01:   %f", retardo_rizado );



              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              $display ("\n-> Sumador lógico:");
              #50 retardo_logico = $realtime;
              oprA = 8'b00; 
              oprB = 8'b00;

              @( Suma_logico == 0 )
                retardo_logico = $realtime - retardo_logico;
                $display ("\n----> A = B = 00:       %f", retardo_logico);

              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              #50 retardo_logico = $realtime;
              oprA = 8'b0; 
              oprB = 8'b1;

              @( Suma_logico == 1 )
                retardo_logico = $realtime - retardo_logico;
                $display ("----> A = 00, B = 01:   %f", retardo_logico);


              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              #50 retardo_logico = $realtime;
              oprA = 8'hff; 
              oprB = 8'b01;

              @( Suma_logico == 0 )
                retardo_logico = $realtime - retardo_logico;
                $display ("----> A = FF, B = 01:   %f", retardo_logico);

              //
              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              $display ("\n-> Sumador de lookaside:");
              #100 retardo_look = $realtime;
              oprA = 8'b00; 
              oprB = 8'b00;

              @( Suma_look == 0 )
                retardo_look = $realtime - retardo_look;
                $display ("\n----> A = B = 00:       %f", retardo_look );

              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              #100 retardo_look = $realtime;
              oprA = 8'b00; 
              oprB = 8'b01;

              @( Suma_look == 1 )
                retardo_look = $realtime - retardo_look;
                $display ("----> A = 00, B = 01:   %f", retardo_look );

              // Resetea la salida del sumador
              oprA = 8'hff; 
              oprB = 8'b00;
              //
              #100 retardo_look = $realtime;
              oprA = 8'hff; 
              oprB = 8'b01;

              @( Suma_look == 0 )
                retardo_look = $realtime - retardo_look;
                $display ("----> A = FF, B = 01:   %f", retardo_look );
            end


      end //Repeat end

    $display ("\n**********************************************************************");

    //$dumpfile ("./bin/Sumadores.vcd");
    //$dumpvars;

    #1 $finish;
  end

endmodule
