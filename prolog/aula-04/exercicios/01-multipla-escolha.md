# Números e CLPFD

Considere a consulta `X is Y + 1.`, com `Y` ainda sem valor definido. O que
acontece?

* [ ] `X` fica associado a uma expressão simbólica `Y + 1`.
* [ ] A consulta simplesmente falha (`false`), sem erro.
* [*] A consulta lança um erro de instanciação, pois `is/2` exige que a
  expressão à direita esteja totalmente conhecida.
* [ ] `Y` é automaticamente ligado a `0`, e `X` recebe `1`.

## Justificativa

`is/2` **avalia** a expressão aritmética à direita antes de unificar o
resultado com `X` -- para isso, todos os valores da expressão precisam ser
números conhecidos. Como `Y` é uma variável livre, `is/2` não tem como
calcular `Y + 1` e lança `error(instantiation_error, ...)`. Isso é diferente
de `#=` (CLPFD), que registra a restrição em vez de avaliar na hora, e por
isso funciona mesmo com `Y` livre.
