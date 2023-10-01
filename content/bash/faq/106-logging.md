+++
title = '106. Logging! Quiero enviar toda la salida de mi script a un logfile. Pero quiero hacerlo desde dentro del script. ¡Y quiero verlo en la terminal también!'
date = 2023-10-01T07:45:30-03:00
draft = false
+++

Normalmente, si desea ejecutar un script y enviar su salida a un
logfile, simplemente usará [Redirección](#): `myscript >log 2>&1`. O
para ver el resultado en la pantalla y también redirigir a un archivo:
`myscript 2>&1 | tee log` (o mejor aún, ejecute su script dentro del
comando `script(1)` si su sistema lo tiene; el script está diseñado para
usarse con sesiones de shell interactivas). Si desea insertar comandos
en un script que hagan que realice este tipo de registro internamente,
sin alterar su invocación, entonces se vuelve más complicado.
