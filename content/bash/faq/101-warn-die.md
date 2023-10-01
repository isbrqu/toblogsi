+++
title = '101. Funciones de utilidad comunes (warn, die)'
date = 2023-10-01T06:20:19-03:00
draft = false
+++

Si estaba buscando opciones de procesamiento, consulte la
[FAQ#035](../035-opciones-y-argumentos-en-scripts). Bash y sh no
ofrecen un comando integrado como lo hace Perl, pero es común usar una
función de `die` en los scripts. Sólo tienes que escribir uno tú
mismo. A la mayoría de las personas que escriben una función de dado
les gusta mantenerla simple. Hay dos variedades comunes: una que solo
toma un mensaje para imprimir y otra que toma un mensaje y un valor de
estado de salida.

```bash
# Usage: die message ...
die() {
  printf '%s\n' "$*" >&2
  exit 1
}
```

```bash
# Usage: die exit_status message ...
die() {
  rc=$1
  shift
  printf '%s\n' "$*" >&2
  exit "$rc"
}
```

A algunas personas les gustan las funciones más sofisticadas:

```bash
##
# warn: Print a message to stderr.
# Usage: warn "format" ["arguments"...]
#
warn() {
  local fmt=$1
  shift
  printf "script_name: $fmt\n" "$@" >&2
}

###
### The following three "die" functions
### depend on the above "warn" function.
###

##
# die (simple version): Print a message to stderr
# and exit with the exit status of the most recent
# command.
# Usage: some_command || die "message" ["arguments"...]
#
die () {
  local st=$?
  warn "$@"
  exit "$st"
}

##
# die (explicit status version): Print a message to
# stderr and exit with the exit status given.
# Usage: if blah; then die status_code "message" ["arguments"...]; fi
#
die() {
  local st=$1
  shift
  warn "$@"
  exit "$st"
}

##
# die (optional status version): Print a message to
# stderr and exit with either the given status or
# that of the most recent command.
# Usage: some_command || die [status code] "message" ["arguments"...]
#
die() {
  local st=$?
  if [[ $1 != *[^0-9]* ]]; then
    st=$1
    shift
  fi
  warn "$@"
  exit "$st"
}
```

Otro ejemplo:

```bash
##
# warn: Print a message to stderr.
# Usage: warn "message"
#
warn() {
  printf '%s\n' "$@" >&2
}

##
# die (optional status version): Print a message to
# stderr and exit with either the given status or
# that of the most recent command.
# Usage: some_command || die "message" [status code]
#        some_command && die "message" [status code]

die() {
  local st=$?
  case $2 in
    *[^0-9]*|'') :;;
    *) st=$2;;
  esac
  warn "$1"
  exit "$st"
} 
```

Dado que es tu script, puedes elegir que tan elegante quieres que sea.
