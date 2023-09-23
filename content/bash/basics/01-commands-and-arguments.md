+++
title = '01 - Comandos y argumentos'
date = 2023-09-18T00:43:06-03:00
tags = ['bash']
draft = false
+++

BASH lee comandos de su entrada (que suele ser una terminal o un
archivo). Cada linea de entrada que lee es tratada como un comando --
una instrucción para ser llevado a cabo. Hay pocos casos avanzados,
como comandos que ocupan varias líneas, que serán tratadas después.

Bash divide cada linea entre _palabras_ que son demarcadas por un
caracter en blaco (espacios o tabuladores). La primera palabra de la
linea es el nombre del comando para ser ejecutado. Todas las palabras
restantes seran _argumentos_ para ese comando (options, filenmaes,
etc.).

Asumiendo que estamos en un directorio vacio... (probar estos
comandos, crear un directorio vacío llamado _test_ y entrar a ese
directorio para correr: `mkdir test; cd test`):

```bash
$ ls     # Lista los archivos in el actual directorio (sin salida, sin archivos).
$ touch  # Crea los archivos 'a', 'b' y 'c'.
$ ls     # Lista los archivos de nuevo, y esta vez muestra: 'a', 'b' y 'c'.
a b c
```

El comando `ls` imprime los nombres de los archivos en el directorio
actual. La primera vez que corremos la lista de comandos no obtenemos
salida, porque no hay archivos todadavía.

El caracter `#` al principio de una palabra indica un comentario.
Cualquier palabra seguida del comentario son ignoradas por la shell,
destinado solo para leer. Si corremos el ejemplo en nuestra shell, no
tenemos que tipear los comentarios; pero incluso si lo hacemos, el
comando seguirá funcionando.

El comando `touch` es una aplicación que cambia el dato de la _última
modificación_ de un archivo. Si el nombre del archivo que se
proporciona aún no existe, crea un nuevo archivo vacío y con ese
nombre.
