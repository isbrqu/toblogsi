+++
title = '31. ¿Cuál es la diferencia entre test, [ y [[ ?'
date = 2023-09-29T00:50:40-03:00
draft = false
+++

El comando de corchete abierto `[` (también conocido `test`) y la
construcción de prueba `[[ ... ]]` se utilizan para evaluar
expresiones. Esta ultima funciona solo en el shell Korn (donde se origina), Bash,
Zsh y versiones recientes de Yash y Busybox `sh` (si está habilitado
en el momento de la compilación, y aún es muy limitado allí,
especialmente en la variante basada en `hush`), y es más
poderoso; `[` y `test` son utilidades POSIX (generalmente integradas).

POSIX no especifica la construcción `[[ ... ]]` (que tiene una
sintaxis específica con variaciones significativas entre
implementaciones) aunque permite que los shells traten `[[` como una
palabra clave. Aquí hay unos ejemplos:
