+++
title = '90. ¿Cómo antepongo un texto a un archivo (lo opuesto a >>)?'
date = 2023-10-01T04:59:23-03:00
draft = false
+++

No puedes hacerlo solo con redirecciones de bash; lo contrario de `>>`
no existe....

Para insertar contenido al principio de un archivo, puede utilizar un
editor, por ejemplo, `ex`:

```bash
ex file << EOF
0a
header line 1
header line 2
.
w
EOF
```

or [`ed`](https://web.archive.org/web/20221202173000/https://wiki.bash-hackers.org/howto/edit-ed):

```bash
printf '%s\n' 0a "line 1" "line 2" . w | ed -s file
```

`ex` también agregará un carácter de nueva línea al final del archivo si falta.

O puedes reescribir el archivo, usando cosas como:

```bash
{ echo line; cat file ;} >tmpfile && mv tmpfile file
echo line | cat - file > tmpfile && mv tmpfile file
```

Algunas personas insisten en usar el `sed` martillo para clavar todos
los tornillos:

```bash
sed "1iTEXTTOPREPEND" filename > tmp &&
mv tmp filename
```

También hay muchas otras soluciones.
