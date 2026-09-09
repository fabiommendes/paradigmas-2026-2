:- discontiguous n_queens/3.

% N rainhas em um tabuleiro N x N
% Queens é uma lista de posições das rainhas, onde o índice representa a linha e o valor representa a coluna.
% versão a
n_queens(N, Queens, a) :-
    length(Queens, N),
    Queens ins 1..N,
    safe_queen(Queens).

safe_queen([]).
safe_queen([Q|Qs]) :-
    safe_queen(Qs),
    safe_queen(Q, Qs, 1).

safe_queen(_, [], _).
safe_queen(Q, [Q1|Qs], D) :-
    Q #\= Q1,
    abs(Q - Q1) #\= D,
    D1 #= D + 1,
    safe_queen(Q, Qs, D1).

% N rainhas em um tabuleiro N x N
n_queens(N, Queens, b) :-
    length(Queens, N),
    Queens ins 1..N,

    % Nenhuma rainha na mesma linha que outra
    all_distinct(Queens),

    % Nenhuma rainha nas diagonais positiva/negativa
    diag(1, Queens, Pos), all_distinct(Pos),
    diag(-1, Queens, Neg), all_distinct(Neg).

diag(_, [], []).
diag(Sign, [Q|Qs], [D|Ds]) :-
    length(Qs, Len),
    D #= Q + Sign * Len,
    diag(Sign, Qs, Ds).

% N rainhas em um tabuleiro N x N
n_queens(N, Queens, c) :-
    length(Queens, N),
    Queens ins 1..N,
    numlist(1, N, Range),

    % Nenhuma rainha na mesma linha que outra
    all_distinct(Queens),

    % Nenhuma rainha nas diagonais positiva/negativa
    maplist(plus, Queens, Range, Pos), all_distinct(Pos),
    maplist(minus, Queens, Range, Neg), all_distinct(Neg).

plus(X, Y, Z) :- Z #= X + Y.
minus(X, Y, Z) :- Z #= X - Y.

print_queens(Queens) :-
    length(Queens, N),
    forall(between(1, N, Row), (
        forall(member(Q, Queens),
            (Q #= Row -> write(' Q ') ; write(' _ '))
        ),
        nl
    )).



