# Representação de termos e operadores

Qual termo composto corresponde à expressão `1 + 2 * 3` escrita sem usar
notação de operadores?

* [*] `+(1, *(2, 3))`
* [ ] `*(+(1, 2), 3)`
* [ ] `+(*(1, 2), 3)`
* [ ] `soma(1, produto(2, 3))`

## Justificativa

`*` tem prioridade menor que `+` (prende mais forte), então `2 * 3` é avaliado
primeiro e vira o segundo argumento de `+`, resultando em `+(1, *(2, 3))`. Isso
pode ser confirmado com `write_canonical/1`.
