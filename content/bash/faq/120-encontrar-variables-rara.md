+++
title = '120. ¿Cómo puedo saber de dónde vino esta extraña variable en mi shell interactivo?'
date = 2023-10-01T12:11:12-03:00
draft = false
+++

Algunas variables las establecen programas que se ejecutan antes de
bash, y estas preguntas frecuentes no pueden ayudarle con ellas. Para
las variables que establece bash leyendo un [dotfile](), si no
es root, puede usar el modo de seguimiento de bash:

```bash
$ PS4='+ $BASH_SOURCE:$FUNCNAME:$LINENO:' bash -lxc : 2>&1 | grep CVS_RSH
+ /home/greg/.profile::44:export CVS_RSH=ssh
+ /home/greg/.profile::44:CVS_RSH=ssh
```

En este ejemplo, la variable que estábamos buscando es `CVS_RSH` y se
establece en `/home/greg/.profile` en la línea 44. La misma técnica se
puede utilizar para rastrear cualquier cosa que provenga de un archivo
de puntos: alias, funciones. , configuraciones de compras no deseadas,
etc.

Esto no funcionará si eres root, al menos no en bash 4.3 o posterior,
porque esas versiones de bash se niegan a respetar una variable
heredada de PS4 cuando se ejecuta como root, por razones de seguridad.
PS4 puede contener sustituciones de comandos, que se ejecutarían tras
la expansión.
