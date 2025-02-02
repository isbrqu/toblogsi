---
title: 'Patrones'
...

[BASH](https://mywiki.wooledge.org/BASH) ofrece tres tipos diferentes de *comparación de patrones*. La comparación de patrones cumple dos funciones en el shell: seleccionar nombres de archivos dentro de un directorio o determinar si una cadena se ajusta a un formato deseado.

En la línea de comandos, utilizará principalmente *globs*. Se trata de una forma bastante sencilla de patrones que se pueden utilizar fácilmente para hacer coincidir un rango de archivos o para comprobar variables con reglas simples.

El segundo tipo de coincidencia de patrones implica *globs extendidos*, que permiten expresiones más complicadas que los globs regulares.

Desde la versión `3.0`, Bash también admite patrones de "expresiones regulares". Estos serán útiles principalmente en scripts para probar la entrada del usuario o analizar datos. (No se puede usar una expresión regular para seleccionar nombres de archivos; solo los globs y los globs extendidos pueden hacerlo).

> **Revisar.**
>
> - *Patrón*
> :Un patrón es una cadena con un formato especial diseñado para que coincida con nombres de archivos o para verificar, clasificar o validar cadenas de datos.

## Patrones de glob

Los [globs](https://mywiki.wooledge.org/glob) son un concepto muy importante en Bash, aunque solo sea por su increíble conveniencia. Comprenderlos correctamente le resultará beneficioso de muchas maneras. Los globs son básicamente patrones que se pueden usar para hacer coincidir nombres de archivos u otras cadenas.

Los globs se componen de caracteres normales y metacaracteres. Los metacaracteres son caracteres que tienen un significado especial. Estos son los metacaracteres que se pueden utilizar en los globs:

<table>
	<thead>
		<tr>
			<th>Metacaracter</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`*`</td>
			<td>Coincide con cualquier cadena, incluida la cadena nula.</td>
		</tr>
		<tr>
			<td>`?`</td>
			<td>Coincide con cualquier caracter individual.</td>
		</tr>
		<tr>
			<td>`[...]`</td>
			<td>Coincide con cualquiera de los caracteres incluidos.</td>
		</tr>
	</tbody>
</table>

Los globs están implícitamente *anclados* en ambos extremos. Esto significa que un glob debe coincidir con una cadena *completa* (nombre de archivo o cadena de datos). Un glob de `a*` no coincidirá con la cadena `cat`, porque solo coincide con `at`, no con la cadena completa. Sin embargo, un glob de `ca*` coincidiría con `cat`.

A continuación se muestra un ejemplo de cómo podemos usar patrones glob para expandirnos a nombres de archivos:

```bash
$ ls
a  abc  b  c
$ echo *
a abc b c
$ echo a*
a abc
```

Bash ve el glob, por ejemplo `a*`. *Expande* este glob, buscando en el directorio actual y comparándolo con todos los archivos que hay allí. Todos los nombres de archivo que coinciden con el glob se reúnen y ordenan, y luego la lista de nombres de archivo se utiliza en lugar del glob. Como resultado, la instrucción `echo a*` se reemplaza por la instrucción `echo a abc`, que luego se ejecuta.

Cuando se utiliza un glob para hacer coincidir *nombres de archivo*, los caracteres `*` y `?` no pueden coincidir con un carácter de barra (`/`). Por ejemplo, el glob `*/bin` puede coincidir con `foo/bin`, pero no puede coincidir con `/usr/local/bin`. Cuando los globs coinciden con *patrones*, se elimina la restricción `/`.

Bash realiza expansiones de nombres de archivo *después* de que ya se haya realizado la división de palabras. Por lo tanto, los nombres de archivo generados por un glob no se dividirán; siempre se manejarán correctamente. Por ejemplo:

```bash
$ touch "a b.txt"
$ ls
a b.txt
$ rm *
$ ls
```

Aquí, `*` se expande en un solo nombre de archivo `"a b.txt"`. Este nombre de archivo se pasará como un único argumento a `rm`. Usar globs para enumerar archivos es **siempre** una mejor idea que usar `` `ls` `` para ese propósito. Aquí hay un ejemplo con una sintaxis más compleja que cubriremos más adelante, pero que ilustrará muy bien la razón:

```bash
$ ls
a b.txt
$ for file in `ls`; do rm "$file"; done
rm: cannot remove `a': No such file or directory
rm: cannot remove `b.txt': No such file or directory
$ for file in *; do rm "$file"; done
$ ls
```

Aquí usamos el comando `for` para recorrer la salida del comando `ls`. El comando `ls` imprime la cadena `a b.txt`. El comando `for` divide esa cadena en palabras sobre las que itera. Como resultado, `for` itera primero sobre `a` y luego sobre `b.txt`. Naturalmente, esto **no** es lo que queremos. Sin embargo, el glob se expande en la forma adecuada. Da como resultado la cadena `"a b.txt"`, que `for` toma como único argumento.

Aquí usamos el comando `for` para recorrer la salida del comando `ls`. El comando `ls` imprime la cadena `a b.txt`. El comando `for` divide esa cadena en palabras sobre las que itera. Como resultado, `for` itera primero sobre `a` y luego sobre `b.txt`. Naturalmente, esto **no** es lo que queremos. Sin embargo, el glob se expande en la forma adecuada. Da como resultado la cadena "`a b.txt`", que `for` toma como único argumento.

Además de la expansión de nombres de archivo, los globs también se pueden usar para verificar si los datos coinciden con un formato específico. Por ejemplo, podríamos recibir un nombre de archivo y necesitar realizar diferentes acciones según su extensión:

```bash
$ filename="somefile.jpg"
$ if [[ $filename = *.jpg ]]; then
> echo "$filename is a jpeg"
> fi
somefile.jpg is a jpeg
```

La palabra clave `[[` y la palabra clave `case` (que analizaremos con más detalle más adelante) ofrecen la oportunidad de comprobar una cadena con un glob, ya sean globs regulares o globs extendidos, si estos últimos se han habilitado.

> ***Buena práctica.***
>
> Siempre debe usar globs en lugar de `ls` (o similar) para enumerar archivos. Los globs siempre se expandirán de manera segura y minimizarán el riesgo de errores.
>
> A veces puede terminar con nombres de archivo muy extraños. La mayoría de los scripts no se prueban con todos los casos extraños con los que pueden terminar usándose. ***¡No permita que su script sea uno de ellos!***

> **En el manual**
>
> - [Pattern Matching](http://www.gnu.org/software/bash/manual/bashref.html#Pattern-Matching)

> **En las preguntas frecuentes.**
>
> - [¿Cómo puedo utilizar un AND/OR/NO lógico en un patrón de shell (glob)?](https://mywiki.wooledge.org/BashFAQ/016).

> **Revisar.**
>
> - *Glob*
> : Un glob es una cadena que puede coincidir con ciertas cadenas o nombres de archivos.

## Globs extendidos

Bash también admite una característica llamada *Extended Globs*. Estos globs son más potentes por naturaleza; técnicamente, son equivalentes a expresiones regulares, aunque la sintaxis es diferente a la que la mayoría de las personas están acostumbradas. Esta característica está desactivada de forma predeterminada, pero se puede activar con el comando `shopt`, que se utiliza para alternar las **sh**ell **opt**ions (opciones de shell):

```bash
$ shopt -s extglob
```

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`?(list)`</td>
			<td>Coincide con cero o una ocurrencia de los patrones dados.</td>
		</tr>
		<tr>
			<td>`*(list)`</td>
			<td>Coincide con cero o más ocurrencias de los patrones dados.</td>
		</tr>
		<tr>
			<td>`+(list)`</td>
			<td>Coincide con una o más ocurrencias de los patrones dados.</td>
		</tr>
		<tr>
			<td>`@(list)`</td>
			<td>Coincide con uno de los patrones dados.</td>
		</tr>
		<tr>
			<td>`!(list)`</td>
			<td>Coincide con cualquier cosa excepto con los patrones dados.</td>
		</tr>
	</tbody>
</table>

La lista dentro de los paréntesis es una lista de globs o globs extendidos separados por el carácter `|`. A continuación se muestra un ejemplo:

```bash
$ ls
names.txt  tokyo.jpg  california.bmp
$ echo !(*jpg|*bmp)
names.txt
```

Nuestro glob extendido se expande a cualquier cosa que no coincida con el patrón `*jpg` o `*bmp`. Solo el archivo de texto pasa por eso, por lo que se expande.

## Expresiones regulares

Las expresiones regulares (regex) son similares a los *Patrones Glob*, pero sólo se pueden usar para la coincidencia de patrones, no para la coincidencia de nombres de archivos. Desde la versión 3.0, Bash admite el operador `=~` para la palabra clave `[[`. Este operador hace coincidir la cadena que viene antes con el patrón de expresión regular que lo sigue. Cuando la cadena coincide con el patrón, `[[` devuelve un código de salida de `0` ("verdadero"). Si la cadena no coincide con el patrón, se devuelve un código de salida de `1` ("falso"). En caso de que la sintaxis del patrón no sea válida, `[[` abortará la operación y devolverá un código de salida de `2`.

Bash utiliza el dialecto *Expresión regular extendida* (`ERE`). No abordaremos las expresiones regulares en profundidad en esta guía, pero si le interesa este concepto, lea sobre expresiones regulares o [Expresiones regulares extendidas](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09_04).

Los patrones de *Expresión regular* que utilizan grupos de captura (paréntesis) tendrán sus cadenas capturadas asignadas a la variable `BASH_REMATCH` para su posterior recuperación.

Ilustremos cómo se pueden utilizar expresiones regulares en Bash:

```bash
$ langRegex='(..)_(..)'
$ if ![ $LANG =~ $langRegex ]( $LANG =~ $langRegex )
> then
>     echo "Tu código de país (ISO 3166-1-alpha-2) es ${BASH_REMATCH[2]}."
>     echo "Tu código de país (ISO 639-1) es ${BASH_REMATCH[1]}."
> else
>     echo "No se reconoció su configuración regional"
> fi
```

Tenga en cuenta que el análisis de expresiones regulares en Bash ha cambiado entre las versiones `3.1` y `3.2`. Antes de `3.2` era seguro envolver su patrón de expresión regular entre comillas, pero esto ha cambiado en `3.2`. Desde entonces, las expresiones regulares siempre deben estar sin comillas. Debe proteger cualquier carácter especial escapándolo con una barra invertida. La mejor manera de ser siempre compatible es poner su expresión regular en una variable y expandir esa variable en `[[` sin comillas, como mostramos anteriormente.

> **Buenas prácticas.**
>
> - Dado que la forma en que se utilizan las expresiones regulares en `3.2` también es válida en `3.1`, recomendamos *enfáticamente* nunca usar las comillas. ¡Recuerde mantener los caracteres especiales correctamente escapados!
> - Para compatibilidad cruzada (para evitar tener que escapar paréntesis, barras verticales, etc.) use una variable para almacenar su expresión regular, por ejemplo `![{re='^\*( >| *Applying |.*\.diff|.*\.patch)'; ![ $var =~ $re ]( $var =~ $re )]({re='^\*( >| *Applying |.*\.diff|.*\.patch)'; ![ $var =~ $re ]( $var =~ $re ))}`. Esto es mucho más fácil de mantener ya que solo escribe sintaxis ERE y evita la necesidad de escape de shell, además de ser compatible con todas las versiones 3.x de BASH.
> - Véase también [Chet Ramey's Bash FAQ](http://tiswww.case.edu/php/chet/bash/FAQ), section E14.

> **En el manual.**
>
> [Regex(3)](http://www.daemon-systems.org/man/regex.3.html)


> **En preguntas frecuentes.**
> 
> - [Quiero comprobar si `[[ $var == foo` o `$var == bar` o `$var == more...` sin repetir `$var` n veces](https://mywiki.wooledge.org/BashFAQ/066)

> **Revisar.**
>
> - Regular Expression
> : Una expresión regular es un patrón más complejo que se puede utilizar para hacer coincidir cadenas específicas (pero a diferencia de los globs, no se puede expandir a nombres de archivos).

## Expansión de llaves

Luego está la *Expansión de llaves*. La Expansión de llaves técnicamente no encaja en la categoría de patrones, pero es similar. Los globs solo se expanden a nombres de archivos reales, pero las expansiones de llaves se expandirán a cualquier permutación posible de sus contenidos. Así es como funcionan:

```bash
$ echo th{e,a}n
then than
$ echo {/home/*,/root}/.*profile
/home/axxo/.bash_profile /home/lhunath/.profile /root/.bash_profile /root/.profile
$ echo {1..9}
1 2 3 4 5 6 7 8 9
$ echo {0,1}{0..9}
00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19
```
La expansión de llaves se reemplaza por una lista de palabras, al igual que un glob. Sin embargo, estas palabras no son necesariamente nombres de archivos y no están ordenadas (`than` habría venido antes de `then` si lo estuvieran).

La expansión de llaves se produce *antes* de la expansión del nombre de archivo. En el segundo comando `echo` anterior, usamos una combinación de expansión de llaves y globs. La expansión de llaves se realiza primero y obtenemos:

```bash
$ echo /home/*/.*profile /root/.*profile
```

Después de la expansión de las llaves, los globs se expanden y obtenemos los nombres de archivo como resultado final.

Las expansiones de llaves solo se pueden utilizar para generar listas de palabras. No se pueden utilizar para la búsqueda de patrones.

Existen algunas diferencias interesantes y no muy intuitivas entre los rangos en clases de caracteres como [a-z] y la expansión de llaves. Por ejemplo, la expansión de llaves permite contar hacia atrás, como se puede ver con `{5..1}` o incluso `{b..Y}`, mientras que `[5-1]` no se expande por el shell. `[b-Y]` puede o no expandirse, dependiendo de su [locale](https://mywiki.wooledge.org/locale). Además, los rangos de caracteres en las expansiones de llaves ignoran las variables de configuración regional como `LANG` y `LC_COLLATE` y siempre usan el orden ASCII. El uso de globbing, por otro lado, se ve afectado por la configuración del idioma.

El siguiente fragmento es un ejemplo de cuenta regresiva y visualización de caracteres en el orden de sus códigos ASCII:

```bash
$ echo {b..Y}
b a ` _ ^ ]  [ Z Y
```

[&#8612; Parámetros](parametros.html) &#8231; [Tests y condicionales &#8614;](pruebas-y-condicionales.html)

[Página original](https://mywiki.wooledge.org/BashGuide/Patterns)
