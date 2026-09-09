:- use_module(library(clpfd)).

% Problema SEND + MORE = MONEY
crypto([
    S, E, N, D,
    M, O, R, E,
 M, O, N, E, Y]) :-

    UniqueVars = [S, E, N, D, M, O, R, Y],
    UniqueVars ins 0 .. 9,
    all_different(UniqueVars),

    % Primeiro dígito de cada número não pode ser nulo
    S #\= 0,
    M #\= 0,

    N1 #= 1000 * S + 100 * E + 10 * N + D,
    N2 #= 1000 * M + 100 * O + 10 * R + E,
    N3 #= 10000 * M + 1000 * O + 100 * N + 10 * E + Y,
    N3 #= N1 + N2.

% Conferindo a solução
% S = 9,
% E = 5,
% N = 6,
% D = 7,
% M = 1,
% O = 0,
% R = 8,
% Y = 2 ;
%
% => SEND + MORE = MONEY
% => 9567 + 1085 = 10652