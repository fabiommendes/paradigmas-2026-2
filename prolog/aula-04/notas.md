# Números e CLPFD

Até agora usamos `=` para unificação estrutural. Para fazer contas, Prolog
tem dois mundos distintos: os operadores **primitivos** (`is/2` e afins) e a
biblioteca de **restrições** CLPFD.

## Operações aritméticas

`is/2` avalia uma expressão aritmética à direita e unifica o resultado com o
termo à esquerda:

```prolog
?- X is 2 + 3 * 4.
X = 14.
```

Operadores comuns: `+`, `-`, `*`, `/`, `//` (divisão inteira), `mod`/`rem`
(resto), `**`/`^` (potência). Para comparar sem unificar, existem os
comparadores aritméticos `=:=`, `=\=`, `<`, `>`, `=<`, `>=`, que também
avaliam os dois lados antes de comparar — diferente de `=` (unificação) e
`==` (identidade estrutural), que nunca fazem contas:

```prolog
?- 1 + 1 = 2.
false.          % 1+1 e 2 são termos diferentes, = não avalia

?- 1 + 1 =:= 2.
true.            % =:= avalia os dois lados e compara os números
```

Veja `exemplos/aritmetica.pl`.

## Operadores primitivos vs CLPFD

O problema de `is/2` e dos comparadores aritméticos: a expressão precisa
estar **totalmente instanciada** — sem nenhuma variável livre — ou a
consulta lança um erro. Ou seja, eles só calculam, não resolvem equações.

A biblioteca **CLPFD** (`library(clpfd)`, *Constraint Logic Programming over
Finite Domains*) troca os operadores primitivos por versões que registram
**restrições** em vez de calcular na hora: `#=`, `#\=`, `#<`, `#>`, `#=<`,
`#>=`. Como uma restrição não precisa ser resolvida imediatamente, ela
funciona mesmo com variáveis livres, e em qualquer direção:

```prolog
?- use_module(library(clpfd)).
?- X + 1 #= 5.
X = 4.
```

Veja `exemplos/clpfd.pl`.

## Programação com restrições

Para usar CLPFD por completo, além das restrições sobre expressões,
declaramos o **domínio** de cada variável — o conjunto de valores que ela
pode assumir:

* `X in 1..10` restringe uma variável a um intervalo.
* `Lista ins 0..9` aplica o mesmo domínio a várias variáveis de uma vez.
* `all_different(Lista)` restringe as variáveis da lista a valores
  distintos entre si.
* `label(Lista)` dispara a **busca**: percorre os domínios até encontrar
  valores concretos que satisfaçam todas as restrições acumuladas.

Sem `label/1`, uma variável com restrições fica "em aberto" — o Prolog sabe
que ela só pode valer, por exemplo, `8`, `9` ou `10`, mas ainda não decidiu
qual. Veja `exemplos/clpfd.pl`.

## Fatorial: funções vs busca e generalidade

`exemplos/fatorial.pl` reescreve o fatorial (já visto de relance na aula 1)
nos dois estilos:

* `fat_is/2`, com `is/2`, calcula `fat_is(5, F)` normalmente, mas
  `fat_is(N, 120)` falha com erro — `N > 0` não pode ser avaliado sem `N`
  conhecido. É uma **função**: só serve numa direção.
* `fat_clpfd/2`, com CLPFD, calcula nos dois sentidos: `fat_clpfd(5, F)` dá
  `F = 120`, e `fat_clpfd(N, 120)` **busca** e encontra `N = 5`.

A diferença não é só sintática: `is/2` avalia passo a passo, já `#=`
registra a restrição e deixa a busca do CLPFD achar valores consistentes —
por isso o mesmo predicado consegue ser mais **geral**.

## Problemas de criptoaritmética

Um problema clássico de restrições: em `SEIS + SEIS = DOZE`, cada letra
representa um dígito de 0 a 9, letras diferentes têm dígitos diferentes, e
a primeira letra de cada número não pode ser 0. Resolver é achar quais
dígitos tornam a soma verdadeira.

`exemplos/criptoaritmetica.pl` monta isso em CLPFD: uma variável CLPFD por
letra, `all_different/1` para garantir dígitos distintos, uma restrição
`#=` para a soma (cada palavra vira `d1*1000 + d2*100 + ...`), e `label/1`
para buscar a solução — achando `SEIS = 3643` e `DOZE = 7286`. O arquivo
também traz `DOIS + TRES = CINCO`, para tentar resolver por conta própria.

## Exercícios

Ver pasta `exercicios/`.
