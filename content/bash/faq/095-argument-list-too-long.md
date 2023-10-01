+++
title = '95. Aparece el mensaje "Argument list too long". ¿Cómo puedo procesar una lista grande en trozos?'
date = 2023-10-01T05:50:37-03:00
draft = false
+++

Primero, revisemos algunos antecedentes. Cuando un proceso quiere
ejecutar otro proceso, `fork()`s a un hijo, y el hijo llama a una de
la familia `exec*` de llamadas al sistema (por ejemplo, `execve()`),
proporcionando el nombre o la ruta del archivo de programa del nuevo
proceso; el nombre del nuevo proceso; la lista de argumentos para el
nuevo proceso; y, en algunos casos, un conjunto de variables de
entorno. De este modo:
