+++
title = '110. ¿Cómo copio un archivo a un sistema remoto y especifico un nombre remoto que puede contener espacios?'
date = 2023-10-01T08:02:50-03:00
draft = false
+++

Todas las herramientas comunes para copiar archivos a un sistema
remoto (ssh, scp, rsync) envían el nombre del archivo como parte de un
comando de shell, que el sistema remoto interpreta. Esto hace que el
problema sea extremadamente complejo, porque el shell remoto a menudo
alterará el nombre del archivo. Hay al menos tres formas de solucionar
el problema: NFS, codificación cuidadosa del nombre del archivo o
envío del nombre del archivo como parte del flujo de datos.
