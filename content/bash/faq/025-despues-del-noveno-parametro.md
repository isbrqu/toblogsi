+++
title = '25. ¿Cómo puedo acceder a los parámetros posicionales después de $9?'
date = 2023-09-27T21:47:29-03:00
draft = false
+++

Utilice `${10}` en lugar de `$10`. Esto funciona para [BASH](#) y [KornShell](#),
pero no para implementaciones anteriores de [BourneShell](#). Otra forma de
acceder a parámetros posicionales arbitrarios después de `$9` es
utilizar, por ejemplo, `for`. para obtener el último parámetro:
