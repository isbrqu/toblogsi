+++
title = '1. for f in $(ls *.mp3)'
date = 2023-12-21T00:00:00-00:00
draft = false
+++

## El error

Uno de los errores más comunes al programar en bash es escribir bucles como los siguientes:

```bash
for f in $(ls *.mp3); do    # Wrong!
    some command $f         # Wrong!
done

for f in $(ls)              # Wrong!
for f in `ls`               # Wrong!

for f in $(find . -type f)  # Wrong!
for f in `find . -type f`   # Wrong!

files=($(find . -type f))   # Wrong!
for f in ${files[@]}        # Wrong!
```

Sí, sería fantástico si pudieras tratar la salida de "ls" o "find" como una lista de nombres de archivos e iterar sobre ella. Pero no puedes. Todo este enfoque tiene un error fatal y no existe ningún truco que pueda hacerlo funcionar. Debe utilizar un enfoque completamente diferente.

Hay al menos 6 problemas con esto:

1. Si un nombre de archivo contiene espacios en blanco (o cualquier carácter en el valor actual de `$IFS`), se somete a [WordSplitting](#). Suponiendo que tenemos un archivo llamado `01 - Don't Eat the Yellow Snow.mp3` en el directorio actual, el bucle `for` iterará sobre cada palabra en el nombre del archivo resultante: `01`, `-`, `Dont't`, etc.
1. Si un nombre de archivo contiene caracteres [glob](#), se somete a una expansión del nombre de archivo ("[globbing](#)"). Si `ls` produce cualquier resultado que contenga un carácter `*`, la palabra que lo contiene será reconocida como un patrón y sustituida por una lista de todos los nombres de archivos que coincidan con él.
1. Si la sustitución del comando devuelve varios nombres de archivos, no hay forma de saber dónde termina el primero y comienza el segundo. Los nombres de ruta pueden contener _cualquier_ carácter excepto `NUL`. Sí, esto incluye nuevas líneas (o salto de líneas).
1. La utilidad `ls` puede alterar los nombres de archivos. Dependiendo de la plataforma en la que se encuentre, los argumentos que utilizó (o no utilizó) y si su salida estándar apunta a una terminal o no, `ls` puede decidir aleatoriamente reemplazar ciertos caracteres en un nombre de archivo con "? ", o simplemente no imprimirlos en absoluto. [Nunca intentes analizar la salida de ls](#ParsingLs). `ls` es simplemente innecesario. Es un comando externo cuya salida está destinada específicamente a ser leída por un humano, no analizada por un script.
1. El [CommandSubstitution](#CommandSubstitution) elimina _todos_ los caracteres de nueva línea finales de su salida. Esto puede parecer deseable ya que `ls` agrega una nueva línea, pero si el último nombre de archivo en la lista termina con una nueva línea, `` `…` `` o `$()` eliminarán _esa_ también.
1. En los ejemplos de `ls`, si el primer nombre de archivo comienza con un guión, puede generar [error #3](../003-nombres-de-archivos-con-guiones-iniciales).

## Malas "soluciones"

Tampoco puedes simplemente citar dos veces la sustitución:

```bash
for f in "$(ls *.mp3)"; do     # Wrong!
```

Esto hace que toda la salida de `ls` se trate como una sola palabra. En lugar de iterar sobre cada nombre de archivo, el bucle solo se ejecutará _una vez_, asignando a `f` una cadena con todos los nombres de archivo agrupados.

Tampoco puede simplemente cambiar [IFS](#IFS) a una nueva línea. Los nombres de archivos también pueden contener nuevas líneas.

Otra variación de este tema es abusar de la división de palabras y de un bucle `for` para leer (incorrectamente) líneas de un archivo. Por ejemplo:

```bash
IFS=$'\n'
for line in $(cat file); do ...     # Wrong!
```

¡[Esto no funciona](#DontReadLinesWithFor)! Especialmente si esas líneas son nombres de archivos. Bash (o cualquier otro shell de la familia Bourne) simplemente no funciona de esta manera.

## La solución

Hay varias formas, principalmente dependiendo de si necesita una expansión recursiva o no.

### Con recursividad

Si no necesita recursividad, puede utilizar un [glob](#glob) simple. En lugar de `ls`:

```bash
for file in ./*.mp3; do    # Better! and ...
    some command "$file"   # ...always double-quote expansions!
done
```

Los shells POSIX como Bash tienen la función globbing específicamente para este propósito: permitir que el shell expanda patrones en una lista de nombres de archivos coincidentes. No es necesario interpretar los resultados de una utilidad externa. Debido a que globbing es el último paso de la expansión, cada coincidencia del patrón `./*.mp3` se expande correctamente a una palabra separada y no está sujeta a los efectos de una expansión sin comillas.

**Pregunta**: ¿Qué sucede si no hay archivos `*.mp3` en el directorio actual? Luego, el bucle for se ejecuta una vez, con `file="./*.mp3"`, ¡que no es el comportamiento esperado! La solución es probar si hay un archivo coincidente:

```sh
# POSIX
for file in ./*.mp3; do
    [ -e "$file" ] || continue
    some command "$file"
done
```

Otra solución es utilizar la función `shopt -s nullglob` de Bash, aunque esto sólo debe hacerse después de leer la documentación y considerar cuidadosamente el efecto de esta configuración en todos los demás globs del script.

### Sin recursividad

Si necesita recursividad, la solución estándar es _buscar_. Cuando [usa find](#UsingFind), asegúrese de usarlo correctamente. Para la portabilidad de POSIX sh, use la opción `-exec`:

```bash
find . -type f -name '*.mp3' -exec some command {} \;
# O, si el comando acepta múltiples nombres de archivos de entrada:
find . -type f -name '*.mp3' -exec some command {} +
```

Si estás usando bash, tienes dos opciones adicionales. Una es usar la opción `-print0` de GNU o BSD `find`, junto con la opción `read -d ''` de bash y una [ProcessSubstitution](#ProcessSubstitution):

```bash
while IFS= read -r -d '' file; do
  some command "$file"
done < <(find . -type f -name '*.mp3' -print0)
```

La ventaja aquí es que "some command" (de hecho, todo el cuerpo del bucle `while`) se ejecuta en el shell actual. Puede configurar variables y hacer que [persistan después de que finalice el ciclo](#BashFAQ/024).

La otra opción, disponible en [Bash 4.0 y superior](#BashFAQ/061), es `globstar`, que permite expandir un globo de forma recursiva:

```bash
shopt -s globstar
for file in ./**/*.mp3; do
  some command "$file"
done
```

Tenga en cuenta las comillas dobles alrededor de `$file` en los ejemplos anteriores. Esto nos lleva a nuestro [segundo escollo](../002-variables-sin-comillas-dobles):

[Página original](http://mywiki.wooledge.org/BashPitfalls#for_f_in_.24.28ls_.2A.mp3.29)
