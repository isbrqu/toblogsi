+++
title = '9. ¿Qué es el almacenamiento en buffer? O, ¿por qué mi línea de comando no produce ningún output? tail -f logfile | grep "barra foo" | awk ...'
date = 2023-09-23T09:23:43-03:00
draft = false
+++

La mayoría de los comandos estándar de Unix amortiguan su salida
cuando se usan de forma no interactiva. Esto significa que no escriben
cada carácter (o incluso cada línea) inmediatamente, sino que
recopilan una mayor cantidad de caracteres (a menudo 4 kilobytes)
antes de imprimir cualquier cosa. En el caso anterior, el comando
`grep` almacena en buffer su salida y, por lo tanto, `awk` solo
obtiene su entrada en grandes porciones.
