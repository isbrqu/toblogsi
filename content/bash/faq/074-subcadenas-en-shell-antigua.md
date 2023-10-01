+++
title = '74. ¿Cómo obtengo los efectos de esas ingeniosas expansiones de parámetros de Bash en shells más antiguos?'
date = 2023-10-01T03:16:19-03:00
draft = false
+++

La mayoría de las formas extendidas de expansión de parámetros no
funcionan con el BourneShell anterior. Si su código también necesita
ser portátil a ese shell, a menudo se pueden usar `sed` y `expr`.
