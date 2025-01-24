---
title: 'Comandos y argumentos'
...

BASH lee comandos de su entrada (que suele ser una terminal o un archivo). Cada linea de entrada que lee es tratada como un comando -- una instrucción para ser llevado a cabo. Hay pocos casos avanzados, como comandos que ocupan varias líneas, que serán tratadas después.

Bash divide cada linea entre *palabras* que son demarcadas por un caracter en blaco (espacios o tabuladores). La primera palabra de la linea es el nombre del comando para ser ejecutado. Todas las palabras restantes seran *argumentos* para ese comando (options, filenmaes, etc.).

Asumiendo que estamos en un directorio vacio... (probar estos comandos, crear un directorio vacío llamado *test* y entrar a ese directorio para correr: `mkdir test; cd test`):

```bash
$ ls     # Lista los archivos in el actual directorio (sin salida, sin archivos).
$ touch  # Crea los archivos 'a', 'b' y 'c'.
$ ls     # Lista los archivos de nuevo, y esta vez muestra: 'a', 'b' y 'c'.
a b c
```

El comando `ls` imprime los nombres de los archivos en el directorio actual. La primera vez que corremos la lista de comandos no obtenemos salida, porque no hay archivos todadavía.

El caracter `#` al principio de una palabra indica un comentario. Cualquier palabra seguida del comentario son ignoradas por la shell, destinado solo para leer. Si corremos el ejemplo en nuestra shell, no tenemos que tipear los comentarios; pero incluso si lo hacemos, el comando seguirá funcionando.

El comando `touch` es una aplicación que cambia el dato de la *última modificación* de un archivo. Si el nombre del archivo que se proporciona aún no existe, crea un nuevo archivo vacío y con ese nombre.

```bash
$ rm *            # Eliminar todos los archivos del directorio actual.
$ ls              # Lista de archivos en el directorio actual (sin salida, sin archivos).
$ touch a   b c   # Crea los archivos 'a', 'b' y 'c'.
$ ls              # Enumere los archivos nuevamente; esta vez las salidas: 'a', 'b' y 'c'.
a  b  c
```

