:- use_module(library(clpfd)).

% rainhas(N, Posicoes): Posicoes é uma lista de N elementos, onde o valor
% na posição I é a coluna da rainha colocada na linha I. Queremos que
% nenhuma rainha ataque outra: nem mesma coluna, nem mesma diagonal (linhas
% diferentes já estão garantidas pela própria representação da lista).
rainhas(N, Posicoes) :-
    length(Posicoes, N),
    Posicoes ins 1..N,
    all_different(Posicoes),
    seguras(Posicoes),
    label(Posicoes).

% todas_rainhas(N, Todas): Todas as soluções para o tabuleiro NxN.
todas_rainhas(N, Todas) :- findall(P, rainhas(N, P), Todas).

% Duas rainhas nas colunas Q0 e Q, separadas por D linhas, estão na mesma
% diagonal se a diferença entre as colunas for igual a D.
seguras([]).
seguras([Q|Qs]) :- seguras(Qs, Q, 1), seguras(Qs).

seguras([], _, _).
seguras([Q|Qs], Q0, D0) :-
    abs(Q0 - Q) #\= D0,
    D1 #= D0 + 1,
    seguras(Qs, Q0, D1).
