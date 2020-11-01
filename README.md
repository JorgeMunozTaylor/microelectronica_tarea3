# Tarea 3: Potencia

## Autor
```
Jorge Muñoz Taylor 
A53863
jorge.munoztaylor@ucr.ac.cr
```

## Reporte
Se encuentra en el repositorio con nombre: 
```
tarea3_A53863.pdf
```

## Como ejecutar el código
Ubíquese en la carpeta raíz de la tarea: 
```
cd $(PATH)/microelectronica_tarea3
```

El makefile se disenó para ejecutar 4 escenarios diferentes:

```
a. Ejecuta la parte 1: prueba si el contador funciona, obtiene la potencia consumida por los contadores para 500, 1000, 2000 y 5000 sumas con 3 semillas diferentes, obtiene el retardo de los componentes.

b. Ejecuta la parte 2: se cambian los retardos de las compuertas definidas en la biblioteca y se ejecutan las mismas pruebas de la parte 1.

c. Ejecuta la parte 3: se cambia el diseño del contador de rizado y se ejecutan las mismas pruebas de la parte 1.

d. Elimina los ejecutables creados.

```

La forma de ejecutar cada escenario se muestra a continuación:

```
a. $ make parte1    
b. $ make parte2
c. $ make parte3
d. $ make clean
```

Cada simulación (excepto make clean) creará una carpeta "bin" en la raíz, ahí podrá ejecutar los archivo vcd por aparte si así lo desea (el Makefile lo hace automáticamente de todos modos), los resultados también se imprimirán en la terminal.


## Bibliotecas y/o programas necesarios
```
1. Icarus verilog 
2. GTKwave
3. Ubuntu (creado en Ubuntu 18.04)
4. Algún programa que permita leer PDF
```

## II-2020