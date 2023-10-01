+++
title = '105. ¿Por qué set -e (o set -o errexit, o trap ERR) no hace lo que esperaba?'
date = 2023-10-01T07:42:46-03:00
draft = false
+++

`set -e` fue un intento de agregar "detección automática de errores"
al shell. Su objetivo era hacer que el shell se cancelara cada vez que
ocurriera un error, por lo que no es necesario poner `|| exit 1`
después de cada comando importante. Esto no funciona bien en la
práctica.
