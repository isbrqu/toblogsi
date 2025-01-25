---
title: 'Parámetros'
...

Los parámetros son una especie de espacio con nombre en la memoria que se puede utilizar para recuperar o almacenar información. En términos generales, almacenan datos de cadena, pero también se pueden utilizar para almacenar números enteros, matrices indexadas y asociativas.

Los parámetros se presentan en dos formas: variables y parámetros especiales. Los parámetros especiales son de solo lectura, están preestablecidos por BASH y se utilizan para comunicar algún tipo de estado interno. Las variables son parámetros que puede crear y actualizar usted mismo. Los nombres de las variables están sujetos a la siguiente regla:

> - *Nombre*
: Palabra que consta únicamente de letras, dígitos y guiones bajos y que comienza con una letra o un guión bajo. También se denomina identificador.

Para almacenar datos en una variable, utilizamos la siguiente sintaxis de asignación:

```bash
$ varname=vardata
```

Este comando asigna los datos `vardata` a la variable por nombre `varname`.

Tenga en cuenta que no puede utilizar espacios alrededor del signo `=` en una asignación. Si escribe esto:

```bash
# ¡Esto está mal!
$ varname = vardata
```

[BASH](https://mywiki.wooledge.org/BASH) no sabrá que estás intentando asignar algo. El analizador verá `varname` sin `=` y lo tratará como un nombre de comando, y luego le pasará `=` y `vardata` como argumentos.

Para acceder a los datos almacenados en una variable, utilizamos la [expansión de parámetros](https://mywiki.wooledge.org/BashGuide/Parameters#Parameter_Expansion). La expansión de parámetros es la *sustitución* de un parámetro por su valor, es decir, la sintaxis le dice a bash que desea utilizar el contenido de la variable. Después de eso, Bash *aún puede realizar manipulaciones adicionales en el resultado*. ¡Este es un concepto muy importante para comprender correctamente, porque es muy diferente a la forma en que se manejan las variables en otros lenguajes de programación!

Para ilustrar qué es la expansión de parámetros, utilicemos este ejemplo:

```bash
$ foo=bar
$ echo "Foo es $foo"
```

Cuando Bash está a punto de ejecutar su código, primero cambia el comando tomando su expansión de parámetros (el `$foo`) y reemplazándolo por el contenido de `foo`, que es `bar`. El comando se convierte en:

```bash
$ echo "Foo es $foo"
Foo es bar
```

Ahora Bash está listo para ejecutar el comando. Al ejecutarlo, nos muestra la oración simple en pantalla.

Es importante entender que la expansión de parámetros hace que el `$parametro` sea **reemplazado** por su contenido. Observe el siguiente caso, que se basa en la comprensión del capítulo anterior sobre división de argumentos:

```bash
$ song="Mi cancion.mp3"
$ rm $song
rm: Mi: No such file or directory
rm: cancion.mp3: No such file or directory
```

¿Por qué no funcionó? Porque Bash reemplazó tu `$song` por su contenido, que es `Mi cancion.mp3`; luego, realizó la división de palabras y SOLO ENTONCES ejecutó el comando. Fue como si hubieras escrito esto:

```bash
$ rm Mi cancion.mp3
```

Y de acuerdo con las reglas de división de palabras, Bash pensó que querías decir que `Mi` y `cancion.mp3` significaban dos archivos diferentes, porque hay un espacio en blanco entre ellos y no estaban entre comillas. ¿Cómo solucionamos esto? ¡Recordamos poner **comillas dobles alrededor de cada expansión de parámetro**!

> - *Parámetros*
: Los parámetros almacenan datos que pueden recuperarse a través de un símbolo o un nombre.

## Parámetros y variables especiales

Aclaremos nuestro vocabulario antes de entrar en materia. Hay *parámetros* y *variables*. Las variables son en realidad sólo un tipo de parámetro: parámetros que se denotan por un nombre. Los parámetros que no son variables se denominan parámetros especiales. Seguro que entenderás mejor las cosas con algunos ejemplos:

```bash
$ # Algunos parámetros que no son variables:
$ echo "Mi shell es $0, y tiene estas opciones configuradas: $-"
Mi shell es -bash, y tiene estas opciones configuradas: himB
$ # Algunos parámetros que SON variables:
$ echo "Yo soy $LOGNAME, y vivo en $HOME."
Yo soy lhunath, y vivo en /home/lhunath.
```

> **Tenga en cuenta.**
>
> A diferencia de PHP/Perl/... los parámetros NO comienzan con el signo $. El signo $ que se ve en los ejemplos simplemente hace que se *expanda* el parámetro que le sigue. La expansión básicamente significa que el shell reemplaza el parámetro por su contenido. Como tal, `LOGNAME` es el parámetro (variable) que contiene su nombre de usuario. `$LOGNAME` es una expresión que será reemplazada con el contenido de esa variable, que en mi caso es `lhunath`.

Creo que ya entendiste la idea. Aquí tienes un resumen de la mayoría de los *parámetros especiales*:

<table>
  <tr>
    <th>Nombre del parámetro</th>
    <th>Uso</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>**0**</td>
    <td>`"$0"`</td>
    <td>
      Contiene el nombre o la ruta del script. Esto no siempre es confiable.
    </td>
  </tr>
  <tr>
    <td>**1, 2, etc.**</td>
    <td>`$1`, `$2`, etc</td>
    <td>
      Los parámetros posicionales contienen los argumentos que se pasaron al script o función actual.
    </td>
  </tr>
  <tr>
    <td>**&ast;**</td>
    <td>`"$*"`</td>
    <td>
      Se expande a todas las palabras de todos los parámetros posicionales. Entre comillas dobles, se expande a una sola cadena que las contiene todas, separadas por el primer carácter de la variable `IFS` (que se analiza más adelante).
    </td>
  </tr>
  <tr>
    <td>**&#64;**</td>
    <td>`"$@"`</td>
    <td>
      Se expande a todas las palabras de todos los parámetros posicionales. Entre comillas dobles, se expande a una lista de todas ellas como palabras individuales. 
    </td>
  </tr>
  <tr>
    <td>**#**</td>
    <td>`$#`</td>
    <td>
      Se expande al número de parámetros posicionales que están configurados actualmente.
    </td>
  </tr>
  <tr>
    <td>**?**</td>
    <td>`$?`</td>
    <td>
      Se expande al código de salida del comando de primer plano completado más recientemente.
    </td>
  </tr>
  <tr>
    <td>**&#36;**</td>
    <td>`$$`</td>
    <td>
      Se expande al [PID](https://mywiki.wooledge.org/ProcessManagement) (número de identificación del proceso) del shell actual.
    </td>
  </tr>
  <tr>
    <td>**!**</td>
    <td>`$!`</td>
    <td>
      Se expande al PID del comando ejecutado más recientemente en segundo plano.
    </td>
  </tr>
  <tr>
    <td>**&lowbar;**</td>
    <td>`"$_"`</td>
    <td>
      Se expande hasta el último argumento del último comando que se ejecutó.
    </td>
  </tr>
</table>

Y aquí hay algunos ejemplos de *variables* que el shell le proporciona:

<table>
  <tr>
    <th>Nombre de la variable</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>`BASH_VERSION`</td>
    <td>
      Contiene una cadena que describe la versión de Bash.
    </td>
  </tr>
  <tr>
    <td>`HOSTNAME`</td>
    <td>
      Contiene el nombre de host de tu computadora, lo juro. Puede ser corto o largo, según cómo esté configurada tu computadora.
    </td>
  </tr>
  <tr>
    <td>`PPID`</td>
    <td>
      Contiene el PID del proceso padre de este shell.
    </td>
  </tr>
  <tr>
    <td>`PWD`</td>
    <td>
      Contiene el directorio de trabajo actual.
    </td>
  </tr>
  <tr>
    <td>`RANDOM`</td>
    <td>
      Cada vez que se expande esta variable, se genera un número (pseudo)aleatorio entre 0 y 32767.
    </td>
  </tr>
  <tr>
    <td>`UID`</td>
    <td>
      El número de identificación del usuario actual. Lamentablemente, no es confiable para fines de seguridad o autenticación.
    </td>
  </tr>
  <tr>
    <td>`COLUMNS`</td>
    <td>
      La cantidad de caracteres que caben en una línea de su terminal. (El ancho de su terminal en caracteres).
    </td>
  </tr>
  <tr>
    <td>`LINES`</td>
    <td>
      La cantidad de líneas que caben en su terminal. (La altura de su terminal en caracteres).
    </td>
  </tr>
  <tr>
    <td>`HOME`</td>
    <td>
      El directorio de inicio del usuario actual.
    </td>
  </tr>
  <tr>
    <td>`PATH`</td>
    <td>
      Una lista separada por dos puntos de rutas que se buscarán para encontrar un comando, si no es un alias, una función, un comando incorporado o una palabra clave de shell y no se especifica ninguna ruta.
    </td>
  </tr>
  <tr>
    <td>`PS1`</td>
    <td>
      Contiene una cadena que describe el formato del indicador de shell.
    </td>
  </tr>
  <tr>
    <td>`TMPDIR`</td>
    <td>
      Contiene el directorio que se utiliza para almacenar archivos temporales (por el shell).
    </td>
  </tr>
</table>

(Hay muchas más; consulte el manual para obtener una lista completa).

Por supuesto, no está limitado únicamente a estas variables. Siéntase libre de definir las suyas propias:

```bash
$ pais=Argentina
$ echo "Yo soy $LOGNAME y vivo en $pais"
Yo soy lhunath y vivo en Argentina
```

Observa lo que hicimos para asignar el valor `Argentina` a la variable `pais`. Recuerda que **NO se permiten espacios antes ni después del signo igual**.

```bash
$ language = PHP
-bash: language: command not found
$ language=PHP
$ echo "Estoy demasiado acostumbrado a $language."
Estoy demasiado acostumbrado a PHP.
```

Recuerda que Bash no es Perl ni PHP. Debes tener muy claro cómo funciona la expansión para evitar grandes problemas. Si no lo haces, acabarás creando situaciones **muy peligrosas** en tus scripts, especialmente si cometes este error con `rm`:

```bash
$ ls
no secret  secret
$ file='no secret'
$ rm $file
rm: cannot remove `no': No such file or directory
```

Imaginemos que tenemos dos archivos, uno `no secret` y otro `secret`. El primero no contiene nada útil, pero el segundo contiene el secreto que salvará al mundo de una catástrofe inminente. Tan desconsiderado como eres, olvidaste citar tu expansión de parámetros `file`. Bash divide los argumentos por sus espacios en blanco como lo hace normalmente, y a `rm` se le pasan dos argumentos: 'no' y 'secret'. Como resultado, no puede encontrar el archivo `no` y elimina el archivo `secret`. ¡Se ha perdido `secret`!

> **Buena práctica.**
>
> Siempre debe mantener las expansiones de parámetros correctamente entrecomilladas. Esto evita que los espacios en blanco o las posibles extensiones dentro de ellas le provoquen canas o borren información inesperadamente de su computadora. La única expansión de parámetros buena es una expansión de parámetros entrecomillada.

> **En el manual.**
>
> - [Parametros](http://www.gnu.org/software/bash/manual/bashref.html#Shell-Parameters).
> - [Variables](http://www.gnu.org/software/bash/manual/bashref.html#Shell-Variables).

> **En las preguntas frecuentes.**
>
> - [¿Cómo puedo concatenar dos variables? ¿Cómo puedo agregar una cadena a una variable?](https://mywiki.wooledge.org/BashFAQ/013)
> - [¿Cómo puedo acceder a los parámetros posicionales después de $9?](https://mywiki.wooledge.org/BashFAQ/025)

> **Revisar.**
>
> - *Variable*
: Una variable es un tipo de parámetro que se puede crear y modificar directamente. Se denota por un nombre, que debe comenzar con una letra o un guión bajo (\_), y debe constar únicamente de letras, dígitos y el guión bajo. Los nombres de las variables distinguen entre mayúsculas y minúsculas.
> - *Expansion*
: La expansión se produce cuando un parámetro tiene como prefijo un signo de dólar. Bash toma el valor del parámetro y reemplaza la expansión del parámetro por su valor antes de ejecutar el comando. Esto también se denomina *sustitución*.

## Tipos de variables

Aunque Bash no es un lenguaje tipado, sí tiene algunos tipos diferentes de variables. Estos tipos definen el tipo de contenido que pueden tener. Bash almacena internamente la información de tipo.

<table>
	<thead>
		<tr>
			<th>Tipo de variable</th>
			<th>Declaración de variable</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Arreglo</td>
			<td>`declare -a foo`</td>
			<td>La variable `foo` es un arreglo de cadenas.</td>
		</tr>
		<tr>
			<td>Arreglo asociativo</td>
			<td>`declare -A foo`</td>
			<td>La variable `foo` es un arreglo asociativo de cadenas (bash 4.0 o superior).</td>
		</tr>
		<tr>
			<td>Entero</td>
			<td>`declare -i foo`</td>
			<td>La variable `foo` contiene un número entero. Al asignar valores a esta variable se activa automáticamente la *evaluación aritmética*.</td>
		</tr>
		<tr>
			<td>Solo lectura</td>
			<td>`declare -r foo`</td>
			<td>La variable `foo` ya no se puede modificar ni desconfigurar.</td>
		</tr>
		<tr>
			<td>Exportar</td>
			<td>`declare -x foo`</td>
			<td>La variable `foo` está marcada para exportación, lo que significa que será heredada por cualquier proceso secundario.</td>
		</tr>
	</tbody>
</table>

Los [arreglos](https://mywiki.wooledge.org/BashGuide/Arrays) son básicamente listas indexadas de cadenas. Son muy convenientes por su capacidad de almacenar múltiples cadenas juntas sin depender de un delimitador para separarlas (lo que es tedioso cuando se hace correctamente y propenso a errores cuando no se hace).

Definir variables como números enteros tiene la ventaja de que se puede omitir parte de la sintaxis al intentar asignarlas o modificarlas:

```bash
$ a=5; a+=2; echo "$a"; unset a
52
$ a=5; let a+=2; echo "$a"; unset a
7
$ declare -i a=5; a+=2; echo "$a"; unset a
7
$ a=5+2; echo "$a"; unset a
5+2
$ declare -i a=5+2; echo "$a"; unset a
7
```

Sin embargo, en la práctica, el uso de `declare -i` es extremadamente raro. En gran parte, esto se debe a que crea un comportamiento que puede sorprender a cualquiera que intente mantener el script, que no se da cuenta de la declaración `declare`. La mayoría de los programadores de shell con experiencia prefieren usar comandos aritméticos explícitos (con `((...))` o `let`) cuando quieren realizar operaciones aritméticas.

También es raro ver una declaración explícita de una matriz utilizando `declare -a`. Es suficiente escribir `array=(...)` y Bash sabrá que la variable ahora es una matriz. La excepción a esto es la matriz asociativa, que *debe* ser declarada explícitamente: `declare -A mi_arreglo`.

> **Revisar.**
>
> - *String*
> : Una *cadena* es una secuencia de caracteres.
> - *Array*
> : Una *arreglo* es una lista de cadenas indexadas por números.
> - *Integer*
> : Un entero es un número entero (positivo, negativo o cero).
> - *Read Only*
> : Los parámetros que son de *solo lectura* no se pueden modificar ni desconfigurar.
> - *Export*
> : Las variables marcadas para *exportación* serán heredadas por cualquier proceso secundario. Las variables heredadas de esta manera se denominan *Variables de entorno*.


> **En las preguntas frecuentes.**
>
> - [¿Cómo puedo utilizar arreglos?](https://mywiki.wooledge.org/BashFAQ/005)

## Expansión de parámetros

*Expansión de parámetros* es el término que se refiere a cualquier operación que haga que un parámetro se expanda (se reemplace por contenido). En su forma más básica, la expansión de un parámetro se logra anteponiendo a ese parámetro el signo `$`. En ciertas situaciones, se requieren llaves adicionales alrededor del nombre del parámetro:

```bash
$ echo "'$USER', '$USERs', '${USER}s'"
'lhunath', '', 'lhunaths'
```

Este ejemplo ilustra cómo se ven las expansiones de parámetros básicas (PE). La segunda PE da como resultado una cadena vacía. Esto se debe a que el parámetro `USERs` está vacío. No teníamos la intención de que la `s` fuera parte del nombre del parámetro. Dado que no hay forma de que Bash pueda saber que desea agregar una `s` literal al valor del parámetro, debe usar llaves para marcar el comienzo y el final del nombre del parámetro. Eso es lo que hacemos en la tercera PE en nuestro ejemplo anterior.

*Expansión de parámetros* también nos da trucos para modificar la cadena que se va a expandir. Estas operaciones pueden resultar muy prácticas:

```bash
$ for file in *.JPG *.jpeg
do mv -- "$file" "${file%.*}.jpg"
done
```

El código anterior se puede utilizar para cambiar el nombre de todos los archivos JPEG con extensión `.JPG` o `.jpeg` para que tengan la extensión `.jpg` normal. La expresión `${file%.*}` corta todo lo que esté al final, comenzando por el último punto (`.`). Luego, entre las mismas comillas, se agrega una nueva extensión al resultado de la expansión.

A continuación se muestra un resumen de la mayoría de los trucos de EP disponibles:

<table>
	<thead>
		<tr>
			<th></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`${parameter:-word}`</td>
			<td>**Usa el valor por defecto.** Si el `parameter` no está definido o es nulo, se sustituye por la `word` (que puede ser una expansión). De lo contrario, se sustituye por el valor del `parameter`.</td>
		</tr>
		<tr>
			<td>`${parameter:=word}`</td>
			<td>**Asignar valor por defecto.** Si `parameter` no está definido o es nulo, se asigna `word` (que puede ser una expansión) a `parameter`. Luego se sustituye el valor de `parameter`.</td>
		</tr>
		<tr>
			<td>`${parameter:+word}`</td>
			<td>**Utilice un valor alternativo.** Si `parameter` es nulo o no está definido, no se sustituye nada; de lo contrario, se sustituye `word` (que puede ser una expansión).</td>
		</tr>
		<tr>
			<td>`${parameter:offset:length}`</td>
			<td>**Expansión de subcadena.** Se expande hasta `length` caracteres de `parameter` comenzando en el carácter especificado por `offset` (indexado a 0). Si se omite `:length`, se llega hasta el final. Si `offset` es negativo (¡use paréntesis!), se cuenta hacia atrás desde el final de `parameter` en lugar de hacia adelante desde el principio. Si `parameter` es `@` o un nombre de arreglo indexado subíndice por `@` o `*`, el resultado es `length` parámetros posicionales o miembros del arreglo, respectivamente, comenzando desde `offset`.</td>
		</tr>
		<tr>
			<td>`${#parameter}`</td>
			<td>Se sustituye la longitud en caracteres del valor de `parameter`. Si `parameter` es un nombre de matriz con subíndice `@` o `*`, se devuelve el número de elementos.</td>
		</tr>
		<tr>
			<td>`${parameter#pattern}`</td>
			<td>
				`pattern` se compara con el **comienzo** de `parameter`. El resultado es el valor expandido de `parameter` con la coincidencia más corta eliminada.
				Si `parameter` es un nombre de matriz con subíndice `@` o `*`, esto se hará en cada elemento. Lo mismo para todos los elementos siguientes.
			</td>
		</tr>
		<tr>
			<td>`${parameter##pattern}`</td>
			<td>Igual que el anterior, pero se elimina la coincidencia más *larga*.</td>
		</tr>
		<tr>
			<td>`${parameter%pattern}`</td>
			<td>
				`pattern` se compara con el **final** de `parameter`. El resultado es el valor expandido de `parameter` con la coincidencia más corta eliminada.
			</td>
		</tr>
		<tr>
			<td>`${parameter%%pattern}`</td>
			<td>Igual que el anterior, pero se elimina la coincidencia más *larga*.</td>
		</tr>
		<tr>
			<td>`${parameter/pat/string}`</td>
			<td>
				El resultado es el valor expandido de `parameter` con la **primera** coincidencia (no anclada) de `pat` reemplazada por `string`. Se asume que la cadena es nula cuando la parte `/string` está ausente.
			</td>
		</tr>
		<tr>
			<td>`${parameter//pat/string}`</td>
			<td>Igual que el anterior, pero se reemplaza *cada coincidencia* de `pat`.</td>
		</tr>
		<tr>
			<td>`${parameter/#pat/string}`</td>
			<td>
				Igual que el anterior, pero comparado con el **principio**. Útil para agregar un prefijo común con un patrón nulo: `${array[@]/#/prefix}`.
			</td>
		</tr>
		<tr>
			<td>`${parameter/%pat/string}`</td>
			<td>
				Igual que el anterior, pero combinado con el **final**. Útil para agregar un sufijo común con un patrón nulo.
			</td>
		</tr>
	</tbody>
</table>

Los aprenderás con la experiencia. Te resultarán útiles con mucha más frecuencia de la que crees. A continuación, te mostramos algunos ejemplos para empezar:

```bash
$ file="$HOME/.secrets/007"; \
echo "Ubicación del archivo: $file"; \
echo "Nombre del archivo: ${file##*/}"; \
echo "Directorio de archivos: ${file%/*}"; \
echo "Archivo no secreto: ${file/secrets/not_secret}"; \
echo; \
echo "Otra ubicación de archivo: ${other:-No hay otro archivo}"; \
echo "Usar archivo si no hay otro archivo: ${other:=$file}"; \
echo "Otro nombre de archivo: ${other##*/}"; \
echo "Longitud de otra ubicación de archivo: ${#other}"
Ubicación del archivo: /home/lhunath/.secrets/007
Nombre del archivo: 007
Directorio de archivos: /home/lhunath/.secrets
Archivo no secreto: /home/lhunath/.not_secret/007

Otra ubicación de archivo: No hay otro archivo
Usar archivo si no hay otro archivo: /home/lhunath/.secrets/007
Otro nombre de archivo: 007
Longitud de otra ubicación de archivo: 26
```
Recuerde la diferencia entre `${v#p}` y `${v##p}`. La duplicación del carácter `#` significa que los patrones se volverán voraces. Lo mismo ocurre con `%`:

```
$ version=1.5.9; echo "MAJOR: ${version%%.*}, MINOR: ${version#*.}."
MAJOR: 1, MINOR: 5.9.
$ echo "Dash: ${version/./-}, Dashes: ${version//./-}."
Dash: 1-5.9, Dashes: 1-5-9.
```

Nota: **No puedes** utilizar varios PE juntos. Si necesitas ejecutar varios PE en un parámetro, necesitarás utilizar varias instrucciones:

```
$ file=$HOME/image.jpg
$ file=${file##*/}
$ echo "${file%.*}"
image
```

> **Buenas prácticas.**
>
> Puede verse tentado a utilizar aplicaciones externas como `sed`, `awk`, `cut`, `perl` u otras para modificar sus cadenas. Tenga en cuenta que todas ellas requieren que se inicie un proceso adicional, lo que en algunos casos puede provocar ralentizaciones. Las expansiones de parámetros son la alternativa perfecta.

> **En el manual.**
>
> - [Shell Parameter Expansion](http://www.gnu.org/software/bash/manual/bashref.html#Shell-Parameter-Expansion)

> **En las preguntas frecuentes.**
>
> - [¿Cómo puedo manipular cadenas en bash?](https://mywiki.wooledge.org/BashFAQ/100)
> - [¿Cómo puedo cambiar el nombre de todos mis archivos \*.foo a \*.bar, o convertir espacios en guiones bajos, o convertir nombres de archivos en mayúsculas a minúsculas?](https://mywiki.wooledge.org/BashFAQ/030)
> - [¿Cómo puedo usar la expansión de parámetros? ¿Cómo puedo obtener subcadenas? ¿Cómo puedo obtener un archivo sin su extensión, o solo la extensión de un archivo?](https://mywiki.wooledge.org/BashFAQ/073)
> - [¿Cómo obtengo los efectos de esas ingeniosas expansiones de parámetros de Bash en shells más antiguos?](https://mywiki.wooledge.org/BashFAQ/074)
> - [¿Cómo puedo determinar si una variable ya está definida? ¿O una función?](https://mywiki.wooledge.org/BashFAQ/083)

> **Revisar.**
>
> - *Expansión de parámetros*
> : Cualquier expansión (consulte la definición anterior) de un parámetro. Durante esta expansión, se pueden realizar determinadas operaciones sobre el valor que se va a expandir.

[&#8612; Caracteres especiales](caracteres-especiales.html) &#8231; [Patrones &#8614;](patrones.html)

[Página original](https://mywiki.wooledge.org/BashGuide/Parameters)
