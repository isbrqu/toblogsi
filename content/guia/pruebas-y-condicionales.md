---
title: 'Pruebas y condicionales'
...

La ejecución secuencial de comandos es una cosa, pero para lograr una lógica avanzada en sus scripts o en sus líneas de comandos, necesitará pruebas y condiciones. Las pruebas determinan si algo es verdadero o falso. Las condiciones se utilizan para tomar decisiones que determinan el flujo de ejecución de un script.

## Estado de salida

Cada comando genera un código de salida cada vez que finaliza. Este código de salida lo utiliza la aplicación que lo inició para evaluar si todo salió bien. Este código de salida es como un valor de retorno de las funciones. Es un número entero entre 0 y 255 (inclusive). La convención dicta que usemos 0 para indicar éxito y cualquier otro número para indicar algún tipo de falla. El número específico es completamente específico de la aplicación y se utiliza para indicar qué salió mal exactamente.

Por ejemplo, el comando `ping` envía paquetes ICMP a través de la red a un host determinado. Ese host normalmente responde a este paquete enviando exactamente el mismo. De esta manera, podemos verificar si podemos comunicarnos con un host remoto. `ping` tiene una serie de códigos de salida que pueden indicarnos qué salió mal, si es que salió mal algo:

> **Del manual de `ping` de Linux:**
> 
> *Si ping no recibe ningún paquete de respuesta, saldrá con el código 1. Si se especifican un recuento de paquetes y una fecha límite, y se reciben menos de los paquetes antes de que llegue la fecha límite, también saldrá con el código 1. En caso de otro error, saldrá con el código 2. De lo contrario, saldrá con el código 0. Esto permite usar el código de salida para ver si un host está activo o no.*

El parámetro especial `?` nos muestra el código de salida del último proceso en primer plano que finalizó. Juguemos un poco con `ping` para ver sus códigos de salida:

```bash
$ ping Good
ping: unknown host Good
$ echo $?
2
$ ping -c 1 -W 1 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
--- 1.1.1.1 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms
$ echo $?
1
```

> **Buenas prácticas.**
>
> Debes asegurarte de que tus scripts siempre devuelvan un código de salida distinto de cero si ocurre algo inesperado durante su ejecución. Puedes hacerlo con la función integrada `exit`:

```bash
rm file || { echo 'No se ha podido eliminar el archivo!' >&2; exit 1; }
```

