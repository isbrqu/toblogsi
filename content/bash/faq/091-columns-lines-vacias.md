+++
title = '91. Estoy intentando obtener el número de columnas o líneas de mi terminal pero las variables COLUMNS/LINES siempre están vacías'
date = 2023-10-01T05:14:36-03:00
draft = false
+++

BASH establece COLUMNS y LINES en modo interactivo; no están
disponibles de forma predeterminada en un script. En la mayoría de los
sistemas, puedes intentar consultar a la terminal tu mismo:

```bash
unsup() { echo "Your system doesn't support retrieving $1 with tput.  Giving up." >&2; exit 1; }
COLUMNS=$(tput cols) || unsup cols
LINES=$(tput lines) || unsup lines
```

Bash actualiza automáticamente las variables `COLUMNS` y `LINES` cuando
se cambia el tamaño de un shell interactivo. Si está configurando las
variables en un script y desea que se actualicen cuando se cambia el
tamaño del terminal, es decir, al recibir un `SIGWINCH`, puede
configurar un [`trap`](#) usted mismo:

```bash
trap 'COLUMNS=$(tput cols) LINES=$(tput lines)' WINCH
```

También puedes configurar el shell como interactivo en el shebang del
script:

```bash
#!/bin/bash -i
echo $COLUMNS
```

Sin embargo, esto tiene algunos inconvenientes:

- Aunque no es la mejor práctica, no es poco común que los scripts
  prueben la opción `-i` para determinar si un shell es interactivo y
  luego lo cancelen o se comporten mal. No existe una forma
  completamente infalible de comprobar esto, por lo que algunos
  scripts pueden fallar como resultado.
- Al ejecutarse con `-i` se genera `.bashrc` y se establecen varias
  opciones, como el control de trabajos, que pueden tener efectos
  secundarios no deseados.

Aunque técnicamente puedes configurar `-i` en medio de un script, no
tiene ningún efecto en la configuración de `COLUMNS` y `LINES`. La
opción `-i` debe configurarse cuando se invoca a Bash por primera vez.

Normalmente Bash actualiza `COLUMNS` y `LINES` cuando su terminal envía
una señal `SIGWINCH`, indicando un cambio de tamaño. Es posible que
algunos terminales no hagan esto, por lo que si sus variables no se
actualizan incluso cuando ejecuta un shell interactivo, intente usar
`shopt -s checkwinsize`. Esto hará que Bash consulte la terminal después
de cada comando, así que úselo solo si es realmente necesario.

`tput`, por supuesto, requiere una terminal. Según _POSIX_, si
`stdout` no es un tty, los resultados no se especifican y `stdin` no
se utiliza, aunque algunas implementaciones pueden intentar usarlo de
todos modos.  En OpenBSD, Gentoo y Debian Linux (y aparentemente al
menos en otros Linux), al menos uno de `stdout` o `stderr` debe ser un
tty, o `tput` simplemente devuelve algunos valores predeterminados:

```sh
linux$ tput -S <<<$'cols\nlines' 2>&1 | cat
80
24

openbsd$ tput cols lines 2>&1 | cat
80
24
```
