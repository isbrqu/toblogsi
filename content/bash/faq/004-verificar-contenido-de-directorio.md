+++
title = '004 - ¿Cómo puedo verificar si un directorio está vacío o no? ¿Cómo puedo comprobar si hay archivos *.mpg o contar cuantos hay?'
date = 2023-09-23T08:49:46-03:00
draft = false
+++

En bash, puedes contar archivos de forma segura y sencilla con las
opciones `nullglob` y `dotglob` (que cambian el comportamiento del
[globbing](#)), y un array.
