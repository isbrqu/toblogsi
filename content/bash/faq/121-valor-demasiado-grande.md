+++
title = '121. ¿Qué significa valor demasiado grande para base? (Valores octales en aritmética).'
date = 2023-10-01T12:14:36-03:00
draft = false
+++

Al leer números de archivos o comandos y luego realizar operaciones
aritméticas con ellos, los ceros a la izquierda pueden causar un
problema:

```bash
$ echo $((09))
bash: 09: value too great for base (error token is "09")
```

Cuando se utiliza un valor relleno con ceros en un contexto
matemático, el valor se trata como octal (base 8). En el mejor de los
casos, aparece un mensaje de error, porque 8 y 9 son dígitos octales
no válidos. En el peor de los casos, no notarás el problema
inmediatamente, pero el programa fallará más tarde.

Este problema ocurre a menudo al leer componentes de hora y fecha,
porque comúnmente se rellenan con ceros hasta dos dígitos (por
ejemplo, 08:11:42 como hora o 2013-09-14 como fecha).

Hay dos soluciones simples a este problema: eliminar los ceros
iniciales o forzar a bash a tratar los valores como decimales (base
10). En la [página de expresiones aritméticas](#) se dan ejemplos,
explicaciones y algunas advertencias adicionales.

También vale la pena tomarse un momento para señalar que cuando lee
valores de una fuente externa y luego intenta realizar operaciones
aritméticas con ellos, la interpretación octal o hexadecimal no
deseada no es el único problema que puede encontrar. Un usuario
malintencionado también puede provocar la ejecución de código
arbitrario con valores especialmente diseñados.

```bash
$ a=42 b='x[$(date >&2)0]'
$ echo $((a + b))
Thu Apr 29 22:37:22 EDT 2021
42
```

Es importante realizar una [validación de
entrada](../54-validacion-de-numero-en-variable) básica en números que
provienen de fuentes no confiables. Asegúrate de que en realidad sean
números antes de usarlos. Las fuentes confiables como el comando
`date(1)` con opciones como `+%m` o `+%H` están a salvo de
vulnerabilidades de inyección de código, por lo que solo debes
preocuparte por los ceros iniciales en esos casos.
