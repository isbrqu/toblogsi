+++
title = '72. ¿Cómo puedo asegurarme de que mi entorno esté configurado para cron, batch y jobs?'
date = 2023-10-01T03:10:15-03:00
draft = false
+++

Si un shell u otro script que llama a comandos del shell se ejecuta
bien de forma interactiva pero falla debido a configuraciones del
entorno (por ejemplo: un `$PATH` complejo) cuando se ejecuta de forma no
interactiva, deberá forzar que su entorno se configure correctamente.
