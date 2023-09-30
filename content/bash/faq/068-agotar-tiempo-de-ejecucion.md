+++
title = '68. ¿Cómo ejecuto un comando y hago que se cancele (se agote el tiempo de espera) después de N segundos?'
date = 2023-09-30T14:27:57-03:00
draft = false
+++

PRIMERO verifique si se le puede indicar al comando que está
ejecutando que expire el tiempo de espera directamente. Los métodos
descritos aquí son soluciones "piratas" para forzar la finalización de
un comando después de que haya transcurrido un cierto tiempo. Siempre
es preferible configurar su comando correctamente a las alternativas
siguientes.
