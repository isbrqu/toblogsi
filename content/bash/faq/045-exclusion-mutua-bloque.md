+++
title = '45. ¿Cómo puedo garantizar que solo se ejecute una instancia de un script a la vez (exclusión mutua, bloqueo)?'
date = 2023-09-30T13:34:23-03:00
draft = false
+++

Necesitamos algunos medios de exclusión mutua. Una forma es utilizar
un "lock": cualquier número de procesos pueden intentar adquirir el
bloqueo simultáneamente, pero sólo uno de ellos tendrá éxito.
