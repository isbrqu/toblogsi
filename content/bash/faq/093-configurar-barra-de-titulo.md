+++
title = '93. ¿Cómo puedo configurar el contenido de la barra de título de mi terminal?'
date = 2023-10-01T05:41:59-03:00
draft = false
+++

Si tiene una terminal que comprende secuencias de escape compatibles
con xterm y solo desea configurar el título una vez, puede usar una
función como esta:

```bash
settitle() { printf '\e]2;%s\a' "$*"; }
```

Si desea configurar la barra de título en la línea de comando que se
está ejecutando actualmente cada vez que escribe un comando, esta
solución se aproxima a ello:

```bash
trap 'printf "\e]2;%s\a" "$(HISTTIMEFORMAT= history 1)" >/dev/tty' DEBUG
```

Sin embargo, deja el número del historial de comandos en su lugar y no
se activa en subshells explícitas como `(cd foo && make)`.

O para usar sólo el nombre y los argumentos del comando simple actual:

```bash
trap 'printf "\e]2;%s\a" "$BASH_COMMAND" >/dev/tty' DEBUG
```

Para shells compatibles con Posix que no reconocen `\e` como una
secuencia de caracteres para interpretarla como `Escape`, se puede
sustituir por `\033`.
