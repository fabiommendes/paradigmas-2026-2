:- dynamic env/2.
:- op(400, yfx, ÷).
:- op(150, yf, !).
:- op(1150, xfx, in).
:- op(1000, xfx, then).
:- op(950, xfx, else).
:- op(950, fx, if).


% Manipulação da base de dados env
set_env(K, V) :-
    retractall(env(K, _)),
    assertz(env(K, V)).

get_env(K, V) :-
    env(K, V).

% Variáveis pré-definidas
env(pi, 3.141592653589793).
env(π, 3.141592653589793).
env(tau, 6.283185307179586).
env(phi, 1.618033988749895).
env(e, 2.718281828459045).

% Termos atômicos (números e átomos, representando variáveis)
eval(N, N) :- number(N).
eval(X, V) :- atom(X), env(X, V).

% Operações aritméticas básicas
eval(X + Y, R) :-
    eval(X, RX),
    eval(Y, RY),
    R is RX + RY.

eval(X * Y, R) :-
    eval(X, RX),
    eval(Y, RY),
    R is RX * RY.

eval(X - Y, R) :-
    eval(X, RX),
    eval(Y, RY),
    R is RX - RY.

eval(X ÷ Y, R) :-
    eval(X, RX),
    eval(Y, RY),
    R is RX / RY.

eval(X!, R) :-
    eval(X, RX),
    fat(RX, R).

% Operadores de comparação
eval(X < Y, R) :-
    eval(X, RX),
    eval(Y, RY),
    (RX < RY -> R is 1 ; R is 0).

eval(X > Y, R) :-
    eval(X, RX),
    eval(Y, RY),
    (RX > RY -> R is 1 ; R is 0).

% Condicional
eval(if Cond then Then else Else, R) :-
    eval(Cond, RC),
    ( RC =:= 1, eval(Then, R) ; RC =:= 0, eval(Else, R)).

% Declaração de variáveis
eval(X = V in E, R) :-
    let(X, V),
    eval(E, R).

eval(Bindings in E, R) :-
    let_bindings(Bindings),
    eval(E, R).

%
% Biblioteca de funções padrão (stdlib)
%
fat(0, 1).
fat(N, F) :-
    N > 0,
    N1 is N - 1,
    fat(N1, F1),
    F is N * F1.

% Declara a variável x com o valor v
let(X, V) :-
    atom(X),
    number(V),
    set_env(X, V).

let_bindings(X = V) :- let(X, V).
let_bindings(X = V; Rest) :-
    let(X, V),
    let_bindings(Rest).