+++
title = '42. ¿Cómo puedo saber si un proceso aún está en ejecución?'
date = 2023-09-29T01:18:19-03:00
draft = false
+++

El comando `kill` se utiliza para enviar señales a un proceso en
ejecución. Convenientemente, la señal `0`, que no existe, se puede
utilizar para saber si un proceso todavía está en ejecución:
