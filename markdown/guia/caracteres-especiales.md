---
title: 'Caracteres especiales'
...

Bash evalúa algunos caracteres como si tuvieran un significado no literal. En cambio, estos caracteres llevan a cabo una instrucción especial o tienen un significado alternativo; se denominan "caracteres especiales" o "metacaracteres".

A continuación se muestran algunos de los usos más comunes de caracteres especiales:

 <table>
  <tr>
    <th>Caracter</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>`" "`</td>
    <td>
      _Espacio en blanco_: Es una tabulación, una nueva línea, una tabulación vertical, un avance de página, un retorno de carro o un espacio. Bash utiliza espacios en blanco para determinar dónde comienzan y terminan las palabras. La primera palabra es el nombre del comando y las palabras adicionales se convierten en argumentos de ese comando.
    </td>
  </tr>
  <tr>
    <td>`$`</td>
    <td>
      _Expansión_: Presenta varios tipos de expansión: expansión de parámetros (p. ej., `$var` o `${var}`), [sustitución de comandos](https://mywiki.wooledge.org/CommandSubstitution) (p. ej., `$(comando)`) o expansión aritmética (p. ej., `$((expresión))`). Más adelante hablaremos más sobre las expansiones.
    </td>
  </tr>
  <tr>
    <td>`""`</td>
    <td>
      _Comillas simples_: Protegen el texto que contienen para que tenga un significado _literal_. Con ellas, generalmente se ignora cualquier tipo de interpretación de Bash: se pasan por alto los caracteres especiales y se evita que se dividan varias palabras.
    </td>
  </tr>
  <tr>
    <td>`""`</td>
    <td>
      _Comillas dobles_: Protegen el texto dentro de ellas para que no se divida en múltiples palabras o argumentos, pero permiten que se realicen sustituciones; generalmente se evita el significado de la mayoría de los demás caracteres especiales.
    </td>
  </tr>
  <tr>
    <td>`\`</td>
    <td>
      _Escape_ (barra invertida): Evita que el siguiente carácter se interprete como un carácter especial. Funciona fuera de las comillas, dentro de las comillas dobles y, por lo general, se ignora en las comillas simples.
    </td>
  </tr>
  <tr>
    <td>`#`</td>
    <td>
      _Comentario_: El carácter `#` comienza un comentario que se extiende hasta el final de la línea. Los comentarios son notas explicativas y no son procesados por el shell.
    </td>
  </tr>
  <tr>
    <td>`=`</td>
    <td>
      _Asignación_: asigna un valor a una variable (por ejemplo, `logdir=/var/log/myprog`). No se permiten espacios en blanco en ninguno de los lados del carácter `=`.
    </td>
  </tr>
  <tr>
    <td>`[[ ]]`</td>
    <td>
      _Prueba_: evaluación de una expresión condicional para determinar si es "verdadera" o "falsa". Las pruebas se utilizan en Bash para comparar cadenas, comprobar la existencia de un archivo, etc. Más adelante se explicarán más detalles sobre este tema.
    </td>
  </tr>
  <tr>
    <td>`!`</td>
    <td>
      _Negar_: Se utiliza para negar o revertir un estado de prueba o de salida. Por ejemplo: `! grep text file; exit $?`.
    </td>
  </tr>
  <tr>
    <td>`>`, `>>`, `<`</td>
    <td>
      _Redirección_: Redirigir la salida o la entrada de un comando a un archivo. Las redirecciones se tratarán más adelante.
    </td>
  </tr>
  <tr>
    <td>`|`</td>
    <td>
      _Canalización_: Envía la salida de un comando a la entrada de otro comando. Este es un método para encadenar comandos. Ejemplo: `echo "Hola hermosa." | grep -o hermosa`.
    </td>
  </tr>
  <tr>
    <td>`;`</td>
    <td>
      _Separador de comandos_: Se utiliza para separar varios comandos que están en la misma línea.
    </td>
  </tr>
  <tr>
    <td>`{ }`</td>
    <td>
      _Grupo en línea_: Los comandos dentro de las llaves se tratan como si fueran un solo comando. Es conveniente usarlos cuando la sintaxis de Bash requiere solo un comando y no parece justificada una función.
    </td>
  </tr>
  <tr>
    <td>`( )`</td>
    <td>
      _Grupo de subshell_: Similar al anterior, pero donde los comandos que contiene se ejecutan en un [subshell](https://mywiki.wooledge.org/SubShell) (un nuevo proceso). Se utiliza de forma muy similar a un sandbox; si un comando provoca efectos secundarios (como cambiar variables), no tendrá ningún efecto en el shell actual.
    </td>
  </tr>
  <tr>
    <td>`(( ))`</td>
    <td>
      _Expresión aritmética_: En una [expresión aritmética](https://mywiki.wooledge.org/ArithmeticExpression), los caracteres como `+`, `-`, `*` y `/` son operadores matemáticos que se utilizan para realizar cálculos. Se pueden utilizar para asignaciones de variables como `((a = 1 + 4))` y también para realizar pruebas como `if (( a < b ))`. Más adelante hablaremos más sobre esto.
    </td>
  </tr>
  <tr>
    <td>`$(( ))`</td>
    <td>
      _Expansión aritmética_: Comparable a la anterior, pero la expresión se reemplaza con el resultado de su evaluación aritmética. Ejemplo: `echo "El promedio es $(( (a+b)/2 ))"`.
    </td>
  </tr>
  <tr>
    <td>`*`, `?`</td>
    <td>
      _Globs_: Caracteres "comodín" que coinciden con partes de nombres de archivos (por ejemplo, `ls *.txt`).
    </td>
  </tr>
  <tr>
    <td>`~`</td>
    <td>
      _Directorio personal_: la tilde es una representación de un directorio personal. Cuando está sola o seguida de `/`, significa el directorio personal del usuario actual; de lo contrario, se debe especificar un nombre de usuario (p. ej., `ls ~/Documents; cp ~john/.bashrc .`).
    </td>
  </tr>
  <tr>
    <td>`&`</td>
    <td>
      _Fondo_: Cuando se usa al final de un comando, ejecuta el comando en segundo plano (no espera a que se complete).
    </td>
  </tr>
</table>

Ejemplos:

```bash
$ echo "Yo soy $LOGNAME"
Yo soy lhunath
$ echo 'Yo soy $LOGNAME'
Yo soy $LOGNAME
$ # boo
$ echo Un espacio\ \ \ abierto
Un espacio   abierto
$ echo "Mi computadora es $(hostname)"
Mi computadora es Lyndir
$ echo boo > file
$ echo $(( 5 + 5 ))
10
$ (( 5 > 0 )) && echo "Cinco es mayor a cero."
Cinco es mayor a cero.
```

## Caracteres especiales obsoletos (reconocidos, pero no recomendados)

Bash también evaluará este grupo de caracteres como si tuvieran un significado no literal, pero generalmente se incluyen solo por compatibilidad con versiones anteriores. No se recomienda su uso, pero suelen aparecer en scripts antiguos o mal escritos.

<table>
  <tr>
    <th>Caracter</th>
    <th>Descripción</th>
  </tr>
  <tr>
    <td>`` ` ` ``</td>
    <td>
      [Sustitución de comando](https://mywiki.wooledge.org/CommandSubstitution): utilice `$( )` en su lugar.
    </td>
  </tr>
  <tr>
    <td>`[ ]`</td>
    <td>
      Test: un alias del antiguo comando `test`. Se utiliza habitualmente en scripts de shell POSIX. Carece de muchas funciones de `[[ ]]`.
    </td>
  </tr>
  <tr>
    <td>`$[ ]`</td>
    <td>
      [Expresión aritmética](https://mywiki.wooledge.org/ArithmeticExpression): Utilice `$(( ))` en su lugar.
    </td>
  </tr>
</table>

**Además:**

- **En el manual**: [Sintaxis del shell](http://www.gnu.org/software/bash/manual/html_node/Shell-Syntax.html#Shell-Syntax)
- Caracteres especiales: Caracteres que tienen un significado especial para Bash. Normalmente, se interpreta su significado y luego se eliminan del comando antes de ejecutarlo.

[Página original](https://mywiki.wooledge.org/BashGuide/SpecialCharacters)
