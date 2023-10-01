+++
title = '103. ¿Cómo verifico si mi archivo fue modificado en un determinado mes o rango de fechas?'
date = 2023-10-01T06:32:44-03:00
draft = false
+++

Hacer cálculos relacionados con fechas en Bash es difícil porque Bash
no tiene funciones integradas para hacer cálculos con fechas u obtener
metadatos como la hora de modificación de los archivos.

Existe el comando `stat(1)` pero no es altamente portable; incluso en
diferentes sistemas operativos GNU. Si bien la mayoría tienen a
`stat`, todas toman argumentos y sintaxis diferentes. Por lo tanto, si
el script debe ser portátil, no debe confiar en `stat(1)`. Hay un
ejemplo [integrado cargable](#) llamado `finfo` que puede recuperar
metadatos de archivos, pero tampoco está disponible de forma
predeterminada.

Lo que sí tenemos es `test` (o `[[`) que puede verificar si un archivo
fue modificado antes o después de otro archivo (usando `-nt` o `-ot`)
y `touch` que puede crear archivos con un tiempo de modificación
específico. Combinando estos, podemos hacer bastante.

Por ejemplo, una función para comprobar si un archivo se modificó en
un determinado rango de fechas:

```bash
inTime() {
 set -- "$1" "$2" "${3:-1}" "${4:-1}" "$5" "$6" # Default month & day to 1.
 local file=$1 ftmp="${TMPDIR:-/tmp}/.f.$$" ttmp="${TMPDIR:-/tmp}/.t.$$"
 local fyear=${2%-*} fmonth=${3%-*} fday=${4%-*} fhour=${5%-*} fminute=${6%-*}
 local tyear=${2#*-} tmonth=${3#*-} tday=${4#*-} thour=${5#*-} tminute=${6#*-}
 
 touch -t "$(printf '%02d%02d%02d%02d%02d' "$fyear" "$fmonth" "$fday" "$fhour" "$fminute")" "$ftmp"
 touch -t "$(printf '%02d%02d%02d%02d%02d' "$tyear" "$tmonth" "$tday" "$thour" "$tminute")" "$ttmp"
 
 (trap 'rm "$ftmp" "$ttmp"' RETURN; [[ $file -nt $ftmp && $file -ot $ttmp ]])
}
```

Usando esta función, podemos verificar si un archivo fue modificado en
un rango de fechas determinado. La función toma varios argumentos: un
nombre de archivo, un rango de años, un rango de meses, un rango de
días, un rango de horas y un rango de minutos. Cualquier rango también
puede ser un único número, en cuyo caso el principio y el final del
rango serán el mismo. Si algún rango no se especifica o se omite, el
valor predeterminado es 0 (o 1 en el caso de mes/día).

Aquí ejemplos de uso:

```bash
$ touch -t 198404041300 file
$ inTime file 1984 04-05 && echo "file was last modified in April of 1984"
file was last modified in April of 1984
$ inTime file 2010 01-02 || echo "file was not last modified in January 2010"
file was not last modified in Januari 2010
$ inTime file 1945-2010 && echo "file was last modified after The War"
file was last modified after The War
```
