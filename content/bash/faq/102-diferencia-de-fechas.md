+++
title = '102. Cómo obtener la diferencia entre dos fechas'
date = 2023-10-01T06:27:16-03:00
draft = false
+++

Es mejor si trabaja con marcas de tiempo en todo su código y luego
solo convierte las marcas de tiempo a formatos legibles por humanos
para la salida. Si debe manejar fechas legibles por humanos como
entrada, necesitará algo que pueda analizarlas.

Usando la fecha GNU, por ejemplo:

```bash
# get the seconds passed since Jan 1, 2010 (local-time)
then=$(date -d "2014-10-25 00:00:00" +%s)
now=$(date +%s)
echo $(($now - $then))

# To avoid "Daylight Saving Time" aka "Daylight Savings Time", "DST" or "Summer Time"
# and/or Local time adjustments,
# is better to use UTC time:
then=$(date -u -d "2014-10-25 00:00:00" +%s)
now=$(date -u +%s)
echo $(($now - $then))
```

Para imprimir una duración como un valor legible por humanos (dentro
de 365 días - 1 año), use la capacidad de fecha para sumar y restar
tiempo:

```bash
date -u -d "2014-01-01 $now sec - $then sec" +"%j days %T"
```

O, un poco más explícito:

```bash
date -u -d "2014-01-01 $now sec - $then sec" +"%j days %H hours %M minutes and %S seconds"
```

Para imprimir una duración superior a un año, deberá realizar algunos
cálculos adicionales externos.

El concepto podría extenderse a nanosegundos, así:

```bash
then=$(date -u -d "2014-10-25 00:00:00" +"%s.%N")
now=$(date -u +"%s.%N")
date -u -d "2014-01-01 $now sec - $then sec" +"%j days %T.%N"

# will print:      046 days 21:03:50.296901858
```

Para convertir la marca de tiempo nuevamente a una fecha legible por
humanos, usando la fecha reciente de GNU:

```bash
date -d "@$now"
```

Consulte la [pregunta frecuente 70](../070-tiempo-unix-a-humano) para obtener más información
sobre cómo convertir marcas de tiempo de Unix en fechas legibles por
humanos.
