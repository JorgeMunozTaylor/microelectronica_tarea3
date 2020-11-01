#    Tarea 3: Potencia
#    Microelectrónica
#    Modificado por Jorge Muñoz Taylor
#    Carné A53863
#    II-2020

all: parte1 parte2 parte3

parte1:
	@echo "\n**********************************************************************"
	@echo " 			PARTE 1"
	@echo "**********************************************************************"
	@sleep 2
	@mkdir -p ./bin
	@iverilog -o ./bin/tarea ./src/definiciones.v ./testbench/BancoPruebas.v ./src/sumador_rizado.v 
	@vvp ./bin/tarea
	@gtkwave ./bin/Sumadores.vcd
	@echo "\n"

parte2:
	@echo "\n**********************************************************************"
	@echo " 			PARTE 2"
	@echo "**********************************************************************"
	@sleep 2
	@mkdir -p ./bin
	@iverilog -o ./bin/tarea ./src/definiciones2.v ./testbench/BancoPruebas.v ./src/sumador_rizado.v 
	@vvp ./bin/tarea
	@gtkwave ./bin/Sumadores.vcd
	@echo "\n"

parte3:
	@echo "\n**********************************************************************"
	@echo " 			PARTE 3"
	@echo "**********************************************************************"
	@sleep 2
	@mkdir -p ./bin
	@iverilog -o ./bin/tarea ./src/definiciones.v ./testbench/BancoPruebas.v ./src/sumador_rizado2.v 
	@vvp ./bin/tarea
	@gtkwave ./bin/Sumadores.vcd

clean:
	@rm -rf ./bin 