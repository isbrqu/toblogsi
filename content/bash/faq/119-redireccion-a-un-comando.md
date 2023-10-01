+++
title = '119. ¿Cuál es la diferencia entre "cmd <archivo" y "archivo cat | cmd"? ¿Qué es un UUOC?'
date = 2023-10-01T11:57:05-03:00
draft = false
+++

La mayoría de las veces, estos comandos hacen lo mismo, pero el segundo es menos eficiente y también falla en determinadas circunstancias excepcionales.

Suponiendo que `cmd` no es una función, una palabra clave incorporada o
especial de la shell, el primer comando `cmd < file` funciona así:

- La shell bifurca un [SubShell](#).
- Dentro del subshell, la entrada estándar se cierra y se vuelve a
  abrir usando un archivo en modo de solo lectura.
- El subshell ejecuta `cmd`, reemplazándose con el nuevo comando, que
  presumiblemente lee el archivo.
- El padre espera a que termine el subshell y luego continúa
  normalmente.

El segundo comando `cat file | cmd` funciona así:

- La shell bifurca dos subshells y crea una tubería anónima.
- La tubería está conectada de una subshell a la otra.
- La primera subshell ejecuta `cat` con `file` como argumento. `cat` abre el
  archivo y copia su contenido en la tubería.
- La segunda subshell ejecuta `cmd`, que presumiblemente lee desde la
  tubería.
- Cuando ambas subshells han terminado, el padre continúa
  normalmente.

Entonces, ya podemos ver por qué el segundo comando es menos
eficiente: introduce un proceso adicional, además de la canalización
anónima.

Otra diferencia es que en el primer comando, la entrada estándar de
cmd es un descriptor de archivo que apunta a un archivo real. El
comando puede rebobinar o buscar una ubicación diferente en el
archivo. Sin embargo, en el segundo comando, la entrada estándar de
cmd es una canalización anónima, no un archivo real. El comando sólo
puede leer la entrada secuencialmente como un flujo de bytes; no puede
rebobinarlo, ni saltar hacia adelante o hacia atrás.

Por lo tanto, los comandos que esperan una entrada estándar buscable
se interrumpirán al utilizar el segundo comando. Esto es raro, pero
sucede a veces.

En algunas circunstancias, el segundo comando también es más lento. Si
`cmd` resulta ser un bucle `while read` implementado en el shell, el
shell se ve [obligado a utilizar lecturas de un solo
byte](https://lists.gnu.org/archive/html/bug-bash/2020-06/msg00045.html), en
lugar de lecturas almacenadas en el búfer.

## ¿Qué es un UUOC?

UUOC es un acrónimo (o inicial, para los británicos) que significa
_Useless Use Of Cat_. Es un término informal utilizado para describir
el uso inadecuado de `cat file | cmd`.

Entre los círculos de programadores competentes, cuando un recién
llegado hace algo ineficiente o incorrecto, los demás normalmente
intentan ayudar a esa persona señalándole el error y mostrándole el
camino correcto. En algunos grupos de Usenet, esto se convirtió en una
tradición: al recién llegado se le "presentaba" un [premio satírico
UUOC](https://porkmail.org/era/unix/award#cat), una especie de
insignia de logro.

Lamentablemente, algunas personas no aprecian la ayuda que les brindan
y ven la crítica constructiva como mera crítica. Ver también: [filtro
de tacto](http://www.mit.edu/~jcb/tact.html).
