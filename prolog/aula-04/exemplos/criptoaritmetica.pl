:- use_module(library(clpfd)).

% SEIS + SEIS = DOZE: cada letra é um dígito (0-9) diferente, e as letras
% que começam um número não podem valer 0. Bônus: a conta também é
% verdadeira em português (seis mais seis é doze).
seis_seis_doze(S, E, I, D, O, Z) :-
    Vars = [S, E, I, D, O, Z],
    Vars ins 0..9,
    all_different(Vars),
    S #\= 0, D #\= 0,
    Seis #= S*1000 + E*100 + I*10 + S,
    Doze #= D*1000 + O*100 + Z*10 + E,
    Seis + Seis #= Doze,
    label(Vars).

:- seis_seis_doze(S, E, I, D, O, Z),
   format("SEIS=~w~w~w~w DOZE=~w~w~w~w~n", [S, E, I, S, D, O, Z, E]).

% DOIS + TRES = CINCO é outro exemplo válido (sem ligação com o valor
% numérico das palavras) -- bom para tentar resolver como exercício.
dois_tres_cinco(D, O, I, S, T, R, E, C, N) :-
    Vars = [D, O, I, S, T, R, E, C, N],
    Vars ins 0..9,
    all_different(Vars),
    D #\= 0, T #\= 0, C #\= 0,
    Dois #= D*1000 + O*100 + I*10 + S,
    Tres #= T*1000 + R*100 + E*10 + S,
    Cinco #= C*10000 + I*1000 + N*100 + C*10 + O,
    Dois + Tres #= Cinco,
    label(Vars).

:- dois_tres_cinco(D, O, I, S, T, R, E, C, N),
   format("DOIS=~w~w~w~w TRES=~w~w~w~w CINCO=~w~w~w~w~w~n",
          [D, O, I, S, T, R, E, S, C, I, N, C, O]).
