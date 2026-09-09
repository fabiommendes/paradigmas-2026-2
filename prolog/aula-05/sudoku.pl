
sudoku(Rows) :-
    % Números entre 1 e 9
    transpose(Rows, Cols),

    flatten(Rows, Nums),
    Nums ins 1..9,

    % Nenhum número repetido nas linhas
    maplist(all_distinct, Rows),

    % Nenhum número repetido nas colunas
    maplist(all_distinct, Cols),

    % Nenhum número repetido nas caixas 3x3
    Rows = [A, B, C,  D, E, F,  G, H, I],
    sudoku_box(A, B, C),
    sudoku_box(D, E, F),
    sudoku_box(G, H, I).


sudoku_box([], [], []).
sudoku_box([ A, B, C | R1 ],
           [ D, E, F | R2 ],
           [ G, H, I | R3 ]) :-
    all_distinct([A, B, C,  D, E, F,  G, H, I]),
    sudoku_box(R1, R2, R3).

flat([], []).
flat([ L | LsOfLs ], LsFlat) :-
    flat(LsOfLs, RestFlat),
    append(L, RestFlat, LsFlat).

print_line(top) :-  write('╔═══════╤═══════╤═══════╗'), nl.
print_line(mid) :-  write('╟───────┼───────┼───────╢'), nl.
print_line(low) :-  write('╚═══════╧═══════╧═══════╝'), nl.
print_row(Row)  :-  format('‖ ~w ~w ~w | ~w ~w ~w | ~w ~w ~w ‖', Row), nl.

print_sudoku([A, B, C,  D, E, F,  G, H, I]) :-
    print_line(top),
    maplist(print_row, [A, B, C]),
    print_line(mid),
    maplist(print_row, [D, E, F]),
    print_line(mid),
    maplist(print_row, [G, H, I]),
    print_line(low).

ex0([[ _, _, _,   _, _, _,   _, _, _ ],
     [ _, _, _,   _, _, _,   _, _, _ ],
     [ _, _, _,   _, _, _,   _, _, _ ],

     [ _, _, _,   _, _, _,   _, _, _ ],
     [ _, _, _,   _, _, _,   _, _, _ ],
     [ _, _, _,   _, _, _,   _, _, _ ],

     [ _, _, _,   _, _, _,   _, _, _ ],
     [ _, _, _,   _, _, _,   _, _, _ ],
     [ _, _, _,   _, _, _,   _, _, _ ]]).

% ╔═══════╤═══════╤═══════╗
% ‖ 2 7 8 | 6 4 9 | 3 1 5 ‖
% ‖ 3 1 6 | 7 2 5 | 4 8 9 ‖
% ‖ 4 5 9 | 8 1 3 | 7 6 2 ‖
% ╟───────┼───────┼───────╢
% ‖ 5 8 4 | 3 7 6 | 2 9 1 ‖
% ‖ 1 9 3 | 2 5 8 | 6 7 4 ‖
% ‖ 7 6 2 | 4 9 1 | 8 5 3 ‖
% ╟───────┼───────┼───────╢
% ‖ 8 3 1 | 9 6 2 | 5 4 7 ‖
% ‖ 9 2 7 | 5 8 4 | 1 3 6 ‖
% ‖ 6 4 5 | 1 3 7 | 9 2 8 ‖
% ╚═══════╧═══════╧═══════╝
% X, Y, e X, Z são adjacentes
ex1([[ 2, _, 8,   _, _, _,   _, _, 5 ],
     [ _, _, _,   7, _, _,   _, 8, _ ],
     [ _, 5, 9,   _, _, _,   7, 6, _ ],

     [ _, _, Z,   3, _, 6,   _, 9, _ ],
     [ _, _, X,   _, 5, _,   _, _, _ ],
     [ _, 6, Y,   4, _, 1,   _, _, _ ],

     [ _, 3, 1,   _, _, _,   5, 4, _ ],
     [ _, 2, _,   _, _, 4,   _, 3, _ ],
     [ 6, _, 5,   _, _, _,   9, _, 8 ]]) :-
    abs(X - Y) #= 1,
    abs(X - Z) #= 1.


