# Problemas combinatórios

No problema das N-rainhas resolvido com CLPFD, por que a estratégia de
seleção de variável `ff` ("first fail") costuma ser muito mais rápida do
que a estratégia padrão `leftmost` para tabuleiros grandes?

* [ ] Porque `ff` testa menos valores de coluna para cada rainha.
* [*] Porque `ff` escolhe a cada passo a rainha com domínio mais estreito,
  descartando ramos de busca inválidos mais cedo.
* [ ] Porque `ff` executa o programa em paralelo, testando várias rainhas
  ao mesmo tempo.
* [ ] Porque `ff` ignora a restrição de diagonais, testando só colunas.

## Justificativa

`ff` (*first fail*) escolhe, a cada passo da busca, a variável com o menor
domínio possível no momento -- ou seja, a rainha mais "presa" pelas
restrições já aplicadas. Decidir essa variável primeiro faz o Prolog
descobrir uma contradição (ou fixar um valor obrigatório) mais cedo,
evitando explorar ramos inteiros da árvore de busca que dariam errado de
qualquer forma. A estratégia `leftmost` (padrão), por decidir sempre a
próxima variável da lista, não tem essa vantagem e pode gastar muito mais
tempo em becos sem saída antes de voltar atrás (backtracking).
