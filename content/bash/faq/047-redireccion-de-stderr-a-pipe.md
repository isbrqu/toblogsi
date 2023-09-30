+++
title = '47. ¿Cómo puedo redirigir stderr a una tubería?'
date = 2023-09-30T13:38:56-03:00
draft = false
+++

Una tubería solo puede transportar la salida estándar (`stdout`) de un
programa. Para canalizar el error estándar (`stderr`) a través de él,
debe redirigir stderr al mismo destino que stdout. Opcionalmente,
puede cerrar stdout o redirigirlo a `/dev/null` para obtener solo
stderr. Algún código de muestra:
