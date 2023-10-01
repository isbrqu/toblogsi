+++
title = '85. ¿Cómo escribir varias veces a un fifo sin tener que volver a abrirlo?'
date = 2023-10-01T04:05:06-03:00
draft = false
+++

En el caso general, abrirá un nuevo [FileDescriptor (FD)](#) que
apunta al fifo y escribirá a través de él. Para casos simples, es
posible omitir ese paso.
