sudoku([[A, B, C, D],
        [E, F, G, H],
        [I, J, K, L],
        [M, N, O, P]]) :-

    % Nenhum número repetido nas linhas
    all_distinct([A, B, C, D]),
    all_distinct([E, F, G, H]),
    all_distinct([I, J, K, L]),
    all_distinct([M, N, O, P]),

    % Nenhum número repetido nas colunas
    all_distinct([A, E, I, M]),
    all_distinct([B, F, J, N]),
    all_distinct([C, G, K, O]),
    all_distinct([D, H, L, P]),

    % Nenhum número repetido nas caixas 2x2
    all_distinct([A, B, E, F]),
    all_distinct([C, D, G, H]),
    all_distinct([I, J, M, N]),
    all_distinct([K, L, O, P]),

    % Números entre 1 e 4
    [A, B, E, F] ins 1..4,
    [C, D, G, H] ins 1..4,
    [I, J, M, N] ins 1..4,
    [K, L, O, P] ins 1..4.

print_line(top) :-  write('╔═════╤═════╗'), nl.
print_line(mid) :-  write('╟─────┼─────╢'), nl.
print_line(low) :-  write('╚═════╧═════╝'), nl.
print_row(Row)  :- format('‖ ~w ~w | ~w ~w ‖', Row), nl.

print_sudoku([A, B, C, D]) :-
    print_line(top),
    maplist(print_row, [A, B]),
    print_line(mid),
    maplist(print_row, [C, D]),
    print_line(low).



ex1([[1, 4, 3, 2],
     [2, 3, 1, 4],
     [3, 2, 4, 1],
     [4, 1, 2, 3]]).

ex2([[1, _, 3, _],
     [2, _, _, _],
     [_, _, 4, _],
     [_, _, _, _]]).




