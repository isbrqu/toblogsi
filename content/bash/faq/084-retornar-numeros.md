+++
title = '84. ¿Cómo devuelvo una cadena (o un número grande o un número negativo) de una función? "return" sólo me permite dar un número del 0 al 255.'
date = 2023-10-01T04:02:04-03:00
draft = false
+++

Las funciones en Bash (así como todos los demás shells de la familia
Bourne) funcionan como comandos: es decir, sólo "retornan" un estado
de salida, que es un número entero de 0 a 255 inclusive. Está
destinado a usarse únicamente para señalar errores, no para devolver
los resultados de los cálculos u otros datos.
