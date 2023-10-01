+++
title = '112. ¿Cuáles son las ventajas y desventajas de usar set -u (o set -o nounset)?'
date = 2023-10-01T08:12:26-03:00
draft = false
+++

Bash (como todos los demás derivados del shell Bourne) tiene una
función activada por el comando `set -u` (o `set -o nounset`). Cuando esta
característica está vigente, cualquier comando que intente expandir
una variable no configurada provocará un error fatal (el shell se
cerrará inmediatamente, a menos que sea interactivo).


