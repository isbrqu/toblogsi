+++
title = '62. ¿Cómo creo un archivo temporal de forma segura?'
date = 2023-09-30T14:14:55-03:00
draft = false
+++

No parece haber ningún comando único que simplemente funcione en todas
partes. `tempfile` no es portátil. `mktemp` existe más ampliamente (pero
aún no de manera ubicua), pero puede requerir un modificador `-c` para
crear el archivo por adelantado; o puede crear el archivo de forma
predeterminada y vomitar si se proporciona `-c`. Algunos sistemas no
tienen ninguno de los comandos (Solaris, POSIX). Se supone que los
sistemas POSIX tienen `m4`, que tiene la capacidad de crear un archivo
temporal, pero es posible que algunos sistemas no instalen `m4` de forma
predeterminada o que a su implementación de `m4` le falte esta
característica.
