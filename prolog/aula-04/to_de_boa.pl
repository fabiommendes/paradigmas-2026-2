:- use_module(library(clpfd)).

% TO + DE = BOA: cada letra é um dígito (0-9) diferente, e as letras
% que começam um número não podem valer 0.
%
% Letras maiores em ordem alfabética representam números maiores.
crypto([
    [T, O],
    % [B, E, M],
    [S, O],
    [D, E],
    [B, O, A]
]) :-
    Vars = [T, O, D, E, B, A, S],
    Vars ins 0..9,
    all_different(Vars),

    T #\= 0, D #\= 0, B #\= 0,

    A #< B,
    B #< D,
    D #< E,
    % E #< M,
    % M #< O,
    % O #< T,
    E #< S,
    S #< T,

    To = 10 * T + O,
    De = 10 * D + E,
    So = 10 * S + O,
    Boa = 100 * B + 10 * O + A,
    To + So + De #= Boa.


:- write("Lista de soluções:"), nl,
   forall((
        crypto([
            [T, O],
            [B, E, M],
            [D, E],
            [B, O, A]
        ]),
        label([T, O, D, E, B, A, M])
    ),
    format("TO=~w~w BEM=~w~w~w DE=~w~w BOA=~w~w~w~n", [T, O, B, E, M, D, E, B, O, A])).

