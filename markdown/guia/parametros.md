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

[Página original](https://mywiki.wooledge.org/BashGuide/Parameters)
