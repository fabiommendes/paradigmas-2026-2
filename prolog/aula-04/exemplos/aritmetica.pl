% is/2 avalia uma expressão aritmética e unifica o resultado com a
% variável à esquerda. A expressão à direita precisa estar totalmente
% instanciada (só números, sem variáveis livres).

:- X is 2 + 3 * 4, write(X), nl.          % 14
:- X is (10 - 4) / 2, write(X), nl.       % 3 (no SWI, / dá inteiro quando exato)
:- X is 7 // 2, write(X), nl.             % divisão inteira: 3
:- X is 7 mod 2, write(X), nl.            % resto da divisão: 1
:- X is 2 ** 10, write(X), nl.            % potência: 1024

% = é unificação, não avaliação -- não faz contas!
:- ( 1 + 1 = 2 -> write('unificou') ; write('nao unificou: termos diferentes') ), nl.

% Comparações aritméticas avaliam os dois lados antes de comparar:
% =:=, =\=, <, >, =<, >=
:- ( 1 + 1 =:= 2 -> write('iguais apos avaliar') ; write('diferentes') ), nl.
:- ( 1 + 1 == 2 -> write('termos identicos') ; write('termos diferentes (nao avaliou)') ), nl.

% is/2 exige que a expressão à direita esteja pronta: com uma variável
% livre no meio da conta, a consulta lança um erro de instanciação.
:- catch((Y is _X + 1, write(Y)), Erro, (write('erro: '), write(Erro))), nl.
