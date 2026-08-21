# Termos e operadores de Prolog

## Representação de termos e operadores

Já vimos que um termo composto se escreve como `functor(arg1, arg2, ...)`.
Vários functores comuns, porém, têm uma notação especial como
**operadorers** — por exemplo `1 + 2` é açúcar sintático para `+(1, 2)`, e
`a :- b, c` é açúcar sintático para `:-(a, ','(b, c))`.

Operadores podem ser:

* **Infixos** — ficam entre os argumentos: `1 + 2`.
* **Prefixos** — ficam antes de um argumento: `- 1` (menos unário).
* **Sufixos** — ficam depois de um argumento.

O mesmo operador pode aparecer em mais de uma forma diferente. Por exemplo,
o operador `+` existe na forma infixa, como em `1 + 2` e na forma prefixa
como em `+ 1`.

## Formas canônicas de termos

A notação com operadores é só uma forma mais legível de escrever o mesmo
termo. O predicado `write_canonical/1` mostra a forma funcional pura, sem
operadores — útil para entender "o que o Prolog realmente vê" por trás da
sintaxe açucarada. Veja `exemplos/canonica.pl`.

## Declarando operadores

Podemos criar nossos próprios operadores com a diretiva `op(Prioridade, Tipo,
Nome)`:

```prolog
:- op(500, xfx, é_progenitor_de).

homer é_progenitor_de bart.
```

* **Prioridade**: um número que define a precedência (operadores de menor
  prioridade "prendem" mais forte os argumentos).
* **Tipo**: indica se o operador é infixo/prefixo/sufixo e como ele se associa
  — `xfx` (infixo, não associativo), `yfx`/`xfy` (infixo associativo à
  esquerda/direita), `fy`/`fx` (prefixo), `yf`/`xf` (sufixo).

Veja `exemplos/operador.pl`, que declara `é_progenitor_de` como operador
infixo e um sufixo `!` de teste.

## Representação homoicônica de termos

Prolog é **homoicônico**: código e dado compartilham a mesma representação —
um termo. Isso permite inspecionar e construir termos em tempo de execução:

* `Termo =.. Lista` (operador *univ*) decompõe um termo em uma lista
  `[Functor | Argumentos]`, e também funciona ao contrário, construindo um
  termo a partir de uma lista.
* `functor(Termo, Nome, Aridade)` extrai (ou constrói) o nome do functor e sua
  aridade.

Veja `exemplos/homoiconico.pl`.

## Consultas e unificação

Ao processar uma consulta, o Prolog tenta **unificar** o objetivo com a
cabeça de fatos/regras da base de conhecimento. Unificação:

* associa variáveis livres a valores que tornam os dois termos idênticos;
* falha se os functores ou aridades forem diferentes, ou se os valores forem
  incompatíveis.

O operador `=/2` expõe a unificação
diretamente numa consulta:

```prolog
?- foo(A, b) = foo(1, B).
A = 1,
B = b.
```

Veja `exemplos/unificacao.pl` para casos de sucesso e falha.

## Aridade de termos

A **aridade** é o número de argumentos de um termo composto. Termos com o
mesmo nome de functor mas aridades diferentes são predicados **distintos** —
por exemplo `soma/3` e `soma/4` não têm relação alguma entre si, mesmo tendo
o mesmo nome. Veja `exemplos/aridade.pl`.
