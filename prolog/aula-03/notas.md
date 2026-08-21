# Listas em Prolog

Listas são a estrutura de dados mais usada em Prolog para representar
sequências de valores — números, átomos, outras listas, o que for.

## Criando listas

Uma lista se escreve entre colchetes, com os elementos separados por vírgula:

```prolog
?- L = [1, 2, 3].
L = [1, 2, 3].
```

Os elementos podem ser de tipos diferentes, inclusive outras listas:

```prolog
?- L = [maca, 3, [1, 2], "texto"].
```

A lista vazia é o átomo especial `[]`. Por baixo dos panos, toda lista não
vazia é só um termo composto de aridade 2 — cabeça e cauda — encadeado até
terminar em `[]`. `[1,2,3]` é açúcar sintático para `[1|[2|[3|[]]]]`. No
SWI-Prolog, `functor/3` revela esse termo interno:

```prolog
?- functor([1,2,3], F, A).
F = '[|]', A = 2.
```

Veja `exemplos/criando_listas.pl`.

## Cabeça e cauda de listas

A notação `[Cabeca|Cauda]` é a forma de decompor (ou construir) uma lista via
unificação: `Cabeca` é o primeiro elemento e `Cauda` é o restante — que é,
ele próprio, uma lista.

```prolog
?- [H|T] = [maca, pera, uva].
H = maca, T = [pera, uva].
```

Dá para casar vários elementos do início de uma vez, `[A, B | Resto]`, e
`[X]` (cauda `[]`) só bate com uma lista de exatamente um elemento. Se a
lista tiver menos elementos do que o padrão pede, a unificação simplesmente
falha. Veja `exemplos/cabeca_cauda.pl`.

## Recursão e manipulação de listas

Como uma lista é cabeça + cauda (que também é lista), predicados sobre
listas quase sempre seguem o mesmo molde recursivo: um **caso base** para a
lista vazia, e um **caso recursivo** que resolve a cauda e combina o
resultado com a cabeça.

```prolog
tamanho([], 0).
tamanho([_|T], N) :- tamanho(T, N0), N is N0 + 1.
```

`exemplos/recursao.pl` reimplementa dessa forma alguns predicados clássicos
— `tamanho/2` (como `length/2`), `soma/2` (como `sum_list/2`) e `pertence/2`
(como `member/2`). Repare que `pertence/2` não serve só para testar: com
`findall/3` ele também **gera** os elementos da lista por backtracking.

`exemplos/manipulacao.pl` traz `concatena/3` (como `append/3`) e `inverte/2`
(como `reverse/2`). Um efeito interessante da unificação bidirecional:
`concatena/3` também acha como **dividir** uma lista em duas partes, sem
precisar de um predicado separado para isso.

Todos esses predicados já vêm prontos na biblioteca padrão do SWI-Prolog, e
devem ser preferidos no código real: `append/3`, `reverse/2`, `length/2`,
`member/2`, `nth0/3`, `last/2`, `sum_list/2`. Reimplementá-los aqui é só para
entender como a recursão sobre listas funciona por dentro.

## Exercícios

Ver pasta `exercicios/`.
