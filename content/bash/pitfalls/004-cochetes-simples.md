+++
title = '4. [ $foo = "bar" ]'
date = 2023-12-21T00:00:00-00:00
draft = false
+++

Esto es muy similar al [problema número 2](../002-variables-sin-comillas-dobles), pero lo repito porque es muy importante. En código del titulo, las comillas están en el lugar equivocado. No es necesario citar una cadena literal en bash (a menos que contenga metacaracteres o caracteres de patrón). Pero debes citar tus variables si no estás seguro de si pueden contener espacios en blanco o comodines.

Este puede fallar por varias razones:

- Si una variable a la que se hace referencia en `[` no existe o está en blanco, entonces el comando `[` terminaría luciendo así:
```bash
[ = "bar" ] # Wrong!
```
...y arrojará el error: `unary operator expected`. (El operador `=` es _binario_, no unario, por lo que el comando `[` se sorprende bastante al verlo allí).

- Si la variable contiene espacios en blanco internos, entonces se [divide en palabras separadas](#WordSplitting) antes de que el comando `[` la vea. De este modo:
```bash
[ multiple words here = "bar" ]
```
Si bien esto puede parecerle correcto, es un error de sintaxis en lo que respecta a `[`. La forma correcta de escribir esto es:
```bash
# POSIX
[ "$foo" = bar ] # Right!
```

Esto funciona bien en implementaciones compatibles con POSIX incluso si `$foo` comienza con `-`, porque POSIX `[` determina su acción dependiendo de la cantidad de argumentos que se le pasan. Sólo los shells muy antiguos tienen problemas con esto, y no deberías preocuparte por ellos cuando escribas código nuevo (consulta la solución alternativa `x"$foo"` a continuación).

En Bash y muchos otros shells similares a ksh, existe una alternativa superior que utiliza la [keyword \[\[](#BashFAQ/031).
```bash
# Bash / Ksh
[[ $foo == bar ]] # Right!
```

No es necesario el entrecomillado de variables en el lado izquierdo de `=` en `[[ ]]` porque no se someten a división de palabras ni [globbing](#glob), e incluso se manejarán variables en blanco. correctamente. Por otro lado, entrecomillarlo tampoco vendrá mal. A diferencia de `[` y `test`, también puedes usar el mismo `==`. Sin embargo, tenga en cuenta que las comparaciones que utilizan `[[` realizan coincidencias de patrones con la cadena del lado derecho, no solo una simple comparación de cadenas. Para que la cadena de la derecha sea literal, debe entrecomillarla si se utiliza algún carácter que tenga un significado especial en contextos de coincidencia de patrones.

```bash
# Bash / Ksh
match=b*r
[[ $foo == "$match" ]] # Good! Sin comillas también coincidiría con el patrón b*r..
```

Es posible que hayas visto un código como este:
```bash
# POSIX / Bourne
[ x"$foo" = xbar ] # Ok, pero por lo general innecesario.
```

El truco `x"$foo"` es necesario para el código que debe ejecutarse en shells ''muy'' antiguos que carecen de [\[\[](#BashFAQ/031|) y tienen un `[` más primitivo, que [se confunde](https://www.vidarholen.net/contents/blog/?p=1035) si `$foo` comienza con `-` o es `!` o `(`. En dichos sistemas más antiguos, `[` solo requiere precaución adicional para el token en el lado izquierdo de `=`; maneja el token de la derecha correctamente.

Tenga en cuenta que los shells que requieren esta solución no son compatibles con POSIX. Esta portabilidad extrema rara vez es un requisito y hace que su código sea menos legible (y más feo).