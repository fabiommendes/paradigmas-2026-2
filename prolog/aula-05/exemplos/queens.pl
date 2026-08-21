:- consult(queens_lib).

:- rainhas(8, Posicoes), write(Posicoes), nl.

% Quantas soluções existem para o tabuleiro 8x8?
:- todas_rainhas(8, Todas), length(Todas, N), write(N), nl.
