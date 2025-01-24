---
title: 'Introducción'
...

Se le invita a realizar adiciones o modificaciones siempre que pueda mantener la precisión. Pruebe cualquier ejemplo de código que escriba.

Toda la información aquí presentada se presenta sin garantía alguna de exactitud. Úsela bajo su propio riesgo. En caso de duda, consulte las páginas de manual o las páginas de información de GNU como referencias autorizadas.

## Acerca de esta guía

Actualmente se está redactando [una nueva versión de esta guía](https://guide.bash.academy). Por ahora, esta guía sigue siendo la más completa y la que ha recibido mejores críticas. Se aceptan contribuciones a la nueva guía a través de [forks de GitHub](https://github.com/lhunath/bash.academy).

Esta guía tiene como objetivo ayudar a las personas interesadas en aprender a trabajar con BASH. Su objetivo es enseñar buenas técnicas prácticas para usar [BASH](https://mywiki.wooledge.org/BASH) y escribir scripts simples.

Esta guía está dirigida a usuarios principiantes. No se requieren conocimientos avanzados, solo la capacidad de iniciar sesión en un sistema tipo Unix y abrir una interfaz de línea de comandos (terminal). Será de ayuda saber cómo utilizar un editor de texto; no cubriremos los editores ni recomendamos ninguna opción de editor en particular. No se requiere familiaridad con el conjunto de herramientas fundamentales de Unix ni con otros lenguajes de programación o conceptos de programación, pero quienes tengan ese conocimiento podrán comprender algunos de los ejemplos más rápidamente.

Si algo no le queda claro, le invitamos a informarlo (utilice [Bash Guide Feedback](https://mywiki.wooledge.org/BashGuideFeedback) o el canal `#bash` en [irc.libera.chat](https://libera.chat)) para que pueda aclararse en este documento para futuros lectores.

Está invitado a contribuir al desarrollo de este documento ampliándolo o corrigiendo información inválida o incompleta.

The primary maintainer(s) of this document:

- [Lhunath](https://mywiki.wooledge.org/Lhunath) (primary author)
- [GreyCat](https://mywiki.wooledge.org/GreyCat)

La guía también está disponible en [formato PDF](https://s.ntnu.no/bashguide.pdf). Otra opción es imprimirla después de acceder a [FullBashGuide](https://mywiki.wooledge.org/FullBashGuide). Esto garantiza que imprimirá la versión más reciente de este documento.

## Una definición

BASH es el acrónimo de **B**ourne **A**gain **Sh**ell. Está basado en Bourne Shell y es compatible en gran medida con sus características.

Los shells son intérpretes de comandos. Son aplicaciones que brindan a los usuarios la capacidad de dar comandos a su sistema operativo de manera interactiva o ejecutar lotes de comandos rápidamente. De ninguna manera son necesarios para la ejecución de programas; son simplemente una capa entre las llamadas a funciones del sistema y el usuario.

Piense en un shell como una forma de comunicarse con su sistema. Su sistema no lo necesita para la mayor parte de su trabajo, pero es una excelente interfaz entre usted y lo que su sistema puede ofrecer. Le permite realizar cálculos matemáticos básicos, ejecutar pruebas básicas y ejecutar aplicaciones. Más importante aún, le permite combinar estas operaciones y conectar aplicaciones entre sí para realizar tareas complejas y automatizadas.

BASH **no** es su sistema operativo. No es su gestor de ventanas. No es su terminal (pero a menudo se ejecuta _dentro_ de su terminal). No controla su ratón ni su teclado. No configura su sistema, no activa su protector de pantalla ni abre sus archivos cuando hace doble clic en ellos. Por lo general, no interviene en el lanzamiento de aplicaciones desde su gestor de ventanas o entorno de escritorio.  Es importante entender que BASH es sólo una interfaz para ejecutar instrucciones (utilizando la sintaxis de BASH), ya sea en el indicador interactivo de BASH o a través de scripts de BASH.

> **[En el manual: Introducción](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Introduction)**
>
> _Shell_ : Un intérprete de comandos (posiblemente interactivo), que actúa como una capa entre el usuario y el sistema.
>
> _Bash_ : The Bourne Again Shell, un shell compatible con _Bourne_.

## Usando Bash

La mayoría de los usuarios que piensan en BASH lo consideran como un _prompt_ y una línea de comandos. Eso es BASH en modo _interactivo_. BASH también puede ejecutarse en modo _no interactivo_, como cuando se ejecutan scripts. Podemos usar scripts para automatizar cierta lógica. Los scripts son básicamente listas de comandos (como los que se pueden escribir en la línea de comandos), pero almacenados en un archivo. Cuando se ejecuta un script, todos estos comandos se ejecutan (generalmente) secuencialmente, uno tras otro.

Comenzaremos con los conceptos básicos en un shell _interactivo_. Una vez que esté familiarizado con ellos, podrá combinarlos en scripts.

**¡Importante!**

**Debes familiarizarte con los comandos `man` y `apropos` del shell. Te resultarán fundamentales para tu autoaprendizaje.**

```bash
$ man man
$ man apropos
```

En esta guía, el `$` al principio de una línea representa el indicador de comandos de BASH. Tradicionalmente, un indicador de comandos de shell termina con `$`, `%` o `#`. Si termina con `$`, esto indica un shell compatible con Bourne Shell (como un shell POSIX, un shell Korn o Bash). Si termina con `%`, esto indica un _C shell_ (csh o tcsh); esta guía no cubre el shell C. Si termina con `#`, esto indica que el shell se está ejecutando como la cuenta de superusuario del sistema (`root`), y que debe tener mucho cuidado.

El mensaje de BASH real probablemente será mucho más largo que `$`. Los mensajes suelen ser muy individualizados.

El comando `man` significa "manual"; abre documentación (las llamadas "páginas man") sobre varios temas. Se utiliza ejecutando el comando `man [topic]` en el indicador de BASH, donde `[topic]` es el nombre de la "página" que desea leer.  Tenga en cuenta que muchas de estas "páginas" son considerablemente más largas que una página impresa; sin embargo, el nombre persiste. Es probable que cada comando (aplicación) en su sistema tenga una página man. También hay páginas para otras cosas, como llamadas al sistema o archivos de configuración específicos. En esta guía, solo cubriremos los comandos.

Tenga en cuenta que si busca información sobre los comandos integrados de BASH (comandos proporcionados por BASH, no por aplicaciones externas), debería buscar en `man bash`. El manual de BASH es extenso y detallado. Es una excelente referencia, aunque más técnica que esta guía.

Bash también ofrece un comando `help` que contiene breves resúmenes de sus comandos integrados (que analizaremos en profundidad más adelante).

```bash
$ help
$ help read
```

> En FAQ:
> [¿Existe una lista de las características que se agregaron a versiones específicas de Bash?](https://mywiki.wooledge.org/BashFAQ/061)
>
> _Modo interactivo_ : Un modo de operación en el que un mensaje le solicita un comando a la vez.
>
> _Script_ : Archivo que contiene una secuencia de comandos para ejecutar uno tras otro.


## Contenido

La guía se ha dividido en secciones, que se deben leer aproximadamente en el orden en que se presentan. Si se salta una sección específica, es posible que se pierda información de fondo de las secciones anteriores. (No siempre se proporcionan enlaces a las secciones pertinentes cuando se menciona un tema).

- [Comandos y argumentos](comandos-y-argumentos.html): Tipos de comandos; división de argumentos; escritura de scripts.
- [Caracteres especiales](caracteres-especiales.html).
- [Parámetros](parametros.html): Parámetros Variables; parámetros especiales; tipos de parámetros; expansión de parámetros.
- [Patronas](https://mywiki.wooledge.org/BashGuide/Patterns): Globs; coincidencia de nombre de archivo; globs extendidos; expansión de llaves; expresiones regulares.
- [Tests y condicionales](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals): Estado de salida; `&&` y `||`; `if`, `test` y `[[`; `while`, `until` y `for`; `case` y `select`.
- [Arrays](https://mywiki.wooledge.org/BashGuide/Arrays): Arrays; arrays asociativos.
- [Comandos compuestos](https://mywiki.wooledge.org/BashGuide/CompoundCommands): Subshells; agrupación de comandos; evaluación aritmética; funciones; alias.
- [Sourcing](https://mywiki.wooledge.org/BashGuide/Sourcing): Leyendo comandos de otros archivos.
- [Control de trabajo](https://mywiki.wooledge.org/BashGuide/JobControl).
- [Prácticas](https://mywiki.wooledge.org/BashGuide/Practices): Elegir su shell; citar; legibilidad; depuración.


[Página original](https://mywiki.wooledge.org/BashGuide)