El comando `rm` es una aplicación que elimina todos los archivos que se le han asignado. [`*`](https://mywiki.wooledge.org/glob) es un glob. Básicamente significa todo y en este caso significa todos los archivos del directorio actual. Hablaremos más sobre globs más adelante.

Ahora, ¿nos dimos cuenta de que hay varios espacios entre `a` y `b`, y solo uno entre `b` y `c`? Además, observe que los archivos que se crearon con `touch` no son diferentes a los de la primera vez. ¡La cantidad de espacios en blanco entre los argumentos no importa! Es importante saber esto. Por ejemplo:

```
$ echo Esto es una prueba.
Esto es una prueba.
$ echo Esto    es    una    prueba.
Esto es una prueba.
```

`echo` es un comando que imprime sus argumentos en la salida estándar (que en nuestro caso es la terminal). En este ejemplo, proporcionamos al comando echo cuatro argumentos: 'Esto', 'es', 'una' y 'prueba.'. echo toma estos argumentos y los imprime uno por uno con un espacio entre ellos. En el segundo caso, sucede exactamente lo mismo. Los espacios adicionales no hacen ninguna diferencia. Si queremos el espacio adicional, necesitamos pasar la oración como un solo argumento. Podemos hacer esto usando comillas:

```
$ echo "Esto    es    una    prueba."
Esto    es    una    prueba.
```

Las comillas agrupan todo lo que hay dentro de ellas en un único argumento. El argumento es: `'Esto    es    una    prueba.'`... específicamente espaciado. Tenga en cuenta que las comillas no son parte del argumento: Bash las elimina antes de pasarle el argumento a echo. echo imprime este único argumento como lo hace siempre.

Tenga mucho cuidado de evitar lo siguiente:

```
$ ls                                          # Hay dos archivos en el directorio actual.
The secret voice in your head.mp3  secret
$ rm The secret voice in your head.mp3        # Ejecuta rm con 6 argumentos; ¡no 1!
rm: cannot remove `The': No such file or directory
rm: cannot remove `voice': No such file or directory
rm: cannot remove `in': No such file or directory
rm: cannot remove `your': No such file or directory
rm: cannot remove `head.mp3': No such file or directory
$ ls                                          # Lista de archivos en el directorio actual: todavía está allí.
The secret voice in your head.mp3             # ¡Pero tu archivo 'secreto' ahora ha desaparecido!
```

Debemos asegurarnos de que entrecomillar los nombres de archivo correctamente. Si no lo hacemos, terminaremos eliminando las cosas incorrectas. `rm` toma los nombres de archivo como argumentos. Si nuestros nombres de archivo tienen espacios y no los entrecomillamos, Bash piensa que cada palabra es un argumento separado. Bash le entrega cada argumento a `rm` por separado. Como si fueran rebanadas de queso procesado envueltas individualmente, `rm` trata cada argumento como un archivo separado.

En el ejemplo anterior, `rm` intentó eliminar un archivo por cada palabra del nombre de archivo de la canción, en lugar de mantener el nombre del archivo intacto. Eso provocó que se eliminara nuestro archivo secreto y que nuestra canción quedara intacta.

Esto es lo que deberíamos haber hecho:

```bash
$ rm "The secret voice in your head.mp3"
```

Los argumentos se separan del nombre del comando y entre sí mediante un espacio en blanco. Es importante recordar esto. Por ejemplo, lo siguiente es incorrecto:

```
$ [-f file]
bash: [-f: command not found
```

Esto tiene como objetivo comprobar la existencia de un archivo llamado "file". Es razonable suponer que los espacios en blanco alrededor de "[" y "]" no importan, pero `[` es en realidad un comando y requiere que su último argumento sea `]`. (Trataremos el comando `[` con más detalle [más adelante](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)). Por lo tanto, debemos separar `[` de `-f` y `]` de file, de lo contrario Bash pensará que estamos intentando ejecutar un comando llamado `[-f` con un solo argumento `file]`. El comando correcto separa todos los argumentos con espacios en blanco:

(Vemos muchas personas que están confundidas por este comportamiento; creen que pueden omitir el espacio en blanco entre éste y sus argumentos, por lo que debemos presentar este ejemplo particular al principio).

Y, si nuestro nombre de archivo contiene espacios en blanco u [otros caracteres especiales](https://mywiki.wooledge.org/BashGuide/SpecialCharacters), también debe ir entre comillas:

```bash
$ [ -f "my file" ]
```

Eche un vistazo a [argumentos](https://mywiki.wooledge.org/Arguments), [comillas](https://mywiki.wooledge.org/Quotes) y [división de palabras](https://mywiki.wooledge.org/WordSplitting) si todo esto aún no le ha quedado muy claro. Es importante tener una buena comprensión de cómo el shell interpreta los espacios en blanco y los caracteres especiales antes de continuar con esta guía.

> - *Argumentos*
: Son palabras adicionales especificadas después del comando (`ls -l foo` ejecuta `ls` con dos argumentos).
> - *Comillas*
: Las dos formas de comillas, simples y dobles (`'` y `"`), se utilizan para agrupar palabras y pueden proteger caracteres especiales. La diferencia entre `'` y `"` se analizará más adelante.

> **Consejo.**
>
> Siempre entrecomille oraciones o cadenas que vayan juntas, incluso si no es absolutamente necesario. Esta práctica  reducirá el riesgo de error humano en los scripts (por ejemplo, entrecomillar una oración de un comando `echo`).

> **En las preguntas frecuentes.**
>
> - ¡Estoy intentando poner un comando en una variable, pero los casos complejos siempre fallan! [BashFAQ/050](https://mywiki.wooledge.org/BashFAQ/050).
> - ¿Cómo puedo gestionar fácilmente los argumentos de la línea de comandos (opciones) de mi script? [BashFAQ/035](https://mywiki.wooledge.org/BashFAQ/035).

## Cadenas

El término *cadena* se refiere a una secuencia de caracteres que se trata como una sola unidad. El término se utiliza de forma imprecisa en esta guía, así como en casi todos los demás lenguajes de programación.

En la programación Bash, casi todo es una cadena. Cuando escribimos un comando, el nombre del comando es una cadena y cada argumento es una cadena; los nombres de las variables son cadenas y el contenido de las variables también; un nombre de archivo es una cadena y la mayoría de los archivos contienen cadenas. ¡Están en todas partes!

Un comando completo también puede considerarse una cadena. Este no suele ser un punto de vista útil, pero ilustra el hecho de que *partes* de cadenas a veces pueden considerarse cadenas por derecho propio. Una cadena que forma parte de una cadena más grande se denomina *subcadena*.

Las cadenas no tienen ningún significado intrínseco. Su significado se define según cómo y dónde se utilizan.

Probemos con otro ejemplo. Con el editor, escriba una lista de compras y guárdela con el nombre de archivo "lista" y utilice `cat` para imprimirlo:

```bash
$ cat lista
shampoo
tejidos
leche (descremada, no entera)
```

Escribimos un comando: `cat list`. El shell lee este comando como una cadena y luego lo divide en las subcadenas `cat` y `list`. En lo que respecta al shell, `list` no tiene significado, es solo una cadena con cuatro caracteres. `cat` recibe el argumento `list`, que es una cadena con un nombre de archivo. La cadena `list` se volvió significativa debido a *cómo se utilizó*.

Resulta que el archivo contiene un texto que vemos en nuestra terminal. El contenido completo del archivo, tomado como un todo, es una cadena, pero esa cadena no tiene significado. Sin embargo, si dividimos el archivo en líneas (y, por lo tanto, tratamos cada línea como una cadena separada), entonces vemos que cada línea individual tiene significado.

Podemos dividir la línea final en palabras, pero estas palabras no tienen significado por sí mismas. No podemos comprar "(descremada" en la tienda y podríamos comprar el tipo de "leche" equivocado. Dividir las líneas en palabras no es algo útil en este ejemplo. Pero la shell no sabe nada de esto, ¡sólo nosotros lo sabemos!

Por lo tanto, cuando trabajamos con comandos, datos y variables (todos los cuales son simplemente cadenas para el shell), tenemos *toda* la responsabilidad. Necesitamos asegurarnos de que todo lo que necesita estar separado se separe correctamente y que todo lo que necesita permanecer unido se mantenga unido correctamente. Abordaremos estos conceptos repetidamente a medida que avancemos.

## Tipos de comandos

Bash entiende varios tipos diferentes de comandos: alias, funciones, comandos integrados, palabras clave y ejecutables.

### Alias

Un alias es una forma de abreviar un comando. (Solo se utilizan en shells **interactivos** y *no* en scripts; esta es una de las pocas diferencias entre un script y un shell interactivo). Un alias es una *palabra* que se asigna a una determinada *cadena*. Siempre que esa *palabra* se utiliza como nombre de un comando, se reemplaza por la *cadena* antes de ejecutar el comando. Por lo tanto, en lugar de ejecutar:

```bash
$ nmap -Pn -A --osscan-limit 192.168.0.1
```

Podríamos usar un alias como este:

```bash
$ alias nmapp="nmap -Pn -A --osscan-limit"
$ nmapp 192.168.0.1
```

Los alias tienen un poder limitado; el reemplazo solo ocurre en la primera palabra. Para tener más flexibilidad, use una función. Los alias solo son útiles como atajos de texto simples.

### Funciones

Las funciones en Bash son algo así como alias, pero más potentes. A diferencia de los alias, se pueden usar en **scripts**. Una función contiene comandos de shell y actúa de forma muy similar a un pequeño script; incluso puede tomar argumentos y crear variables locales. Cuando se llama a una función, se ejecutan los comandos que contiene. Las funciones se tratarán en profundidad [más adelante en la guía](https://mywiki.wooledge.org/BashGuide/CompoundCommands#Functions).

### Elementos incorporados (Builtins)

Bash tiene algunos comandos básicos integrados, como cd (cambiar directorio), echo (escribir salida), etc. Se pueden considerar funciones que ya están incluidas.

### Palabras clave (keywords)

Las palabras clave son como las incorporadas, con la principal diferencia de que las palabras clave son en realidad sintaxis de Bash y pueden analizarse utilizando reglas especiales. Por ejemplo, `[` es una incorporada de Bash, mientras que `[[` es una palabra clave de Bash; ambas se utilizan para [probar una variedad de condiciones](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals). Aquí intentamos usarlas para comparar las palabras "*a*" y "*b*" lexicográficamente:

```bash
$ [ a < b ]
-bash: b: No such file or directory
$ [[ a < b ]]
```

El primer ejemplo devuelve un error porque, como es habitual, Bash trata a `<` como un [operador de redirección de archivo](https://mywiki.wooledge.org/BashGuide/InputAndOutput#File_Redirection) e intenta redirigir el archivo inexistente `b` al comando `[ a ]`. El segundo ejemplo funciona porque Bash analiza las palabras entre `[[` y `]]` utilizando reglas diferentes que no utilizan `<` para la redirección.

### Ejecutables

El último tipo de comando que puede ejecutar Bash es un *ejecutable*. (Los ejecutables también pueden llamarse *comandos externos* o *aplicaciones*). Los ejecutables se invocan comúnmente escribiendo solo su nombre. Esto se puede hacer porque una variable predefinida le da a conocer a Bash una lista de rutas de archivos ejecutables comunes. Esta variable se llama `PATH`. Es un conjunto de nombres de directorio separados por dos puntos (p. ej. `/usr/bin:/bin`). Cuando se especifica un comando (p. ej. `myprogram` o `ls`) sin una ruta de archivo (y no es un alias, una función, un comando incorporado o una palabra clave), Bash busca en los directorios en `PATH`. La búsqueda se realiza en orden, de izquierda a derecha, para ver si contienen un ejecutable del comando escrito.

Si el ejecutable está *fuera* de una ruta conocida... será necesario definir la ruta del archivo ejecutable. Para un ejecutable en el directorio actual, utilice `./myprogram`; si está en el directorio `/opt/somedirectory`, utilice `/opt/somedirectory/myprogram`.

> **Revisar.**
>
> - *Alias*
: Palabra que se asigna a una cadena. Siempre que se utiliza esa palabra como comando, se reemplaza por la cadena a la que se ha asignado.
> - *Función*
: Nombre que se asigna a un conjunto de comandos. Siempre que se utiliza la función como comando, se la llama con los argumentos que la siguen. Las funciones son el método básico para crear nuevos comandos.
> - *Builtin*
: Un comando que se ha incorporado a Bash. Los comandos incorporados se manejan directamente mediante el ejecutable de Bash y no crean nuevos procesos.
> - *Palabra clave*
: Un comando que forma parte de la sintaxis de Bash. Bash puede analizar las palabras clave de forma diferente a los comandos normales.
> - *Ejecutable*
: Un programa que puede ejecutarse haciendo referencia a su ruta de archivo (por ejemplo, `/bin/ls`), o simplemente por su nombre si su ubicación está en la variable `PATH`.

> **En el manual.**
>
> — [Comandos simples](http://www.gnu.org/software/bash/manual/bashref.html#Simple-Commands)


> **En las preguntas frecuentes.**
>
> - [¿Cuál es la diferencia entre `test`, `[` y `[[`?](https://mywiki.wooledge.org/BashFAQ/031)
> - [¿Cómo puedo crear un alias que acepte un argumento?](https://mywiki.wooledge.org/BashFAQ/080)

> **Consejo**
>
> El comando `type` se puede utilizar para obtener una descripción del tipo de comando:

```bash
$ type rm
rm is hashed (/bin/rm)
$ type cd
cd is a shell builtin
```

## Scripts

Un script es básicamente una secuencia de comandos en un archivo. Bash lee el archivo y procesa los comandos **en orden**. Pasa al siguiente comando solo cuando el actual ha **finalizado**. (La excepción es si se ha especificado que un comando se ejecute de forma asincrónica, en segundo plano. No te preocupes demasiado por este caso todavía; aprenderemos cómo funciona más adelante).

Prácticamente cualquier ejemplo que exista en la línea de comandos en esta guía también se puede utilizar en un script.

Crear un script es fácil. Comienza creando un nuevo archivo y pon esto en la primera línea:

```bash
#!/bin/bash
```

El encabezado se denomina *directiva de interpretación* (también se denomina *hashbang* o *shebang*). Especifica que `/bin/bash` se utilizará como intérprete cuando el archivo se utilice como ejecutable en un comando. Cuando el kernel ejecuta un archivo no binario, lee la primera línea del archivo. Si la línea comienza con `#!`, el kernel utiliza la línea para determinar el intérprete al que retransmitir el archivo. (También existen otras formas válidas de hacer esto, consulte a continuación). El #! debe estar al principio del archivo, sin espacios ni líneas en blanco antes. Los comandos de nuestro script aparecerán en líneas separadas debajo de esto.

> - Consejo: En lugar de `#!/bin/bash`, puedes usar: `#!/usr/bin/env bash`.
>
> `env` busca en `$PATH` el ejecutable nombrado por su primer argumento (en este caso, "bash"). Para obtener una explicación más detallada de esta técnica y en qué se diferencia del simple `#!/bin/bash`, consulte esta pregunta en [StackOverflow](https://stackoverflow.com/questions/16365130/what-is-the-difference-between-usr-bin-env-bash-and-usr-bin-bash/16365367#16365367).


No se deje engañar por scripts o ejemplos en Internet que utilizan `/bin/sh` como intérprete. **¡`sh` no es `bash`!** Bash en sí es un shell "compatible con sh" (lo que significa que puede ejecutar la mayoría de los scripts "sh" y tiene gran parte de la misma sintaxis); sin embargo, lo opuesto no es cierto; algunas características de `bash` pueden fallar o causar un comportamiento inesperado en `sh`.

Además, absténgase de darle a los scripts la extensión `.sh`. No sirve para nada y es completamente engañoso (ya que será un script `bash`, no un script `sh`).

Está perfectamente bien utilizar Windows para escribir scripts. Evite, sin embargo, utilizar el **Bloc de notas** (Notepad). "Microsoft Notepad" sólo puede crear archivos con finales de línea de estilo DOS. Los finales de línea de estilo DOS terminan con dos caracteres: un **C**arriage Return (ASCII CR; 0xD) y un carácter de **L**ine **F**eed (ASCII LF; 0xA). Bash entiende finales de línea con sólo caracteres de avance de línea (**L**ine **F**eed). Como resultado, el carácter de retorno de carro (**C**arriage **R**eturn) causará una sorpresa inesperada si uno no sabe que está allí (mensajes de error muy extraños). Si es posible, utilice un editor más potente como [*Vim*](http://vim.org), [*Emacs*](http://gnu.org/software/emacs), *kate*, *GEdit...* Si no lo hace, será necesario eliminar los retornos de carro de los scripts antes de ejecutarlos.

Una vez creado el archivo de script, se puede ejecutar haciendo lo siguiente:

```bash
$ bash miscript
```

En este ejemplo, ejecutamos `bash` y le indicamos que lea el script. Cuando lo hacemos así, la línea `#!` es solo un comentario, Bash no hace nada con ella.

Alternativamente, podemos otorgarles a nuestros scripts permisos de ejecución. Con este método, en lugar de llamar a Bash manualmente, podemos ejecutar el script como una aplicación:

```bash
$ chmod +x miscript  # Marcar el archivo como ejecutable.
$ ./miscript         # Ahora, myscript se puede ejecutar directamente en lugar de tener que pasarlo a bash.
```

Cuando ejecutamos el comando de esta manera, el sistema operativo (OS) usa la línea `#!` para determinar qué intérprete usar.

Para decidir dónde colocar el script, existen un par de alternativas. Generalmente, a la gente le gusta mantener sus scripts en un directorio definido personalmente; esto evita que su script interfiera con otros usuarios en el sistema. A algunos les gusta mantener sus scripts en un directorio preexistente en `PATH`, porque estas personas piensan que nunca cometerán un error.

Para utilizar un directorio personal:

```bash
$ mkdir -p "$HOME/bin"
$ echo 'PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
$ source "$HOME/.bashrc"
```

El primer comando creará un directorio llamado `bin` dentro de su *directorio de inicio* (el directorio que le pertenece a usted personalmente). Es tradicional que los directorios que contienen comandos se llamen `bin`, incluso cuando esos comandos son scripts y no programas compilados ("binarios"). El segundo comando agrega una línea que contiene la asignación de una variable a un archivo. La variable es `PATH` y estamos agregando esta línea al archivo de configuración de Bash (`.bashrc`). Cada nueva instancia interactiva de Bash ahora buscará scripts ejecutables en nuestro nuevo directorio antes de verificar cualquier directorio que ya estuviera en `PATH`. El tercer comando le dice a Bash que vuelva a leer su archivo de configuración.

Algunas personas prefieren utilizar un directorio diferente para guardar sus scripts personales, como `$HOME/.config/bin` o `$HOME/.local/bin`. Puedes utilizar el que prefieras, siempre y cuando seas coherente.

Los cambios en el archivo de configuración de Bash no tendrán un efecto inmediato; debemos realizar el paso de volver a leer el archivo. En el ejemplo anterior, usamos `source "$HOME/.bashrc"`.

También podríamos haber usado `exec bash`, o podríamos cerrar la terminal existente y abrir una nueva. Bash se inicializaría nuevamente leyendo `.bashrc` (y posiblemente otros archivos).

En cualquier caso, ahora podemos poner nuestro script en nuestro directorio `bin` y ejecutarlo como un comando normal; ya no necesitamos anteponer la ruta del archivo al nombre de nuestro script (que era la parte `./` en el ejemplo anterior):

```bash
$ mv myscript "$HOME/bin"
$ myscript
```

**Además:**

> - Consejo: si el sistema tiene varias versiones de bash instaladas, puede ser conveniente especificar el intérprete por ruta absoluta para garantizar que se use la versión de bash correcta. Por ejemplo: `#!/usr/bin/bash`. Escriba "`type -a bash`" para imprimir las rutas de todos los ejecutables de Bash en `PATH`.
> - Consejo: El intérprete puede ir seguido opcionalmente de una palabra de las opciones del intérprete. Por ejemplo, las siguientes opciones activarán la depuración detallada: "`#!/usr/bin/bash -x`". Para obtener más información, consulte [Depuración](https://mywiki.wooledge.org/BashGuide/Practices#Debugging).
> Consejo: después de definir el intérprete en el encabezado, se recomienda resumir el propósito de los scripts. Si lo desea, puede incluir información sobre los derechos de autor...:
```bash
#!/usr/bin/env bash
# scriptname - a short explanation of the scripts purpose.
#
# Copyright (C) <date> <name>...
#
# scriptname [option] [argument] ...
```

[&#8612; Introducción](introduccion.html) &#8231; [Caracteres especiales &#8614;](caracteres-especiales.html)

[Página original](https://mywiki.wooledge.org/BashGuide/CommandsAndArguments)