> **En el manual.**
>
> [Exit Status](http://www.gnu.org/software/bash/manual/bashref.html#Exit-Status)


> **Revisar.**
>
> - *Código de salida* / *Estado de salida*
> : Siempre que un comando finaliza, notifica a su padre (que en nuestro caso siempre será el shell que lo inició) su estado de salida. Esto se representa mediante un número que va de 0 a 255. Este código es una pista sobre el éxito de la ejecución del comando.

## Operadores de control (`&&` and `||`)

Ahora que sabemos qué son los códigos de salida y que un código de salida de '0' significa que la ejecución del comando fue exitosa, aprenderemos a usar esta información. La forma más fácil de realizar una determinada acción dependiendo del éxito de un comando anterior es mediante el uso de *operadores de control*. Estos operadores son `&&` y `||`, que representan respectivamente un AND lógico y un OR lógico. Estos operadores se utilizan entre dos comandos y se utilizan para controlar si el segundo comando debe ejecutarse dependiendo del éxito del primero. Este concepto se llama *ejecución condicional*.

Pongamos esa teoría en práctica:

```bash
$ mkdir d && cd d
```
Este ejemplo simple tiene dos comandos, `mkdir d` y `cd d`. Podrías usar un punto y coma para separar los comandos y ejecutarlos secuencialmente; pero queremos algo más. En el ejemplo anterior, [BASH](https://mywiki.wooledge.org/BASH) ejecutará `mkdir d`, luego `&&` verificará el resultado de la aplicación `mkdir` después de que finalice. Si la aplicación `mkdir` fue exitosa (código de salida 0), entonces Bash ejecutará el siguiente comando, `cd d`. Si `mkdir d` falló y devolvió un código de salida distinto de 0, Bash omitirá el siguiente comando y permaneceremos en el directorio actual.

Another example:

```bash
$ rm /etc/some_file.conf || echo "No pude eliminar el archivo"
rm: cannot remove `/etc/some_file.conf': No such file or directory
No pude eliminar el archivo
```

`||` es muy parecido a `&&`, pero hace exactamente lo contrario. Solo ejecuta el siguiente comando si el primero **falló**. Por lo tanto, el mensaje solo se repite si el comando `rm` no tuvo éxito.

En general, no es buena idea encadenar varios operadores de control diferentes en un solo comando (lo analizaremos en la siguiente sección). `&&` y `||` son bastante útiles en casos simples, pero no en casos complejos. En las siguientes secciones, mostraremos otras herramientas que puede utilizar para la toma de decisiones.

> **Buenas prácticas.**
>
> Es mejor no exagerar al trabajar con operadores condicionales, ya que pueden dificultar la comprensión del script, especialmente para una persona que está encargada de su mantenimiento y no lo escribió ella misma.


> **En el manual.**
> 
> [Lists of Commands](http://www.gnu.org/software/bash/manual/bashref.html#Lists)

> **Revisar.**
>
> - *Operadores de control*
> : estos operadores se utilizan para vincular comandos entre sí. Comprueban el código de salida del comando anterior para determinar si se debe ejecutar o no el siguiente comando de la secuencia.

## Declaraciones de agrupación

El uso de operadores condicionales es fácil y conciso si queremos realizar comprobaciones de errores simples. Sin embargo, las cosas se ponen un poco más peligrosas cuando queremos ejecutar varias instrucciones si una condición es verdadera o si necesitamos evaluar varias condiciones.

Supongamos que desea eliminar un archivo si contiene una determinada palabra `good` pero tampoco contiene otra palabra `bad`. Al utilizar `grep` (un comando que comprueba la entrada en busca de patrones), traducimos estas condiciones a:

```bash
grep -q goodword "$file"            # exit status 0 (success) if "$file" contains 'goodword'
! grep -q "badword" "$file"         # exit status 0 (success) if "$file" does not contain 'badword'
```

Usamos `-q` (silencioso) en grep porque no queremos que muestre las líneas que coinciden; solo queremos que se establezca el código de salida.

El `!` delante de un comando hace que Bash *niegue* el estado de salida del comando. Si el comando devuelve 0 (éxito), el `!` lo convierte en un error. Del mismo modo, si el comando devuelve un valor distinto de cero (error), el `!` lo convierte en un éxito.

Ahora, para juntar estas condiciones y eliminar el archivo como resultado de que ambas sean verdaderas, podríamos usar **Operadores condicionales**:

```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file"
```

Esto funciona muy bien. (De hecho, podemos encadenar tantos `&&` como queramos, sin ningún problema). Ahora, imaginemos que queremos mostrar un mensaje de error en caso de que falle la eliminación del archivo:

```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && rm "$file" || echo "Couldn't delete: $file" >&2
```

A primera vista, esto parece correcto. Si el código de salida de `rm` no es `0` (éxito), entonces el operador `||` activará el siguiente comando y `echo` el mensaje de error (`>&2`: al error estándar).

Pero hay un problema. Cuando tenemos una secuencia de comandos separados por *Operadores condicionales*, Bash analiza cada uno de ellos, en orden de izquierda a derecha. El estado de salida se traslada a partir del comando que se haya ejecutado más recientemente y omitir un comando no lo cambia.

Entonces, imaginemos que el primer `grep` falla (establece el estado de salida en 1). Bash ve un `&&` a continuación, por lo que se salta el segundo `grep` por completo. Luego ve otro `&&`, por lo que también se salta el `rm` que sigue a ese. Finalmente, ve un operador `||`. ¡Ajá! El estado de salida es "error", y tenemos un `||`, por lo que Bash ejecuta el comando `echo` y nos dice que no pudo eliminar un archivo, ¡aunque en realidad nunca lo *intentó*! Eso no es lo que queremos.

Esto no suena tan mal cuando se trata simplemente de un mensaje de error incorrecto que recibes, pero si no tienes cuidado, esto **ocurrirá** eventualmente en un código más peligroso. ¡No querrás eliminar archivos accidentalmente o sobrescribirlos como resultado de una falla en tu lógica!

```bash
$ grep -q goodword "$file" && ! grep -q badword "$file" && { rm "$file" || echo "Couldn't delete: $file" >&2; }
```

(Nota: ¡no olvides que necesitas un punto y coma o una nueva línea antes de la llave de cierre!)

Ahora hemos agrupado los comandos `rm` y `echo` juntos. Eso significa que, efectivamente, el grupo se considera **una declaración** en lugar de varias. Volviendo a nuestra situación en la que falló el primer `grep`, en lugar de que Bash intente la declaración `&& rm "$file"`, ahora intentará la declaración `&& { ... }`. Dado que está precedida por un `&&` y el último comando que ejecutó falló (el `grep` fallido), omitirá este grupo y seguirá adelante.

La agrupación de comandos se puede utilizar para más cosas que solo *Operadores condicionales*. También podemos querer agruparlos para poder redirigir la entrada a un grupo de instrucciones en lugar de solo a una:

```bash
{
    read firstLine
    read secondLine
    while read otherLine; do
        something
    done
} < file
```

Aquí estamos [redireccionando](https://mywiki.wooledge.org/BashGuide/InputAndOutput#Redirection) `archivo` a un grupo de comandos que leen la entrada. El archivo se abrirá cuando comience el grupo de comandos, permanecerá abierto mientras dure y se cerrará cuando finalice el grupo de comandos. De esta manera, podemos seguir leyendo líneas de forma secuencial con varios comandos.

Otro uso común de la agrupación es en el manejo de errores simples:

```bash
# Comprueba si podemos acceder a appdir. Si no es así, muestra un error y sale del script.
cd "$appdir" || { echo "Por favor crea el directorio de aplicaciones y vuelve a intentarlo" >&2; exit 1; }
```

## Bloques condicionales (`if`, `test` and `[[`)

`if` es una palabra clave del shell que ejecuta un comando (o un conjunto de comandos) y verifica el código de salida de ese comando para ver si se ejecutó correctamente. Según ese código de salida, `if` ejecuta un bloque específico y diferente de comandos.

```bash
$ if true
> then echo "Era verdad."
> else echo "Era falso."
> fi
Era verdad.
```

Aquí puede ver el esquema básico de una *declaración if*. Comenzamos llamando a `if` con el comando `true`. `true` es un comando incorporado que siempre termina con éxito. `if` ejecuta ese comando y, una vez que el comando termina, `if` verifica el código de salida. Dado que `true` siempre termina con éxito, `if` continúa hasta el bloque `then` y ejecuta ese código. Si el comando `true` hubiera fallado de alguna manera y hubiera devuelto un código de salida fallido, la declaración `if` habría omitido el código `then` y habría ejecutado el bloque de código `else` en su lugar.

Distintas personas tienen distintos estilos preferidos para escribir sentencias "if". Estos son algunos de los estilos más comunes:

```bash
if COMMANDS
then OTHER COMMANDS
fi

if COMMANDS
then
    OTHER COMMANDS
fi

if COMMANDS; then
    OTHER COMMANDS
fi
```

Hay algunos comandos diseñados específicamente para *probar* cosas y devolver un estado de salida en función de lo que encuentren. El primero de estos comandos es `test` (también conocido como `[`). Una versión más avanzada se llama `[`. `[` o `test` es un comando normal que lee sus argumentos y realiza algunas comprobaciones con ellos. `[[` es muy parecido a `[`, pero es especial (una palabra clave de shell) y ofrece mucha más versatilidad. Seamos prácticos:

```bash
$ if [ a = b ]
> then echo "a is the same as b."
> else echo "a is not the same as b."
> fi
a is not the same as b.
```

`if` ejecuta el comando `[` (recuerde, no **necesita** un `if` para ejecutar el comando `[`!) con los argumentos `a`, `=`, `b` y `]`. `[` usa estos argumentos para determinar qué se debe verificar. En este caso, verifica si la cadena `a` (el primer argumento) es igual (el segundo argumento) a la cadena `b` (el tercer argumento), y si este es el caso, saldrá exitosamente. Sin embargo, dado que la cadena "a" no es igual a la cadena "b", `[` no saldrá exitosamente (su código de salida será 1). `if` ve que `[` terminó sin éxito y ejecuta el código en el bloque `else`.

El último argumento, `]`, no significa nada para `[`, pero es obligatorio. Observa lo que ocurre cuando lo omites.

A continuación se muestra un ejemplo de un error común cuando se utiliza `[`:

```bash
$ myname='Greg Wooledge' yourname='Alguien más'
$ [ $myname = $yourname ]
-bash: [: too many arguments
```

¿Puedes adivinar qué causó el problema?

`[` se ejecutó con los argumentos `Greg`, `Wooledge`, `=`, `Someone`, `Else` y `]`. ¡Eso son 6 argumentos, no 4! `[` no entiende qué prueba se supone que debe ejecutar, porque espera que el primer o el segundo argumento sea un operador. En nuestro caso, el operador es el tercer argumento. Otra razón más por la que las [comillas](https://mywiki.wooledge.org/Quotes) son tan terriblemente importantes. Siempre que escribimos un espacio en blanco en Bash que va junto con las palabras anteriores o posteriores, **necesitamos ponerlo entre comillas**, y lo mismo ocurre con las expansiones de parámetros:

```bash
$ [ "$myname" = "$yourname" ]
```

Esta vez, `[` ve un operador (`=`) en el segundo argumento y puede continuar con su trabajo.

Para ayudarnos un poco, el shell Korn introdujo (y Bash adoptó) un nuevo estilo de prueba condicional. Por muy originales que sean los autores del shell Korn, lo llamaron `[[`. `[[` está repleto de varias características muy interesantes de las que `[` carece.

Una de las características de `[[` es la coincidencia de [patrones](base_url/guia/patrones.html):

```bash
$ ![ $filename = *.png ]( $filename = *.png ) && echo "$filename parece un archivo PNG"
```

Otra característica de `[[` nos ayuda a lidiar con las expansiones de parámetros:

```bash
$ ![ $me = $you ]( $me = $you )           # Fine.
$ ![ I am $me = I am $you ]( I am $me = I am $you ) # Not fine!
-bash: conditional binary operator expected
-bash: syntax error near `am'
```

Esta vez, `$me` y `$you` no necesitaban comillas. Dado que `[[` no es un comando normal (como `[` lo es), sino una *palabra clave de shell*, tiene poderes mágicos especiales. Analiza sus argumentos antes de que sean expandidos por Bash y realiza la expansión por sí mismo, tomando el resultado como un único argumento, incluso si ese resultado contiene espacios en blanco. (En otras palabras, `[[` no permite la división de palabras de sus argumentos). *Sin embargo*, tenga en cuenta que las cadenas simples aún deben estar entre comillas correctamente. `[[` trata un espacio fuera de las comillas como un separador de argumentos, tal como lo haría Bash normalmente. Arreglemos nuestro último ejemplo:


```bash
$ ![ "I am $me" = "I am $you" ]( "I am $me" = "I am $you" )
```

Además, existe una diferencia sutil entre citar y no citar el **lado derecho** de la comparación en `[[`. El operador `=` realiza una comparación de patrones de manera predeterminada, siempre que el *lado derecho* **no** esté entre comillas:

```bash
$ foo=[a-z]* name=lhunath
$ ![ $name = $foo   ]( $name = $foo   ) && echo "El nombre $name coincide con el patrón $foo"
El nombre lhunath coincide con el patrón [a-z]*
$ ![ $name = "$foo" ]( $name = "$foo" ) || echo "El nombre $name no es igual a la cadena $foo"
El nombre lhunath no es igual a la cadena [a-z]*
```

La primera prueba comprueba si `$name` coincide con el *patrón* en `$foo`. La segunda prueba comprueba si `$name` es igual a la *cadena* en `$foo`. Las comillas realmente hacen una gran diferencia, una sutileza que vale la pena destacar.

> **Recuerde:**
> 
> El uso de comillas normalmente le proporcionará el comportamiento que desea, así que conviértalo en un hábito; omítalo solo cuando la situación específica requiera un comportamiento sin comillas. Desafortunadamente, los errores causados por el uso incorrecto de comillas suelen ser difíciles de encontrar, porque el código suele ser válido con o sin comillas, pero puede tener diferentes significados. En tales casos, bash no puede saber que hizo algo mal; simplemente hace lo que le dice, incluso si eso no es lo que pretendía.

También puedes combinar varias declaraciones `if` en una usando `elif` en lugar de `else`, donde cada prueba indica otra posibilidad:

```bash
$ name=lhunath
$ if ![ $name = "George" ]( $name = "George" )
> then echo "Bonjour, $name"
> elif ![ $name = "Hans" ]( $name = "Hans" )
> then echo "Goeie dag, $name"
> elif ![ $name = "Jack" ]( $name = "Jack" )
> then echo "Good day, $name"
> else
> echo "No eres George, Hans ni Jack. ¿Quién diablos eres, $name?"
> fi
```

Tenga en cuenta que `<` y `>` tienen un significado especial en bash. Prueba sorpresa: predice qué sucede cuando haces `[manzana < banana]`. Pon a prueba tu hipótesis (¡no hagas trampa intentando sin formular primero una hipótesis!). *Música de Jeopardy sonando...* Respuesta: bash busca un archivo llamado "banana" en el directorio actual para que su contenido pueda enviarse a `[ apple` (a través de la entrada estándar).

Suponiendo que no tienes un archivo llamado "banana" en tu directorio actual, esto generará un error. Pregunta rápida: Suponiendo que la intención original de ese comando es determinar si "apple" viene antes que "banana", ¿cómo cambiarías el comando para obtener el efecto deseado? *Música de Jeopardy sonando...* Respuesta: escape el `<` con una barra invertida como esta: `[ manzana \< banana ]` o use `[[` en lugar de `[`.

Tenga en cuenta que los operadores de comparación `=`, `!=`, `>` y `<` tratan sus argumentos como cadenas. Para que los operandos se traten como números, debe utilizar uno de un conjunto diferente de operadores: `-eq`, `-ne` (no igual a), `-lt` (menor que), `-gt`, `-le` (menor o igual que) o `-ge`. Pregunta sorpresa: Piense en un ejemplo que muestre la diferencia entre `<` y `-lt`. Suena la música de Jeopardy... Dado que "314" viene antes de "9" lexicográficamente (es decir, el orden en que los pondría el diccionario), `[` considera que el primero es `<` que el segundo; mientras que, `[` considera que "314" NO es `-lt` "9", porque trescientos catorce NO es menor que nueve.

Ahora que tienes una comprensión decente de los problemas de citas que pueden surgir, echemos un vistazo a algunas de las otras características con las que fueron bendecidos `[` y `[[`:

### Pruebas admitidas por `[` (también conocidas como `test`) y `[[`

Sobre archivos:

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`-e FILE`</td>
			<td>Verdadero si el archivo existe.</td>
		</tr>
		<tr>
			<td>`-f FILE`</td>
			<td>Verdadero si el archivo es un archivo normal.</td>
		</tr>
		<tr>
			<td>`-d FILE`</td>
			<td>Verdadero si el archivo es un directorio.</td>
		</tr>
		<tr>
			<td>`-h FILE`</td>
			<td>Verdadero si el archivo es un enlace simbólico.</td>
		</tr>
		<tr>
			<td>`-p PIPE`</td>
			<td>Verdadero si existe la tubería.</td>
		</tr>
		<tr>
			<td>`-r FILE`</td>
			<td>Verdadero si usted puede leer el archivo.</td>
		</tr>
		<tr>
			<td>`-s FILE`</td>
			<td>Verdadero si el archivo existe y no está vacío.</td>
		</tr>
		<tr>
			<td>`-t FD`</td>
			<td>Verdadero si FD se abre en una terminal.</td>
		</tr>
		<tr>
			<td>`-w FILE`</td>
			<td>Verdadero si usted puede escribir en el archivo.</td>
		</tr>
		<tr>
			<td>`-x FILE`</td>
			<td>Verdadero si usted puede ejecutar el archivo.</td>
		</tr>
		<tr>
			<td>`-O FILE`</td>
			<td>Verdadero si el archivo es efectivamente de su propiedad.</td>
		</tr>
		<tr>
			<td>`-G FILE`</td>
			<td>Verdadero si el archivo es efectivamente propiedad de su grupo.</td>
		</tr>
		<tr>
			<td>`FILE -nt FILE`</td>
			<td>Verdadero si el primer archivo es más nuevo que el segundo.</td>
		</tr>
		<tr>
			<td>`FILE -ot FILE`</td>
			<td>Verdadero si el primer archivo es más antiguo que el segundo.</td>
		</tr>
	</tbody>
</table>

Sobre cadenas (y expresión):

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`-z STRING`</td>
			<td>Verdadero si la cadena está vacía (su longitud es cero).</td>
		</tr>
		<tr>
			<td>`-n STRING`</td>
			<td>Verdadero si la cadena no está vacía (su longitud no es cero).</td>
		</tr>
		<tr>
			<td>`STRING = STRING`</td>
			<td>Verdadero si la primera cadena es idéntica a la segunda.</td>
		</tr>
		<tr>
			<td>`STRING != STRING`</td>
			<td>Verdadero si la primera cadena no es idéntica a la segunda.</td>
		</tr>
		<tr>
			<td>`STRING < STRING`</td>
			<td>Verdadero si la primera cadena se ordena antes que la segunda.</td>
		</tr>
		<tr>
			<td>`STRING > STRING`</td>
			<td>Verdadero si la primera cadena se ordena después de la segunda.</td>
		</tr>
		<tr>
			<td>`! EXPR`</td>
			<td>Invierte el resultado de la expresión (NO lógico).</td>
		</tr>
	</tbody>
</table>

Sobre números:

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`INT -eq INT`</td>
			<td>Verdadero si ambos números enteros son idénticos.</td>
		</tr>
		<tr>
			<td>`INT -ne INT`</td>
			<td>Verdadero si los números enteros no son idénticos.</td>
		</tr>
		<tr>
			<td>`INT -lt INT`</td>
			<td>Verdadero si el primer entero es menor que el segundo.</td>
		</tr>
		<tr>
			<td>`INT -gt INT`</td>
			<td>Verdadero si el primer entero es mayor que el segundo.</td>
		</tr>
		<tr>
			<td>`INT -le INT`</td>
			<td>Verdadero si el primer entero es menor o igual que el segundo.</td>
		</tr>
		<tr>
			<td>`INT -ge INT`</td>
			<td>Verdadero si el primer entero es mayor o igual que el segundo.</td>
		</tr>
	</tbody>
</table>

Pruebas adicionales admitidas únicamente por `[[` con cadenas:

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`STRING = (or ==) PATTERN`</td>
			<td>No se realiza una comparación de cadenas como con `[` (o `test`), sino que se realiza una *coincidencia de patrones*. Es verdadero si la cadena coincide con el patrón global.</td>
		</tr>
		<tr>
			<td>`STRING != PATTERN`</td>
			<td>No se realiza una comparación de cadenas como con `[` (o `test`), sino que se realiza una *coincidencia de patrones*. Es verdadero si la cadena no coincide con el patrón global.</td>
		</tr>
		<tr>
			<td>`STRING =~ REGEX`</td>
			<td>Verdadero si la cadena coincide con el patrón de expresión regular.</td>
		</tr>
	</tbody>
</table>

Pruebas adicionales admitidas únicamente por `[[` con expresiones:

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`( EXPR )`</td>
			<td>Se pueden utilizar paréntesis para cambiar la precedencia de la evaluación.</td>
		</tr>
		<tr>
			<td>`EXPR && EXPR`</td>
			<td>Muy similar al operador '-a' de 'test', pero no evalúa la segunda expresión si la primera ya resulta ser falsa.</td>
		</tr>
		<tr>
			<td>`EXPR || EXPR`</td>
			<td>Much like the '-o' operator of `test`, but does not evaluate the second expression if the first already turns out to be true.</td>
		</tr>
	</tbody>
</table>

Pruebas exclusivas de `[` (y `test`):

<table>
	<thead>
		<tr>
			<th>Expresión</th>
			<th>Descripción</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>`EXPR -a EXPR`</td>
			<td>Verdadero si ambas expresiones son verdaderas (AND lógico).</td>
		</tr>
		<tr>
			<td>`EXPR -o EXPR`</td>
			<td>Verdadero si alguna de las expresiones es verdadera (OR lógico).</td>
		</tr>
	</tbody>
</table>

¿Algunos ejemplos? Seguro:

```bash
$ test -e /etc/X11/xorg.conf && echo 'Tu "Xorg" está configurado'
Tu "Xorg" está configurado
$ test -n "$HOME" && echo 'Tu directorio personal está configurado'
Tu directorio personal está configurado
$ ![ boar != bear ]( boar != bear ) && echo "Los jabalíes no son osos."
Los jabalíes no son osos.
$ ![ boar != b?ar ]( boar != b?ar ) && echo "Los jabalíes no se parecen a los osos."
$ ![ $DISPLAY ]( $DISPLAY ) && echo "Su variable DISPLAY no está vacía, probablemente tenga Xorg ejecutándose."
Su variable DISPLAY no está vacía, probablemente tenga Xorg ejecutándose.
$ ![ ! $DISPLAY ]( ! $DISPLAY ) && echo "Su variable DISPLAY no está vacía, probablemente no tenga Xorg ejecutándose."
```

> **Buenas prácticas.**
>
> Siempre que crees un script Bash, debes utilizar siempre `[[` en lugar de `[`.
>
> Siempre que esté creando un script de Shell, que puede terminar siendo utilizado en un entorno donde Bash no está disponible, debe utilizar `[`, porque es mucho más portátil. (Si bien está integrado en Bash y algunos otros shells, `[` también debe estar disponible como una aplicación externa; lo que significa que funcionará como argumento para, por ejemplo, `-exec` y `xargs` de `find`).
>
> Nunca utilice las pruebas `-a` o `-o` del comando `[`. En su lugar, utilice varios comandos `[` (o utilice `[[` si puede). POSIX no define el comportamiento de `[` con conjuntos complejos de pruebas, por lo que nunca se sabe lo que se obtendrá.

```bash
if [ "$food" = manzana ] && [ "$drink" = te ]; then
  echo "La comida es aceptable."
fi
```

> **En el manual.**
>
> [Conditional Constructs](http://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs)


> **En preguntas frecuentes.**
>
> - [¿Cómo puedo agrupar expresiones, por ejemplo `(A Y B) O C`?](https://mywiki.wooledge.org/BashFAQ/017)
> - [¿Cuál es la diferencia entre los comandos de prueba antiguos y nuevos (`[` y `[[`)?](https://mywiki.wooledge.org/BashFAQ/031)
> - [¿Cómo puedo determinar si una variable contiene una subcadena?](https://mywiki.wooledge.org/BashFAQ/041)
> - [¿Cómo puedo saber si una variable contiene un número válido?](https://mywiki.wooledge.org/BashFAQ/054)

> **Revisar.**
>
> `if` (keyword)
> : - Ejecuta una lista de comandos y luego, dependiendo de su código de salida, ejecuta el código en el siguiente bloque `then` (u opcionalmente `else`).

## Bucles condicionales (while, till y for)

Ahora ya aprendiste a tomar algunas decisiones básicas en tus scripts. Sin embargo, eso no es suficiente para todo tipo de tareas que queramos programar. A veces necesitamos repetir cosas. Para eso, necesitamos usar un *bucle*. Hay dos tipos básicos de bucles (más un par de variantes), y usar el tipo correcto de bucle te ayudará a mantener tus scripts legibles y fáciles de mantener.

Los dos tipos básicos de bucles se denominan `while` y `for`. El bucle `while` tiene una variante llamada `until` que simplemente invierte su comprobación; y el bucle `for` puede aparecer en dos formas diferentes. A continuación, se incluye un resumen:

- `while` *command*
: Repita hasta que el comando se ejecute correctamente (el código de salida es 0).
- `until` *command*
: Repita hasta que el comando se ejecute sin éxito (el código de salida no sea 0).
- `for` *variable* `in` *words*
: Repita el ciclo para cada palabra, asignando *variable* a cada palabra por turno.
- `for ((` *expression*`;` *expression*`;` *expression* `))`
: Comienza evaluando la primera expresión aritmética; repite el bucle hasta que la segunda expresión aritmética sea exitosa; y al final de cada bucle evalúa la tercera expresión aritmética.

Cada forma de bucle va seguida de la palabra clave `do`, luego uno o más comandos en el *cuerpo*, luego la palabra clave `done`. `do` y `done` son similares a `then` y `fi` (y posiblemente `elif` y/o `else`) de la declaración `if` que vimos antes. Su trabajo es decirnos dónde comienza y termina el cuerpo del bucle.

En la práctica, los bucles se utilizan para distintos tipos de tareas. El bucle `for` (primera forma) es adecuado cuando tenemos una lista de cosas y queremos recorrerla secuencialmente. El bucle `while` es adecuado cuando no sabemos exactamente cuántas veces tenemos que repetir algo; simplemente queremos que siga funcionando hasta que encontremos lo que estamos buscando.

A continuación se muestran algunos ejemplos para ilustrar las diferencias y las similitudes entre los bucles. (Recuerde: en la mayoría de los sistemas operativos, debe presionar **Ctrl-C** para cerrar un programa que se esté ejecutando en su terminal).

```bash
$ while true
> do echo "Bucle infinito"
> done
```

```bash
$ while ! ping -c 1 -W 1 1.1.1.1; do
> echo "Todavía estoy esperando a 1.1.1.1"
> sleep 1
> done
```

```bash
$ (( i=10 )); while (( i > 0 ))
> do echo "$i latas de cerveza vacías."
> (( i-- ))
> done
$ for (( i=10; i > 0; i-- ))
> do echo "$i latas de cerveza vacías."
> done
$ for i in {10..1}
> do echo "$i latas de cerveza vacías."
> done
```

Los últimos tres bucles logran exactamente el mismo resultado, utilizando una sintaxis diferente. Te encontrarás con esto muchas veces en tu experiencia con scripts de shell. Casi siempre habrá múltiples enfoques para resolver un problema. La prueba de tu habilidad pronto no será tanto la resolución de un problema sino la *mejor* forma de resolverlo. Debes aprender a elegir el mejor ángulo de enfoque para el trabajo. Por lo general, los principales factores a tener en cuenta serán la simplicidad y la flexibilidad del código resultante. Mi favorito personal es el último de los ejemplos. En ese ejemplo usé *Expansión de la abrazadera* para generar las palabras; pero también hay otras formas.

Veamos más de cerca este último ejemplo, porque si bien parece el más fácil de los dos, a menudo puede ser el más complicado si no sabes exactamente cómo funciona.

Como mencioné antes: `for` recorre una lista de palabras y coloca cada una en la variable de índice del bucle, una a la vez, y luego recorre el cuerpo con ella. La parte complicada es cómo decide Bash cuáles son las palabras. Permítanme explicarme expandiendo las llaves del ejemplo anterior:

```bash
$ for i in 10 9 8 7 6 5 4 3 2 1
> do echo "$i latas de cerveza vacías."
> done
```

Bash toma los caracteres entre `in` y el final de la línea y los divide en palabras. Esta división se realiza en espacios y tabulaciones, al igual que la división de argumentos. Sin embargo, si hay sustituciones sin comillas, también se dividirán en palabras (usando [IFS](https://mywiki.wooledge.org/IFS)). Todas estas palabras divididas se convierten en elementos de iteración.

Por lo tanto, tenga *MUCHO cuidado* de no cometer el siguiente error:

```bash
$ ls
The best song in the world.mp3
$ for file in $(ls *.mp3)
> do rm "$file"
> done
rm: cannot remove `The': No such file or directory
rm: cannot remove `best': No such file or directory
rm: cannot remove `song': No such file or directory
rm: cannot remove `in': No such file or directory
rm: cannot remove `the': No such file or directory
rm: cannot remove `world.mp3': No such file or directory
```

Ya deberías saber que debes citar el `$file` en la declaración `rm`; pero ¿qué está fallando aquí? Bash expande la sustitución del comando (`$(ls *.mp3)`), lo reemplaza por su salida y *luego* realiza una división de palabras en él (porque no estaba entre comillas). Básicamente, Bash ejecuta `for file in The best song in the world.mp3`. *Boom, estás muerto*.

¿Quieres citarla, dices? Agreguemos otra canción:

```bash
$ ls
The best song in the world.mp3  The worst song in the world.mp3
$ for file in "$(ls *.mp3)"
> do rm "$file"
> done
rm: cannot remove `The best song in the world.mp3  The worst song in the world.mp3': No such file or directory
```

Las comillas protegerán los espacios en blanco de los nombres de archivo, pero harán más que eso. Las comillas protegerán **todos los espacios en blanco** de la salida de `ls`. No hay forma de que Bash pueda saber qué partes de la salida de `ls` representan nombres de archivo; no es algo psíquico. La salida de `ls` es una cadena simple y Bash la trata como tal. El `for` pone toda la salida entre comillas en `i` y ejecuta el comando `rm` con ella. *Maldita sea, muerto de nuevo*.

¿Qué hacemos entonces? Como sugerimos antes, los globs son tus mejores amigos:

```bash
$ for file in *.mp3
> do rm "$file"
> done
```

Esta vez, Bash **sí** sabe que está tratando con nombres de archivos, y **sí** sabe cuáles son los nombres de archivos y, como tal, puede dividirlos de manera ordenada. El resultado de expandir el glob es este: `for file in "The best song in the world.mp3" "The worst song in the world.mp3"` ¡Problema resuelto!

Ahora veamos el bucle `while`. El bucle `while` es muy interesante por su capacidad de ejecutar comandos hasta que ocurra algo interesante. A continuación, se muestran algunos ejemplos de cómo se utilizan con mucha frecuencia los bucles `while`:

```bash
$ # 
$ while read -p $'The sweet machine.\nInsert 20c and enter your name: ' name
> do echo "The machine spits out three lollipops at $name."
> done
```

```bash
$ # Revise su correo electrónico cada cinco minutos.
$ while sleep 300
> do kmail --check
> done
```

```bash
$ # Espere a que un host vuelva a estar en línea.
$ while ! ping -c 1 -W 1 "$host"
> do echo "$host aún no está disponible."
> done; echo -e "$host está disponible nuevamente.\a"
```

El bucle `until` casi nunca se utiliza, aunque sólo sea porque es prácticamente exactamente igual que `while !`. Podríamos reescribir nuestro último ejemplo utilizando un bucle `until`:

```bash
$ # Espere a que un host vuelva a estar en línea.
$ until ping -c 1 -W 1 "$host"
> do echo "$host aún no está disponible."
> done; echo -e "$host está disponible nuevamente.\a"
```

En la práctica, la mayoría de la gente simplemente utiliza `while !`.

Por último, puedes usar la instrucción incorporada `continue` para saltar a la siguiente iteración de un bucle sin ejecutar el resto del cuerpo, y la instrucción incorporada `break` para salir del bucle y continuar con el script que lo siguió. Esto funciona tanto en bucles `for` como `while`.

> **En el manual.**
>
> [Looping Constructs](http://www.gnu.org/software/bash/manual/bashref.html#Looping-Constructs)

> **En preguntas frecuentes. **
>
> - [¿Cómo puedo ejecutar un comando en todos los archivos con la extensión .gz?](https://mywiki.wooledge.org/BashFAQ/015)
> - [¿Cómo puedo utilizar números con ceros a la izquierda en un bucle, por ejemplo, `01`, `02`?](https://mywiki.wooledge.org/BashFAQ/018)
> - [¿Cómo puedo encontrar y tratar nombres de archivos que contienen nuevas líneas, espacios o ambos?](https://mywiki.wooledge.org/BashFAQ/020)
> - [¿Cómo puedo cambiar el nombre de todos mis archivos `*.foo` a `*.bar`, o convertir espacios en guiones bajos, o convertir nombres de archivos en mayúsculas a minúsculas?](https://mywiki.wooledge.org/BashFAQ/030)
> - [¿Puedo hacer un spinner en Bash?](https://mywiki.wooledge.org/BashFAQ/034)
> - [Quiero comprobar si una palabra está en una lista (o un elemento es miembro de un conjunto).](https://mywiki.wooledge.org/BashFAQ/046)

- *Loop*
: Un bucle es una estructura diseñada para repetir el código que contiene hasta que se cumpla una determinada condición. En ese momento, el bucle se detiene y se ejecuta el código que lo sigue.
- `for` (keyword)
: Un bucle `for` es un tipo de bucle que asigna a una variable cada uno de los valores de una lista por turno y se repite hasta que se agota la lista.
- `while` (keyword)
: Un bucle `while` es un tipo de bucle que continúa ejecutando su código siempre que un determinado comando (ejecutado antes de cada iteración) se ejecute correctamente.
- `until` (keyword)
: Un bucle `until` es un tipo de bucle que continúa ejecutando su código hasta que un determinado comando (ejecutado antes de cada iteración) se ejecute sin éxito.

## Opciones (`case` y `select`)

A veces, se desea crear la lógica de la aplicación en función del contenido de una variable. Esto se puede implementar tomando una rama diferente de una declaración `if` en función de los resultados de la prueba con un glob:

```bash#!highlight bash
shopt -s extglob
if ![ $LANG = en* ]( $LANG = en* ); then
    echo 'Hello!'
elif ![ $LANG = fr* ]( $LANG = fr* ); then
    echo 'Salut!'
elif ![ $LANG = de* ]( $LANG = de* ); then
    echo 'Guten Tag!'
elif ![ $LANG = nl* ]( $LANG = nl* ); then
    echo 'Hallo!'
elif ![ $LANG = it* ]( $LANG = it* ); then
    echo 'Ciao!'
elif ![ $LANG = es* ]( $LANG = es* ); then
    echo 'Hola!'
elif [POSIX) ]( $LANG = @(C); then
    echo 'hello world'
else
    echo 'I do not speak your language.'
fi
```

Pero todas estas comparaciones son un poco redundantes. Bash proporciona una palabra clave llamada `case` exactamente para este tipo de situación. Una declaración `case` básicamente enumera varios *patrones globales* posibles y verifica el contenido de su parámetro con respecto a estos:

```bash#!highlight bash
case $LANG in
    en*) echo 'Hello!' ;;
    fr*) echo 'Salut!' ;;
    de*) echo 'Guten Tag!' ;;
    nl*) echo 'Hallo!' ;;
    it*) echo 'Ciao!' ;;
    es*) echo 'Hola!' ;;
    C|POSIX) echo 'Hola Mundo' ;;
*)   echo 'No hablo su idioma.' ;;
esac
```

Cada opción en una declaración `case` consiste en un patrón (o una lista de patrones con `|` entre ellos), un paréntesis derecho, un bloque de código que se ejecutará si la cadena coincide con uno de esos patrones y dos puntos y coma para indicar el final del bloque de código (ya que es posible que necesite escribirlo en varias líneas).

Se puede agregar un paréntesis izquierdo a la izquierda del patrón. El uso de `;&` en lugar de `;;` le otorgará la capacidad de pasar por alto la coincidencia de `case` en bash, zsh y ksh. `case` deja de coincidir patrones tan pronto como uno tiene éxito. Por lo tanto, podemos usar el patrón `*` al final para coincidir con cualquier caso que no haya sido detectado por las otras opciones.

Cuando se encuentra un patrón coincidente y se utiliza el operador `;&` después del bloque de código, entonces también se ejecutará el bloque de código para la siguiente opción (si hay alguna), sin importar si el patrón para esa opción coincide o no. Para "caer" a través de varios patrones consecutivos, utilice el operador `;&` para todos excepto el último.

Cuando se encuentra un patrón coincidente y se utiliza el operador `;;&` después del bloque de código, en lugar del bloque de código para la *siguiente* opción, se ejecutará el bloque de código para el *siguiente patrón coincidente* (si lo hay).

Otra construcción de elección es la construcción `select`. Esta declaración parece un bucle y es una declaración de conveniencia para generar un menú de opciones entre las que el usuario puede elegir.

Se le presentan al usuario varias opciones y se le pide que ingrese un número que refleje su elección. Luego, se ejecuta el código en el bloque `select` con una variable establecida en la opción elegida por el usuario. Si la opción del usuario no es válida, la variable se deja vacía:

```bash
$ echo "¿Cuál de estos no pertenece al grupo?"; \
> select choice in Apples Pears Crisps Lemons Kiwis; do
> if ![ $choice = Crisps ]( $choice = Crisps )
> then echo "¡Correcto! Las patatas fritas no son fruta."; break; fi
> echo "Error... Inténtalo de nuevo."
> done
```

El menú vuelve a aparecer mientras no se ejecute la instrucción `break`. En el ejemplo, la instrucción `break` solo se ejecuta cuando el usuario realiza la elección correcta.

También podemos utilizar la variable `PS3` para definir el mensaje al que responde el usuario. En lugar de mostrar la pregunta antes de ejecutar la instrucción `select`, podríamos optar por configurar la pregunta como mensaje:

```bash
$ PS3="¿Cuál de estos no pertenece al grupo (#)?"; \
> select choice in Apples Pears Crisps Lemons Kiwis; do
> if ![ $choice = Crisps ]( $choice = Crisps )
> then echo "¡Correcto! Las patatas fritas no son fruta."; break; fi
> echo "Error... Inténtalo de nuevo."
> done
```

Todas estas construcciones condicionales (`if`, `for`, `while` y `case`) se pueden *anidar*. Esto significa que podría tener un bucle `for` con un bucle `while` dentro de él, o cualquier otra combinación, tan profundamente como necesite para resolver su problema.

```bash
# A simple menu:
while true; do
    echo "Welcome to the Menu"
    echo "  1. Say hello"
    echo "  2. Say good-bye"

    read -p "-> " response
    case $response in
        1) echo 'Hello there!' ;;
        2) echo 'See you later!'; break ;;
*) echo 'What was that?' ;;
    esac
done

# Alternative: use a variable to terminate the loop instead of an
# explicit break command.

quit=
while test -z "$quit"; do
    echo "...."
    read -p "-> " response
    case $response in
        ...
        2) echo 'See you later!'; quit=y ;;
        ...
    esac
done
```

> **Buenas prácticas.**
>
> Una sentencia `select` simplifica un menú simple, pero no ofrece mucha flexibilidad. Si desea algo más elaborado, es posible que prefiera escribir su propio menú utilizando un bucle while, algunos comandos echo o printf y un comando read. 

> **En el manual.**
>
> [Conditional Constructs](http://www.gnu.org/software/bash/manual/bashref.html#Conditional-Constructs)

> **En preguntas frecuentes.**
>
> - [Quiero comprobar si `[[ $var == foo` o `$var == bar` o `$var = more ...` sin repetir `$var` n veces.](https://mywiki.wooledge.org/BashFAQ/066)
> - [¿Cómo puedo manejar fácilmente los argumentos de la línea de comandos (opciones) de mi script?](https://mywiki.wooledge.org/BashFAQ/035)

> **Revisar.**
>
> - `case` (keyword)
> : La declaración `case` evalúa el valor de un parámetro frente a varios patrones (opciones) dados.
> - `select` (keyword)
> : La instrucción `select` ofrece al usuario la posibilidad de elegir entre varias opciones y ejecuta un bloque de código con la elección del usuario en un parámetro. El menú se repite hasta que se ejecuta un comando `break`.

[&#8612; Patrones](base_url/guia/patrones.html) &#8231; [Arrays &#8614;](base_url/guia/array.html)

[Página original](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)
