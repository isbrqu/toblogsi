+++
title = '97. ¿Cómo puedo determinar si un enlace simbólico está colgado (roto)?'
date = 2023-10-01T05:55:47-03:00
draft = false
+++

La documentación sobre esto es confusa, pero resulta que puedes hacer
esto con las funciones integradas del shell:

```bash
# Bash
if [[ -L $name && ! -e $name ]]
then echo "$name is a dangling symlink"
fi
```

La página de manual de Bash le indica que `-L` devuelve "Verdadero si
el archivo existe y es un enlace simbólico" y `-e` devuelve "Verdadero
si el archivo existe". Lo que quizás no quede claro es que `-L`
considera que "archivo" es el enlace en sí. Sin embargo, para `-e`,
"archivo" es el destino del enlace simbólico (lo que sea que apunte el
enlace). Es por eso que necesitas ambas pruebas para ver si un enlace
simbólico está colgando; `-L` verifica el enlace en sí y `-e` verifica
lo que apunta el enlace.

POSIX tiene estas mismas pruebas, con semántica similar, por lo que si
por alguna razón no puede usar el [comando (preferido)
`[[`](../031-evaluacion-logica), se puede realizar la misma prueba
usando el comando más antiguo `[`:

```sh
# POSIX
if [ -L "$name" ] && [ ! -e "$name" ]
then echo "$name is a dangling symlink"
fi
```
