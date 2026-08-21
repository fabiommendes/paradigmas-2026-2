# Introdução ao Prolog

Prolog é uma linguagem de **programação lógica**: em vez de descrever passo a
passo *como* resolver um problema, descrevemos *fatos* e *regras* sobre o
mundo, e deixamos que o interpretador encontre as respostas através de busca e
unificação.

## Instalação

Vamos usar o **SWI-Prolog** (versão >= 9.1.12).

* **Linux**: normalmente disponível no gerenciador de pacotes da distribuição,
  por exemplo `sudo apt install swi-prolog` (Debian/Ubuntu). Se a versão do
  repositório for antiga, use o PPA oficial:
  `sudo apt-add-repository ppa:swi-prolog/stable && sudo apt update && sudo apt install swi-prolog`.
* **macOS**: `brew install swi-prolog`.
* **Windows**: baixe o instalador em https://www.swi-prolog.org/Download.html.

Para conferir a instalação, rode no terminal:

```
swipl --version
```

Para carregar um arquivo e abrir o prompt de consultas:

```
swipl exemplos/hello.pl
```

O prompt `?-` indica que o Prolog está pronto para receber consultas. Para
sair, digite `halt.` ou `Ctrl+D`.

## Sintaxe básica

Um programa Prolog é uma sequência de **termos**, dos seguintes tipos:

* **Átomos**: valores fixos, sempre em minúsculo — `homer`, `marge`, `azul`.
* **Números**: `0`, `39`, `3.14`.
* **Variáveis**: começam com letra maiúscula ou `_` — `X`, `Pessoa`, `_Resto`.
  Representam um valor ainda desconhecido.
* **Termos compostos**: um functor seguido de argumentos entre parênteses —
  `progenitor(homer, bart)`, `idade(lisa, 8)`.

Veja `exemplos/hello.pl`:

```prolog
:- write('hello world!'), nl.
```

A diretiva `:- Objetivo` manda o Prolog **executar** `Objetivo` assim que o
arquivo é carregado — aqui, escrever um texto e pular uma linha (`nl`).

## Fatos, regras, programas e consultas

* Um **fato** afirma algo que é sempre verdadeiro: `homem(homer).`
* Uma **regra** define algo em função de outras coisas, com `:-` separando a
  cabeça da regra do seu corpo (lido como "se"):

  ```prolog
  irmx(X, Y) :-
      progenitor(Z, X),
      progenitor(Z, Y),
      X \= Y.
  ```

  Ou seja: "X e Y são irmãos-x se ambos têm o mesmo progenitor Z e X é
  diferente de Y".
* O conjunto de fatos e regras carregados forma um **programa** (a base de
  conhecimento).
* Uma **consulta** (query) pergunta ao Prolog se algo pode ser provado a
  partir do programa, digitada no prompt `?-` do interpretador:

  ```prolog
  ?- homem(homer).
  true.

  ?- progenitor(homer, X).
  X = bart ;
  X = lisa ;
  X = maggie.
  ```

Para rodar os exemplos: `swipl exemplos/simpsons.pl` e depois digitar
consultas no prompt `?-`.

## Exemplo: árvore genealógica

`exemplos/simpsons.pl` define os fatos básicos (quem é homem/mulher, quem é
progenitor de quem, idades). `exemplos/familia.pl` consulta esse arquivo e
constrói regras derivadas — irmão/irmã, tio/tia, primo/prima — combinando
fatos simples de `progenitor/2` com unificação e o operador `\=` (diferente).

Experimente:

```prolog
?- consult('exemplos/familia.pl').
?- irmao(bart, X).
?- tia(X, bart).
?- primo(X, Y).
```

`exemplos/game_of_thrones.pl` traz um segundo conjunto de fatos, no mesmo
formato de `simpsons.pl`. Trocando o `consult('simpsons.pl')` no topo de
`familia.pl` por `consult('game_of_thrones.pl')`, as mesmas regras de
parentesco passam a valer para a outra família — um bom exercício para ver
como a mesma lógica se aplica a dados diferentes.

`exemplos/fat.pl` mostra uma prévia de recursão em Prolog (fatorial). Ele usa
a biblioteca CLPFD (`#>`, `#=`), que veremos com calma em uma aula futura —
por ora, repare apenas como a recursão troca `n * fat(n - 1)` por uma cláusula
base (`fat(0, 1)`) e uma cláusula recursiva.
