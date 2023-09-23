+++
title = '003 - ¿Cómo puedo comparar archivos basado en algún atributo de metadato (última modifiación, tamaño, etc.)?'
date = 2023-09-23T08:40:04-03:00
draft = true
+++

La solución tentadora es usar `ls` para generar nombres de archivos
ordenados y operar con los resultados usando, por ejemplo, `awk`. Como
es habitual, el enfoque ls no [puede hacerse robusto](#) y nunca debe
usarse en scripts debido en parte a la posibilidad de que haya
caracteres arbitrarios (incluidas nuevas líneas) presentes en los
nombres de archivos. Por lo tanto, necesitamos alguna otra forma de
comparar los metadatos de los archivos.
