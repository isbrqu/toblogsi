+++
title = '115. ¿Cómo hago un menú?'
date = 2023-10-01T08:19:20-03:00
draft = false
+++

A algunas personas les gusta usar `select` porque es simple. Si sus
necesidades son extremadamente simples, entonces esto puede ser
suficiente para usted. Si desea su propia apariencia, simplemente
puede escribir un menú usted mismo. También está `dialog`, que no
cubriremos en esta página.

## Usando select

Para usar `select`, necesita una lista de opciones. `select` asignará
automáticamente números a las opciones y emitirá un mensaje. Puede
personalizar el mensaje.

```bash
$ PS3='¿Qué es más macho? '
$ select ch in schoolbus lightbulb; do echo "You have chosen $ch!"; break; done
1) schoolbus
2) lightbulb
¿Qué es más macho? 45
You have chosen !
$ select ch in schoolbus lightbulb; do echo "You have chosen $ch!"; break; done
1) schoolbus
2) lightbulb
¿Qué es más macho? 2
You have chosen lightbulb!
```

Si busca una selección "vacía" (no válida) dentro del bucle, entonces
se vuelve un poco menos horrible:

```bash
$ select ch in schoolbus lightbulb; do if [[ $ch ]]; then echo "You have chosen $ch!"; break; fi; done
1) schoolbus
2) lightbulb
¿Qué es más macho? 45
¿Qué es más macho? 0
¿Qué es más macho? 2
You have chosen lightbulb!
```

y eso es `select`. Hacia adelante...

## Escribiendo tu propio menu

Simplemente haz un bucle usando `echo` y lee. Es realmente así de
simple. En su lugar, vamos a darle vida creando una aplicación de menú
de varios niveles.

```bash
#!/bin/bash

main() {
  while true; do
    echo "== Make your selection:"
    echo "a) add"
    echo "s) subtract"
    echo "m) multiply"
    echo "q) quit"
    while true; do
      read -r -n1 -p "> " ch
      echo
      case $ch in
        a) add; break;;
        s) subtract; break;;
        m) multiply; break;;
        q) exit 0;;
        *) echo "Unrecognized command.  Please try again.";;
      esac
    done
  done
}

add() {
  local a b
  while true; do
    echo "== Addition"
    echo "Enter first addend, or q to return to main menu."
    read -r -p "> " a
    [[ $a = q ]] && return
    echo "Enter second addend."
    read -r -p "> " b
    echo "$a + $b = $((a + b))"
  done
}

# subtract and multiply functions not shown

main
```

Puedes hacerlo tan simple o tan complejo como quieras. Puede crear su
propia función de entrada para ajustar la lectura y persistir hasta
que el usuario escriba una respuesta sintácticamente válida. Puede
utilizar `read -e` para permitir que el usuario utilice las funciones
de edición de readline. Todo depende de ti.
