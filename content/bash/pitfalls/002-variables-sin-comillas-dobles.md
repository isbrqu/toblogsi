+++
title = '2. cp $file $target'
date = 2023-12-21T00:00:00-00:00
draft = false
+++

¿Qué pasa con el comando que se muestra arriba? Bueno, nada, _si_ sabes de antemano que `$file` y `$target` no tienen espacios en blanco (y no has modificado `$IFS`, y puedes garantizar que el código no se llamó en un contexto donde `$IFS` puede haber sido modificado) o [comodines](#glob) en ellos. Sin embargo, los resultados de las expansiones todavía están sujetos a [WordSplitting](#WordSplitting) y [pathname expansion](#glob). Siempre coloque comillas dobles en las expansiones de parámetros.

```bash
cp -- "$file" "$target"
```

Sin las comillas dobles, obtendrá un comando como `cp 01 - Don't Eat the Yellow Snow.mp3 /mnt/usb`, lo que generará errores como `cp: cannot stat '01': No such file or directory`. Si `$file` tiene comodines (`*`, `?` o `[`), se [expandirán](#glob) si hay archivos que coincidan con ellos. Con las comillas dobles, todo está bien, a menos que `"$file"` comience con -, en cuyo caso `cp` cree que está intentando darle opciones de línea de comando (consulte el [error n° 3](../003-nombres-de-archivos-con-guiones-iniciales) a continuación).

Incluso en la circunstancia algo poco común de que pueda garantizar el contenido de la variable, es convencional y una buena práctica [quote](#Quotes) expansiones de parámetros, especialmente si contienen nombres de archivos. Los programadores experimentados de scripts siempre usarán [quotes](#Quotes) excepto quizás en un pequeño número de casos en los que es _absolutamente_ obvio desde el contexto inmediato del código que un parámetro contiene un valor seguro garantizado. Lo más probable es que los expertos consideren que el comando `cp` del título siempre es incorrecto. Tu también deberías.

[Página original](http://mywiki.wooledge.org/BashPitfalls#cp_.24file_.24target)