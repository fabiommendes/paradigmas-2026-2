% A notação [Cabeca|Cauda] decompõe (ou constrói) uma lista via unificação.

primeiro(L, H) :- L = [H|_].
resto(L, T) :- L = [_|T].

:- primeiro([maca, pera, uva], X), write(X), nl.
:- resto([maca, pera, uva], X), write(X), nl.

% Dá para casar vários elementos do início de uma vez:
:- [A, B | Resto] = [1, 2, 3, 4, 5],
   format("A=~w B=~w Resto=~w~n", [A, B, Resto]).

% Cauda vazia indica lista com um único elemento.
:- ( [X] = [sozinho] -> write(X) ; write('nao bateu') ), nl.

% Se a lista não tiver elementos suficientes, a unificação falha.
:- ( [_, _] = [unico] -> write('bateu') ; write('nao bateu: poucos elementos') ), nl.
