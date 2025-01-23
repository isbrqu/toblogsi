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

**Tenga en cuenta**: A diferencia de PHP/Perl/... los parámetros NO comienzan con el signo $. El signo $ que se ve en los ejemplos simplemente hace que se *expanda* el parámetro que le sigue. La expansión básicamente significa que el shell reemplaza el parámetro por su contenido. Como tal, `LOGNAME` es el parámetro (variable) que contiene su nombre de usuario. `$LOGNAME` es una expresión que será reemplazada con el contenido de esa variable, que en mi caso es `lhunath`.

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
  <th>
    <td>Nombre de la variable</td>
    <td>
      Descripción
    </td>
  </th>
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

(Hay muchas más; consulte el manual para obtener una lista completa). Por supuesto, no está limitado únicamente a estas variables. Siéntase libre de definir las suyas propias:

[Página original](https://mywiki.wooledge.org/BashGuide/Parameters)
