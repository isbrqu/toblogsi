+++
title = '107. ¿Cómo agrego una timestamp a cada línea de una stream?'
date = 2023-10-01T07:49:49-03:00
draft = false
+++

Agregar marcas de tiempo a una transmisión es un desafío, porque no
existen herramientas estándar para hacerlo. Debe instalar algo
específicamente para ello (por ejemplo, `ts` de [moreutils](#) o
[multilog](#) de daemontools) o escribir un filtro en algún lenguaje
de programación.  Idealmente, no deseas bifurcar un comando de
`date(1)` para cada línea de entrada que estás registrando, porque es
demasiado lento. Quieres utilizar funciones integradas. Las versiones
anteriores de bash _no pueden hacer esto_. Necesita al menos Bash 4.2
para la opción `printf %(...)T`. De lo contrario, podrías escribir
algo en Perl, Python, Tcl, etc. para leer líneas y escribirlas con
marcas de tiempo.
