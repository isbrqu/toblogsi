+++
title = '99. ¿Cómo puedo obtener el archivo más nuevo (o más antiguo) de un directorio?'
date = 2023-10-01T06:05:05-03:00
draft = false
+++

Esta página debe fusionarse con la
[pregunta frecuente #3](../003-comparar-archivos-por-metadato)

La respuesta intuitiva de `ls -t | head -1 `es incorrecto, porque
analizar la salida de `ls` no es seguro; en su lugar, deberías crear un
bucle y comparar las marcas de tiempo:

```bash
# Bash
files=(*) newest=${files[0]}
for f in "${files[@]}"; do
  if [[ $f -nt $newest ]]; then
    newest=$f
  fi
done
```

Luego tendrás el archivo más nuevo (según el tiempo de modificación)
en `$newest`. Para obtener el más antiguo, simplemente cambie `-nt` a
`-ot` (consulte la prueba de ayuda para obtener una lista de
operadores) y, por supuesto, cambie los nombres de las variables para
evitar confusiones.

Bash no tiene medios para comparar marcas de tiempo de archivos
distintos de `mtime`, por lo que si desea obtener (por ejemplo) el
archivo al que se accedió más recientemente (el más reciente `atime`),
tendría que obtener ayuda del comando externo `stat(1)` (si lo tiene)
o el `finfo` integrado cargable (si puede cargar archivos integrados).

Aquí hay un ejemplo que usa `stat` de GNU coreutils 6.10
(lamentablemente, incluso en sistemas Linux, la sintaxis de `stat` no
es consistente) para obtener el archivo al que se accedió más
recientemente. (En esta versión, `%X` es la hora del último acceso).

```bash
# Bash, GNU coreutils
newest= newest_t=0
for f in *; do
  t=$(stat --format=%X -- "$f")   # atime
  if ((t > newest_t)); then
    newest_t=$t
    newest=$f
  fi
done
```

Esto también tiene la desventaja de generar un comando externo para
cada archivo en el directorio, por lo que debe hacerse de esta manera
sólo si es necesario. Para obtener el archivo más antiguo usando esta
técnica, tendría que inicializar `oldest_t` con la marca de tiempo más
grande posible (una propuesta complicada, especialmente a medida que
nos acercamos al año 2038), o con la marca de tiempo del primer
archivo en el directorio, como hizo en el primer ejemplo.

Aquí hay otra solución que genera un comando externo, pero posix:

```bash
# posix
unset newest
for f in ./*; do
  # set the newest during the first iteration
  newest=${newest-$f} 
  #-prune to avoid descending in the directories, the exit status of find is useless here, we check the output
  if [ "$(find "$f" -prune -newer "$newest")" ]; then 
    newest=$f
  fi
done
```

Ejemplo: cómo eliminar todos los directorios excepto el más reciente.
(Tenga en cuenta que la hora de modificación de un directorio es la
hora de la operación más reciente que cambia ese directorio, es decir,
la última creación, eliminación o cambio de nombre del archivo).

```sh
$ cat clean-old 
dirs=(enginecrap/*/) newest=${dirs[0]}
for d in "${dirs[@]}"
 do if [[ $d -nt $newest ]]
    then newest=$d
    fi
 done

for z in "${dirs[@]}"
 do if [[ "$z" != "$newest" ]]
    then rm -rf "$z"
    fi
 done
$ for x in 20101022 20101023 200101025 20101107 20101109; do mkdir enginecrap/"$x";done
$ ls enginecrap/
200101025       20101022        20101023        20101107        20101109
$ ./clean-old 
$ ls enginecrap/
20101109
```
