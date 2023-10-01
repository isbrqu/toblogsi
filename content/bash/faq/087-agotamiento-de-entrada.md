+++
title = '89. Estoy leyendo un archivo línea por línea y ejecutando ssh o ffmpeg, ¡solo se procesa la primera línea!'
date = 2023-10-01T04:21:26-03:00
draft = false
+++

Al [leer un archivo línea por línea](../001-leer-un-archivo), si un comando dentro del bucle
también lee stdin, puede agotar el archivo de entrada. Por ejemplo:

```bash
# Non-working example
while IFS= read -r file; do
  ffmpeg -i "$file" -c:v libx264 -c:a aac "${file%.avi}".mkv
done < <(find . -name '*.avi')
```

```bash
# Non-working example
while read host; do
  ssh "$host" some command
done < hostslist
```

¿Que esta pasando aqui? Tomemos el primer ejemplo. `read` lee una línea
de la entrada estándar (FD 0), la coloca en el parámetro del archivo y
luego se ejecuta `ffmpeg`. Como cualquier programa que ejecute desde
BASH, `ffmpeg` hereda la entrada estándar, que por alguna razón lee. No
sé por qué. Pero en cualquier caso, cuando `ffmpeg` lee la entrada
estándar, absorbe toda la entrada del comando `find`, matando el
ciclo.

Utilice la opción global `-nostdin` en `ffmpeg` para deshabilitar la
interacción en la entrada estándar:

```bash
while IFS= read -r file; do
  ffmpeg -nostdin -i "$file" -c:v libx264 -c:a aac "${file%.avi}".mkv
done < <(find . -name '*.avi')
```

Alternativamente, puedes usar la [redirección](#) al final de la línea
`ffmpeg`: `</dev/null`. El ejemplo de ssh se puede arreglar de la
misma manera, o con el modificador `-n` (al menos con [OpenSSH](#)).

A veces, con bucles grandes, puede ser difícil determinar qué se lee
en la entrada estándar, o un programa puede cambiar su comportamiento
cuando le agrega `</dev/null`. En este caso, puede hacer que la
lectura utilice un FileDescriptor diferente del que es menos
probable que lea un programa aleatorio:

```bash
while IFS= read -r line <&3; do
  ...
done 3< file
```

En bash, también se le puede indicar a la función de lectura
incorporada que lea directamente desde un fd (`-u fd`) sin redirección,
y desde bash 4.1, se puede asignar un fd disponible (`{var}<file`) en
lugar de codificar un descriptor de archivo.

```bash
# bash 4.1+
while IFS= read -r -u "$fd" line; do
  ...
done {fd}< file
exec {fd}<&-
```
