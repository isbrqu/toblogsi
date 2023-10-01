+++
title = '114. ¿Cómo opero con direcciones IP y máscaras de red?'
date = 2023-10-01T08:15:21-03:00
draft = false
+++

Las direcciones IPv4 son enteros sin signo de 32 bits. La notación
"cuadrete con puntos" (192.168.1.2) es sólo una forma de representar
dicha dirección. Al aplicar máscaras de red, es más fácil si primero
convertimos el formato cuádruple de puntos en un entero simple.

Hay varias formas de hacer esto, pero esta es una de las más sencillas:

```bash
ip2int() {
  local o       # array of octets (bytes)
  IFS=. read -ra o <<<"$1"
  echo "$(((o[0] << 24) + (o[1] << 16) + (o[2] << 8) + o[3]))"
}

int2ip() {
  echo "\
$((($1 >> 24) & 0xFF)).\
$((($1 >> 16) & 0xFF)).\
$((($1 >>  8) & 0xFF)).\
$(($1 & 0xFF))"
}
```

Usando estas funciones, podemos convertir hacia adelante y hacia
atrás:

```bash
$ ip2int 192.168.10.1
3232238081
$ int2ip 3232238081
192.168.10.1
```

Para aplicar una máscara de red, la convertimos a un número entero y
luego realizamos una operación AND bit a bit para obtener la parte de
la red:

```bash
$ ip2int 255.255.255.0
4294967040
$ echo $((3232238081 & 4294967040))
3232238080
$ int2ip 3232238080
192.168.10.0
```

La parte del host es similar: primero negamos la máscara de red y
luego hacemos el mismo AND bit a bit. Después de negar, tenemos que
tomar sólo los 32 bits más bajos; de lo contrario, los enteros de 64
bits de bash podrían darnos resultados extraños.

```bash
$ echo $((~4294967040 & 0xffffffff))
255
$ echo $((3232238081 & 255))
1
$ int2ip 1
0.0.0.1
```

El mismo principio se aplica a una máscara de red de cualquier tamaño.
Por ejemplo, una máscara de red /23 tiene el siguiente aspecto:

```bash
$ int2ip $((0xfffffe00))
255.255.254.0
$ int2ip $((2#11111111111111111111111000000000))
255.255.254.0
```

La constante hexadecimal 0xfffffe00 es la misma que la constante
binaria 2#111111111111111111111111000000000 pero es más conveniente de
escribir y más fácil de verificar para un humano.
