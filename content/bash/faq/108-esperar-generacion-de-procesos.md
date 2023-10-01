+++
title = '108. ¿Cómo espero a que se generen varios procesos?'
date = 2023-10-01T07:54:31-03:00
draft = false
+++

Hay numerosas formas de hacer esto, pero todas están limitadas por las
herramientas disponibles. Se me han ocurrido las siguientes
soluciones.

Si desea esperar a _todos_ sus hijos, simplemente llame a `wait` sin
argumentos.

Si solo desea esperar algunos, pero no todos, y no le importa su
estado de salida, puede llamar a `wait` con varios PID:

```bash
wait $pid1 $pid2
```

Si necesita saber si los hijos tuvieron éxito o fracasaron, entonces
quizás:

```bash
waitall() { # PID...
  ## Wait for children to exit and indicate whether all exited with 0 status.
  local errors=0
  while :; do
    debug "Processes remaining: $*"
    for pid in "$@"; do
      shift
      if kill -0 "$pid" 2>/dev/null; then
        debug "$pid is still alive."
        set -- "$@" "$pid"
      elif wait "$pid"; then
        debug "$pid exited with zero exit status."
      else
        debug "$pid exited with non-zero exit status."
        ((++errors))
      fi
    done
    (("$#" > 0)) || break
    # TODO: how to interrupt this sleep when a child terminates?
    sleep ${WAITALL_DELAY:-1}
   done
  ((errors == 0))
}

debug() { echo "DEBUG: $*" >&2; }

pids=""
for t in 3 5 4; do
  sleep "$t" &
  pids="$pids $!"
done
waitall $pids
```

Pasar por `kill -0` puede ser muy ineficiente.
