tamanho([], 0).
tamanho([ _ | Xs ], N) :-
    tamanho(Xs, N1),
    N #= N1 + 1.

soma([], 0).
soma([ X | Xs ], Soma) :-
    soma(Xs, SomaXs),
    Soma #= SomaXs + X.

somaf(Xs, Soma) :-
    foldl(plus, Xs, 0, Soma).

prodf(Xs, Prod) :-
    foldl(mul, Xs, 1, Prod).

mul(X, Y, Prod) :-
    Prod #= X * Y.

fibs(0, []).
fibs(1, [1]).
fibs(2, [1, 1]).
fibs(N, [ X, Y, Z | Rest ]) :-
    N #> 2,
    X #= Y + Z,
    N1 #= N - 1,
    fibs(N1, [ Y, Z | Rest ]).

% Referências:
% - https://www.swi-prolog.org/pldoc/man?section=lists
% - https://www.swi-prolog.org/pldoc/doc_for?object=foldl/4

