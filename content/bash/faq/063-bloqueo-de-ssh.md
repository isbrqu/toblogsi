+++
title = '63. ¡Mi cliente ssh se bloquea cuando intento cerrar sesión después de ejecutar un trabajo remoto en segundo plano!'
date = 2023-09-30T14:17:48-03:00
draft = false
+++

Lo siguiente no hará lo que espera:

```bash
ssh me@remotehost 'sleep 120 &'
# El cliente se cuelga durante 120 segundos
```
