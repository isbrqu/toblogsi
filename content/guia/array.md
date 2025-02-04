---
title: 'Arrays'
...

[Como se mencionó anteriormente](base_url/guia/parametros.html#tipos-de-variables), [Bash](https://mywiki.wooledge.org/Bash) tiene múltiples tipos de parámetros. Es importante señalar que las variables pueden contener un único valor (escalares) o múltiples valores (arreglos).

Las cadenas son, sin duda, el tipo de parámetro más utilizado, pero también el que menos se utiliza. Es importante recordar que una cadena contiene solo **un** elemento. Capturar la salida de un comando, por ejemplo, y ponerla en un parámetro de cadena significa que ese parámetro contiene solo **una** cadena de caracteres, independientemente de si esa cadena representa veinte nombres de archivos, veinte números o veinte nombres de personas.

Y como siempre ocurre cuando se colocan varios elementos en una sola cadena, estos elementos múltiples deben estar delimitados de alguna manera entre sí. Nosotros, como humanos, normalmente podemos descifrar cuáles son los diferentes nombres de archivo cuando observamos una cadena. Suponemos que, tal vez, cada línea de la cadena representa un nombre de archivo, o cada palabra representa un nombre de archivo. Si bien esta suposición es comprensible, también es inherentemente errónea. Cada nombre de archivo individual puede contener todos los caracteres que se podrían utilizar para separar los nombres de archivo entre sí en una cadena. Eso significa que técnicamente no hay forma de saber dónde termina el primer nombre de archivo en la cadena, porque no hay ningún carácter que pueda decir: "Indico el final de este nombre de archivo" porque ese carácter en sí mismo podría ser parte del nombre de archivo.

A menudo la gente comete este error:

```bash
# Esto NO funciona en el caso general.
$ files=$(ls ~/*.jpg); cp $files /backups/
```
Probablemente esta sea una mejor idea (usando la notación de arreglo, que se explica más adelante, en la siguiente sección):

```bash
# Esto SÍ funciona en el caso general.
$ files=(~/*.jpg); cp "${files[@]}" /backups/
```
El primer intento de hacer una copia de seguridad de nuestros archivos en el directorio actual es defectuoso. Ponemos la salida de `ls` en una cadena llamada `files` y luego usamos la expansión de parámetros `$files` **sin comillas** para cortar esa cadena en argumentos (confiando en la *división de palabras*). Como se mencionó antes, la división de argumentos y palabras corta una cadena en pedazos donde haya espacios en blanco. Confiar en esto significa que asumimos que ninguno de nuestros nombres de archivo contendrá ningún espacio en blanco. Si lo hacen, el nombre del archivo se cortará a la mitad o más. Conclusión: **malo**.

La única forma segura de representar **varios** elementos de cadena en Bash es mediante el uso de arreglos. Una arreglo es un tipo de variable que **mapea números enteros a cadenas**. Eso básicamente significa que contiene una lista numerada de cadenas. Dado que cada una de estas cadenas es una entidad (elemento) independiente, puede contener de forma segura cualquier carácter, incluso espacios en blanco.

Para obtener mejores resultados y menos dolores de cabeza, recuerda que si tienes una lista de cosas, siempre debes colocarla en una arreglo.

A diferencia de otros lenguajes de programación, Bash no ofrece listas, tuplas, etc. Sólo arreglos y arreglos asociativas (que son nuevas en Bash 4).

> **Revisar.**
>
> *Arreglo*
> : Un arreglo es una lista numerada de cadenas: asigna números enteros a cadenas.

## Creando arreglos

Existen varias formas de crear o llenar un arreglo con datos. No existe una única forma verdadera: el método que necesitará dependerá de dónde provengan los datos y de qué tipo sean.

La forma más sencilla de crear una arreglo simple con datos es utilizando la sintaxis `=()`:

```bash
$ names=("Bob" "Peter" "$USER" "Big Bad John")
```

Esta sintaxis es excelente para crear arreglos con datos estáticos o un conjunto conocido de parámetros de cadena, pero nos da muy poca flexibilidad para agregar muchos elementos de arreglo. Si necesita más flexibilidad, también puede especificar índices explícitos:

```bash
$ names=([0]="Bob" [1]="Peter" [20]="$USER" [21]="Big Bad John")
# or...
$ names[0]="Bob"
```

Observe que en este ejemplo hay un espacio entre los índices 1 y 20. Un arreglo con espacios se denomina *arreglo disperso*. Bash permite esto y, a menudo, puede resultar bastante útil.

Si desea llenar una arreglo con nombres de archivos, entonces probablemente querrá usar *Globs* allí:

```bash
$ photos=(~/"My Photos"/*.jpg)
```

Observe aquí que hemos citado la parte `Mis fotos` porque contiene un espacio. Si no la hubiéramos citado, Bash la habría dividido en `fotos=('~/Mis' 'Fotos/'*.jpg )` que obviamente **no** es lo que queremos. Observe también que hemos citado **solo** la parte que contiene el espacio. Esto se debe a que no podemos citar el `~` o el `*`; si lo hacemos, se volverán literales y Bash ya no los tratará como caracteres especiales.

Desafortunadamente, es muy fácil crear **de manera equívoca** arreglos con un montón de nombres de archivos de la siguiente manera:

```bash
$ files=$(ls)    # MAL, MAL, MAL
$ files=($(ls))  # ¡AÚN MAL!
```

Recuerde **siempre evitar** el uso de `ls`. El primero crearía una **cadena** con la salida de `ls`. Esa cadena no se puede usar de forma segura por las razones mencionadas anteriormente en la introducción de `arreglos`. El segundo es más preciso, pero aún divide los nombres de archivo con espacios en blanco.

Esta es la forma correcta de hacerlo:

```bash
$ files=(*)      # ¡Bien!
```
Esta declaración nos da un arreglo donde cada nombre de archivo es un elemento separado. El `*` es un patrón global para `cualquier cadena` que expande la ruta de acceso a todos los nombres de archivo en el directorio actual (tal como lo haría, por ejemplo, en `rm *`). Después de la expansión de la ruta de acceso, el comando se verá como `files=([cada archivo en el directorio actual que coincida con *])` que asigna todos los archivos a l arreglo `files`. ¡Perfecto!

*Esta sección que vamos a presentar contiene algunos conceptos avanzados. Si te pierdes, es posible que quieras volver aquí después de haber leído toda la guía. Puedes saltar directamente a [usando arreglos](#usando-arreglos) si quieres simplificar las cosas.*

Ahora bien, a veces queremos construir un arreglo a partir de una cadena o de la salida de un comando. Los comandos (por lo general) solo generan cadenas: por ejemplo, al ejecutar un comando `find` se enumerarán los nombres de los archivos y se separarán estos nombres de archivos con nuevas líneas (es decir, cada nombre de archivo en una línea separada). Por lo tanto, para analizar esa gran cadena en un arreglo, debemos indicarle a Bash dónde termina cada elemento. (Tenga en cuenta que este es un mal ejemplo, porque los nombres de archivos pueden **contener** una nueva línea, por lo que no es seguro delimitarlos con nuevas líneas. Pero vea más abajo).

Dividir una cadena es para lo que se utiliza `IFS`:

```bash
$ IFS=. read -ra ip_elements <<< "127.0.0.1"
```

Aquí usamos `IFS` con el valor `.` para dividir la dirección IP dada en elementos de arreglo donde haya un `.`, lo que da como resultado un arreglo con los elementos `127`, `0`, `0` y `1`. (El comando incorporado `read` y el operador `<<<` se tratarán con más profundidad en el capítulo [Entrada y salida](https://mywiki.wooledge.org/BashGuide/InputAndOutput)).

Podríamos hacer lo mismo con un comando `find`, configurando `IFS` con una nueva línea. Pero entonces nuestro script fallaría cuando alguien crea un nombre de archivo con una nueva línea (ya sea de manera accidental o maliciosa).

Entonces, ¿hay alguna manera de obtener una lista de elementos de un programa externo (como `find`) en un arreglo de Bash? En general, la respuesta es sí, siempre que haya una forma confiable de delimitar los elementos.

En el caso específico de los nombres de archivo, la respuesta a este problema son los bytes NUL. Un byte NUL es un byte que está compuesto únicamente de ceros: `00000000`. Las cadenas de Bash no pueden contener bytes NUL debido a un defecto del lenguaje de programación "C": los bytes NUL se utilizan en C para marcar el final de una cadena. Dado que Bash está escrito en C y utiliza las cadenas nativas de C, hereda ese comportamiento.

Un flujo de datos (como la salida de un comando o un archivo) puede contener bytes NUL. Los flujos son como cadenas con tres grandes diferencias: se leen secuencialmente (normalmente no se puede saltar de una a otra); son *unidireccionales* (se puede leer desde ellos o escribir en ellos, pero normalmente no ambas cosas); y pueden contener bytes NUL.

Los *nombres* de archivos no pueden contener bytes NUL (ya que Unix los implementa como cadenas de C), y tampoco la gran mayoría de cosas legibles por humanos que querríamos almacenar en un script (nombres de personas, direcciones IP, etc.). Eso hace que NUL sea un gran candidato para separar elementos en un flujo. Muy a menudo, el comando cuya salida quieres leer tendrá una opción que hace que muestre sus datos separados por bytes NUL en lugar de nuevas líneas o algo más. `find` (en GNU y BSD, de todos modos) tiene la opción `-print0`, que usaremos en este ejemplo:

```bash
$ files=()
$ while read -r -d ''; do
>     files+=("$REPLY")
> done < <(find /foo -print0)
```
Esta es una forma segura de analizar la salida de un comando en cadenas. Es comprensible que parezca un poco confuso y complicado al principio. Así que vamos a analizarlo:

- La primera línea `files=()` crea un arreglo vacío llamado `files`.
- Estamos usando un [bucle while](base_url/guia/pruebas-y-condicionales.html) que ejecuta un comando `read` cada vez. El comando `read` usa la opción `-d ''` para especificar el delimitador e interpreta la cadena vacía como un byte NUL (`\0`) (ya que los argumentos de Bash no pueden contener NUL). Esto significa que en lugar de leer una línea a la vez (hasta una nueva línea), estamos leyendo hasta un byte NUL. También usa `-r` para evitar que trate las barras invertidas de manera especial.
- Una vez que `read` ha leído algunos datos y ha encontrado un byte NUL, se ejecuta el cuerpo del bucle `while`. Colocamos lo que leímos (que está en el parámetro `REPLY`) en nuestra matriz.
- Para ello, utilizamos la sintaxis `+=()`. Esta sintaxis añade uno o más elementos al final de nuestra matriz.
- Finalmente, la sintaxis `< <(..)` es una combinación de *Redirección de archivo* (`<`) y *Sustitución de proceso* (`<(..)`). Omitiendo los detalles técnicos por ahora, simplemente diremos que así es como enviamos la salida del comando `find` a nuestro bucle `while`.

El comando `find` utiliza la opción `-print0` como se mencionó anteriormente para indicarle que separe los nombres de archivo que encuentra con un byte NUL.

Aparte de esto, consulte [globstar](https://mywiki.wooledge.org/glob#globstar_.28since_bash_4.0-alpha.29) si está usando bash >= 4.0 y solo desea recorrer directorios de forma recursiva.

> **Buenas prácticas.**
>
>	Las matrices son una lista segura de cadenas. Son perfectas para almacenar varios nombres de archivos.
>	Si tiene que analizar un flujo de datos en sus elementos, debe haber una manera de saber dónde empieza y dónde termina cada elemento. El byte NUL suele ser la mejor opción para esta tarea.
>	Si tiene una lista de cosas, manténgala en formato de lista el mayor tiempo posible. No la convierta en una cadena o en un archivo hasta que sea absolutamente necesario. Si tiene que escribirla en un archivo y volver a leerla más tarde, tenga en cuenta el problema de los delimitadores que mencionamos anteriormente.

> **En el manual.**
>
> - [Arrays](http://www.gnu.org/software/bash/manual/bashref.html#Arrays)

> **En preguntas frecuentes.**
>
> - [¿Cómo puedo utilizar variables de arreglo?](https://mywiki.wooledge.org/BashFAQ/005) 
> - [¿Cómo puedo utilizar variables variables (variables indirectas, punteros, referencias) o matrices asociativas?](https://mywiki.wooledge.org/BashFAQ/006) 
> - [¿Cómo puedo encontrar y tratar nombres de archivos que contienen nuevas líneas, espacios o ambos?](https://mywiki.wooledge.org/BashFAQ/020) 
> - [Establecí variables en un bucle. ¿Por qué desaparecen de repente después de que finaliza el bucle? O bien, ¿por qué no puedo enviar datos a leer?](https://mywiki.wooledge.org/BashFAQ/024)

[&#8612; Tests y condicionales](base_url/guia/pruebas-y-condicionales.html) &#8231; [Comandos compuestos &#8614;](https://mywiki.wooledge.org/BashGuide/CompoundCommands)

[Página original](https://mywiki.wooledge.org/BashGuide/Arrays)
