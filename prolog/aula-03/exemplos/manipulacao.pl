% concatena(L1, L2, L3): L3 é L1 seguida de L2 (é assim que append/3 é definido).
concatena([], L, L).
concatena([H|T], L2, [H|T2]) :- concatena(T, L2, T2).

% inverte(L, Invertida): Invertida contém os elementos de L na ordem reversa.
inverte([], []).
inverte([H|T], Invertida) :- inverte(T, InvT), concatena(InvT, [H], Invertida).

:- concatena([1, 2], [3, 4, 5], L), write(L), nl.
:- inverte([1, 2, 3, 4], L), write(L), nl.

% Graças à unificação bidirecional, concatena/3 também acha como DIVIDIR
% uma lista em duas partes -- não serve só para juntar.
:- findall(P-S, concatena(P, S, [a, b, c]), Divisoes), write(Divisoes), nl.

% Os predicados equivalentes já vêm prontos na biblioteca padrão do SWI-Prolog:
% append/3, reverse/2, length/2, member/2, nth0/3, last/2, sum_list/2.
:- append([1, 2], [3, 4], L), reverse(L, R), write(R), nl.
