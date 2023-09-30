+++
title = '49. ¿Cómo puedo ver actualizaciones/anexos periódicos a un archivo? (por ejemplo: archivo de registro en crecimiento)'
date = 2023-09-30T13:43:16-03:00
draft = false
+++

`tail -f` le mostrará el archivo de registro en crecimiento. En algunos
sistemas (por ejemplo, _OpenBSD_), esto rastreará automáticamente un
archivo de registro rotado hasta el nuevo archivo con el mismo nombre
(que suele ser el que usted desea). Para obtener la funcionalidad
equivalente en sistemas GNU, utilice `tail -F` en su lugar.
