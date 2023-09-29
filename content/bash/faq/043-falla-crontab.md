+++
title = '43. ¿Por qué falla mi trabajo crontab? 0 0 * * * algún comando > /var/log/mylog.`date +%Y%m%d`'
date = 2023-09-29T01:21:43-03:00
draft = false
+++

En muchas versiones de `crontab`, el signo de porcentaje (%) se trata de
manera especial y, por lo tanto, se le debe agregar barras invertidas
como carácter de escape:
