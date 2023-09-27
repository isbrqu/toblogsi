+++
title = '1. Introducción'
date = 2023-09-24T23:26:38-03:00
draft = false
+++

## Caracteres permitidos

- a-z
- A-Z
- 0-9
- .+/\\\*~<>@%|&?
- blank, tab, cr, ff, lf

## Variables

- Las variables deben ser declaradas antes de usarse.
- Las variables compartidas deben comenzar con mayúsculas.
- Las variables locales deben comenzar con minúsculas.
- Nombres reservados: `nil`, `true`, `false`, `self`, `super` y
  `Smalltalk`.

## Scope de variable:

- Global: Definido en el Diccionario de Smalltalk y accesible para
  todos los objetos del sistema.
- Especial: (reservados) `Smalltalk`, `super`, `self`, `true`, `false`, y `nil`.
- Método temporal: Local a un método.
- Bloque temporal: Local a un bloque.
- Pool: Variables en un objeto diccionario.
- Parámetros del método: Variables locales automáticas creadas como
  resultado de una llamada de mensaje con parámetros
- Parámetros de bloque: Variables locales automáticas creadas como
  resultado del valor: Llamada de mensaje.
- Clase: Compartida con todas las instancias de una clase y sus
  subclases.
- Instancia de clase: Único para cada instancia de una clase.
- Variables de instancia: Únicas para cada instancia.

## Otros

- Los comentarios están encerrados en comillas dobles (`"`).
- Las sentencias entán separadas por un punto (`.`).
