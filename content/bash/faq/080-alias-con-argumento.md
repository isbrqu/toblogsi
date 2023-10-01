+++
title = '80. ¿Cómo puedo crear un alias que acepte un argumento?'
date = 2023-10-01T03:36:54-03:00
draft = false
+++

No puedes. Los alias en bash son extremadamente rudimentarios y no son
realmente adecuados para ningún propósito serio. La página de manual
de bash incluso lo dice explícitamente:

{{< quote source="6.6 Aliases" url="https://www.gnu.org/software/bash/manual/html_node/Aliases.html" >}}
There is no mechanism for using arguments in the replacement text, as in csh. If arguments are needed, use a shell function (see Shell Functions).
{{< /quote >}}

Utilice una función en su lugar. Por ejemplo,

```bash
settitle() {
  case "$TERM" in *xterm*|*rxvt*)
    printf '\e]2;%s\a' "$1"
  esac
}
```

Ah, por cierto: **los alias no están permitidos en los scripts. Sólo
están permitidos en shells interactivos**, y eso se debe simplemente a
que los usuarios llorarían demasiado si se eliminaran por completo. Si
estás escribiendo un script, utiliza _siempre_ una función.
