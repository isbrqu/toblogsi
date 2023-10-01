+++
title = '78. Quiero establecer la contraseña de un usuario usando el comando passwd de Unix, pero ¿cómo puedo programarlo? ¡No lee la entrada estándar!'
date = 2023-10-01T03:32:58-03:00
draft = false
+++

Bien, antes que nada, sé que habrá algunas personas leyendo esto ahora
mismo que ni siquiera entenderán la pregunta. Aquí esto no funciona:

```bash
{ echo oldpass; echo newpass; echo newpass; } | passwd
# Esto NO FUNCIONA!
```
