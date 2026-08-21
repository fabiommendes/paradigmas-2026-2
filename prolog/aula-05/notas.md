# Problemas combinatórios

CLPFD (visto na aula passada) não serve só para contas simples — é a
ferramenta certa para problemas **combinatórios**, onde a resposta é achada
testando entre muitas combinações possíveis.

## Problema N-queens

O problema das N-rainhas: posicionar N rainhas em um tabuleiro N×N sem que
nenhuma ataque outra (mesma linha, coluna ou diagonal).

`exemplos/queens_lib.pl` representa uma solução como uma lista `Posicoes`
com N elementos, onde o valor na posição `I` é a coluna da rainha da linha
`I` — assim, "mesma linha" já está descartado por construção. Sobra
garantir:

* **Mesma coluna**: `all_different(Posicoes)`.
* **Mesma diagonal**: duas rainhas nas colunas `Q0` e `Q`, separadas por
  `D` linhas, estão na mesma diagonal se `abs(Q0 - Q) =:= D`. O predicado
  `seguras/1` percorre a lista comparando cada rainha com as seguintes,
  incrementando a distância `D` a cada passo.

```prolog
rainhas(N, Posicoes) :-
    length(Posicoes, N),
    Posicoes ins 1..N,
    all_different(Posicoes),
    seguras(Posicoes),
    label(Posicoes).
```

Veja `exemplos/queens.pl`, que carrega `queens_lib.pl` e mostra uma solução
para N=8, além de contar as 92 soluções existentes com `findall/3`.

## Estratégias de busca e labeling()

`label(Vars)` é só um atalho para `labeling([], Vars)` — a busca com as
opções padrão. `labeling/2` aceita uma lista de opções que mudam a
**estratégia de busca**:

* **Seleção de variável** — qual rainha decidir primeiro:
  * `leftmost` (padrão): sempre a próxima da lista.
  * `ff` ("first fail"): a variável com o domínio mais estreito no momento
    — a ideia é errar (e podar) o mais cedo possível.
* **Seleção de valor** — qual coluna tentar primeiro para essa rainha:
  `up` (crescente, padrão) ou `down` (decrescente).

A estratégia importa, e muito: em `exemplos/labeling.pl`, resolver o
tabuleiro 20×20 com `leftmost` (padrão) leva mais de 4 segundos, enquanto
`ff` resolve o mesmo problema em milissegundos — e ainda dá conta de um
tabuleiro 50×50 em fração de segundo. `ff` costuma vencer porque evita
gastar tempo explorando ramos de busca com muitas rainhas já quase
decididas, indo direto para a mais restrita (e mais provável de falhar
rápido, ou de já estar praticamente determinada).

## Chamando Prolog a partir de Python

`library(janus)` (embutida no SWI-Prolog) permite embutir Prolog e Python
no mesmo processo, com o pacote Python `janus_swi` do lado de fora:

```
pip install janus-swi
```

`exemplos/queens_python.py` carrega `queens_lib.pl` e faz consultas a
partir do Python:

```python
import janus_swi as janus

janus.consult("queens_lib")

for solucao in janus.query("rainhas(N, Posicoes)", {"N": 8}):
    print(solucao["Posicoes"])
```

* `janus.consult(arquivo)` carrega um `.pl` (sem a extensão).
* `janus.query(objetivo, entradas)` devolve um iterador Python sobre as
  soluções (útil para percorrer todas via backtracking); `entradas` é um
  dicionário que liga variáveis do objetivo a valores Python antes de
  consultar.
* `janus.query_once(objetivo, entradas)` pega só a primeira solução.

Um detalhe importante: variáveis que só existem **dentro** de um
`findall/3` do objetivo (o termo-molde e a lista intermediária) não têm
como ser reportadas de volta ao Python, e a consulta lança um erro de
instanciação. A solução é sempre a mesma: colocar a lógica com
`findall/3` dentro de um predicado no arquivo `.pl` (aqui,
`todas_rainhas/2`) e, do lado do Python, consultar só esse predicado já
pronto — reforçando uma boa prática mesmo fora da integração com Python:
manter a lógica em Prolog, e a interface de consulta simples.

## Exercícios

Ver pasta `exercicios/`.
