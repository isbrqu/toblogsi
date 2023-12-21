+++
title = '3. Nombres de archivos con guiones iniciales'
date = 2023-12-21T00:00:00-00:00
draft = false
+++

## El error: Interpretar nombre como opción

Los nombres de archivos con guiones al principio pueden causar muchos problemas. Los [globs](#glob) como `*.mp3` se ordenan en una lista expandida (según su [locale](#locale) actual) y `-` se ordena antes de las letras en la mayoría de las configuraciones regionales. Luego, la lista se pasa a algún comando, que puede interpretar incorrectamente `"-filename"` como una opción. Hay dos soluciones principales para esto.

## Solución 1: Agregar doble guión al comando

Una solución es insertar `--` entre el comando (como `cp`) y sus argumentos. Eso le indica que deje de buscar opciones y todo estará bien:

```bash
cp -- "$file" "$target"
```

Hay problemas potenciales con este enfoque. Debe asegurarse de insertar `--` para _cada_ uso del parámetro en un contexto donde posiblemente pueda interpretarse como una opción, lo cual es fácil de pasar por alto y puede implicar mucha redundancia.

La mayoría de las bibliotecas de análisis de opciones bien escritas entienden esto, y los programas que las usan correctamente deberían heredar esa característica de forma gratuita. Sin embargo, tenga en cuenta que, en última instancia, depende de la aplicación reconocer el "fin de opciones". Es posible que algunos programas que analizan opciones manualmente, lo hacen incorrectamente o utilizan bibliotecas de terceros deficientes que no lo reconozcan. Las utilidades estándar "deberían", con algunas excepciones especificadas por POSIX. `echo` es un ejemplo.

## Solución 2: Agregar ruta al archivo

Otra opción es asegurarse de que los nombres de sus archivos siempre comiencen con un directorio utilizando nombres de ruta relativos o absolutos.

```bash
for i in ./*.mp3; do
    cp "$i" /target
    # ...
done
```
En este caso, incluso si tenemos un archivo cuyo nombre comienza con `-`, el glob se asegurará de que la variable siempre contenga algo como `./-foo.mp3`, lo cual es perfectamente seguro en lo que respecta a `cp`.

Finalmente, si puede garantizar que todos los resultados tendrán el mismo prefijo y solo usan la variable unas pocas veces dentro del cuerpo de un bucle, simplemente puede concatenar el prefijo con la expansión. Esto proporciona un ahorro teórico en la generación y almacenamiento de algunos caracteres adicionales para cada palabra.

```bash
for i in *.mp3; do
    cp "./$i" /target
    # ...
done
```

[Página original](http://mywiki.wooledge.org/BashPitfalls#Filenames_with_leading_dashes)