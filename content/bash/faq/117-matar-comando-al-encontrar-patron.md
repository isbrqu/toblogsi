+++
title = '117. Tengo una canalización donde un comando de larga duración alimenta un filtro. Si el filtro encuentra "foo", quiero que muera el comando de ejecución prolongada.'
date = 2023-10-01T11:49:48-03:00
draft = false
+++

En general esto no es posible, porque los procesos hermanos (dos hijos
del mismo padre) no se conocen entre sí. Pero considere el siguiente
ejemplo y respuestas:

Supondremos la siguiente canalización, que utiliza el programa
inotifywait de Linux:

```bash
inotifywait -m --format '%e %f' uploads |
while read -r events file; do
  if [[ $events = *MOVED_TO* ]]; then
    : do something special
    if [[ $file = *abort* ]]; then
      : special sentinel file found
      : want to kill the inotifywait process
    fi
  fi
done
```

En este ejemplo, el usuario desea detener el programa `inotifywait` si
se realiza un cambio de nombre con el nombre de archivo resultante que
contiene la cadena "abort". ¿Cuáles son nuestras opciones aquí?

- Simplemente salga del bucle while y no intente hacer nada
  explícitamente para `inotifywait`. El proceso de shell que contiene el
  bucle while finalizará y el proceso `inotifywait` continuará
  ejecutándose. Tan pronto como `inotifywait` intente escribir otra
  línea de salida en la tubería (que ha sido cerrada), recibirá una
  señal `SIGPIPE`, que la terminará.
- Encuentre una opción dentro del proceso de alimentación para salir
  cuando suceda algo malo, en lugar de depender de un filtro externo
  para que lo haga por usted. (Esto sólo será posible con ciertos
  programas alimentadores, pero vale la pena tomarse el tiempo para
  leer la documentación y ver si es posible).
- Reemplace la canalización anónima con una FIFO y ejecute
  explícitamente el alimentador como proceso en segundo plano. Guarde
  su PID. Espere a que salga el filtro y, cuando lo haga, finalice el
  proceso de alimentación de larga duración. De este modo:

```bash
filter() {
  while read -r events file; do
    : ...
  done
}

fifo="${TMPDIR:-${XDG_RUNTIME_DIR:-/tmp}}//fifo.$$"
trap 'rm -rf -- "$fifo"' EXIT
mkfifo -- "$fifo" || exit

inotifywait -m --format '%e %f' uploads > "$fifo" & pid=$!
filter < "$fifo"
kill -- "$pid"
wait
```
