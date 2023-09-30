+++
title = '55. Cuéntame todo sobre 2>&1: ¿cuál es la diferencia entre 2>&1 >foo y >foo 2>&1, y cuándo uso cuál?'
date = 2023-09-30T13:54:45-03:00
draft = false
+++

Bash procesa todas las redirecciones de izquierda a derecha, en orden.
Y el orden es significativo. Moverlos dentro de un comando puede
cambiar los resultados de ese comando.
