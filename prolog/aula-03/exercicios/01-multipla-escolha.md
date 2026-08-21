# Listas em Prolog

Dada a consulta `[A, B | Resto] = [10, 20, 30, 40]`, quais os valores de
`A`, `B` e `Resto`?

* [ ] `A = 10`, `B = 20`, `Resto = 30`
* [*] `A = 10`, `B = 20`, `Resto = [30, 40]`
* [ ] `A = [10]`, `B = [20]`, `Resto = [30, 40]`
* [ ] A consulta falha, pois a lista tem elementos demais.

## Justificativa

`[A, B | Resto]` casa `A` com o 1º elemento, `B` com o 2º, e `Resto` com a
**cauda restante** — que é sempre uma lista, mesmo que tenha mais de um
elemento. Aqui `Resto` fica com `[30, 40]`.
