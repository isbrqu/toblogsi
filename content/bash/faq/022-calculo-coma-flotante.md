+++
title = '22. How can I calculate with floating point numbers instead of just integers?'
date = 2023-09-27T21:37:11-03:00
draft = false
+++

La [aritmética](#) incorporada de [BASH](#) solo utiliza números enteros:

```bash
$ printf '%s\n' "$((10 / 3))"
3
```
