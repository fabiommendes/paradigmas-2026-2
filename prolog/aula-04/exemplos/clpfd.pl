:- use_module(library(clpfd)).

% #= é a versão CLPFD de is/2 (e de =:=): mas, ao invés de avaliar na hora,
% registra uma RESTRIÇÃO -- por isso funciona mesmo com variáveis ainda não
% instanciadas, resolvendo a equação em qualquer direção.
:- X #= 2 + 3 * 4, write(X), nl.           % 14, igual a is/2 quando tudo é conhecido
:- X + 1 #= 5, write(X), nl.               % 4: is/2 não resolveria isso!

% in/2 restringe o domínio de uma variável; label/1 busca valores concretos
% que satisfazem todas as restrições acumuladas.
:- X in 1..10, X #> 7, label([X]), write(X), nl.

% ins aplica o mesmo domínio a uma lista de variáveis de uma vez.
:- [X, Y] ins 0..9, X #> Y, X + Y #= 10, label([X, Y]),
   format("X=~w Y=~w~n", [X, Y]).

% all_different/1 garante que as variáveis da lista recebam valores distintos.
:- [X, Y, Z] ins 1..3, all_different([X, Y, Z]), label([X, Y, Z]),
   format("X=~w Y=~w Z=~w~n", [X, Y, Z]).

% Sem label/1, X fica com um domínio ainda em aberto -- o Prolog só decide um
% valor concreto quando pedimos explicitamente. write/1 mostra uma variável
% interna, não um número: a busca ainda não aconteceu.
:- X in 1..10, X #> 7, write(X), nl.
