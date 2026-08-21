% Fatorial "de mão", usando is/2 -- calcula Fatorial a partir de N conhecido.
% É uma FUNÇÃO, não uma relação: só serve numa direção.
fat_is(0, 1).
fat_is(N, F) :- N > 0, N1 is N - 1, fat_is(N1, F1), F is N * F1.

:- fat_is(5, F), write(F), nl.                % 120

% Perguntar "qual N tem fatorial 120?" não funciona: N precisa estar
% instanciado antes de "N > 0" e "N1 is N - 1" poderem ser avaliados.
:- catch(fat_is(_N, 120), Erro, (write('erro: '), write(Erro))), nl.

% Fatorial com CLPFD: #> e #= são restrições, não avaliações imediatas --
% o Prolog pode BUSCAR o valor de N que satisfaz a equação.
:- use_module(library(clpfd)).

fat_clpfd(0, 1).
fat_clpfd(N, F) :-
    N #> 0,
    N1 #= N - 1,
    fat_clpfd(N1, F1),
    F #= N * F1.

:- fat_clpfd(5, F), write(F), nl.             % 120: mesma direção de antes
:- fat_clpfd(N, 120), write(N), nl.           % 5: agora funciona ao contrário!
