:- consult('simpsons.pl').

% X é irmã de Y
irma(X, Y) :-
    mulher(X),
    irmx(X, Y).

% X é irmão de Y
irmao(X, Y) :-
    homem(X),
    irmx(X, Y).

% X é irmão ou irmã de Y
irmx(X, Y) :-
    progenitor(Z, X),
    progenitor(Z, Y),
    X \= Y.

% X é tia de Y
tia(Tia, Sobrinho) :-
    irma(Tia, PaiOuMae),
    progenitor(PaiOuMae, Sobrinho).

tix(TioOuTia, Sobrinhx) :-
   irmx(TioOuTia, PaiOuMae),
   progenitor(PaiOuMae, Sobrinhx).

primx(X, Y) :-
    tix(TioOuTia, Y),
    progenitor(TioOuTia, X).

% X é primo de Y
primo(X, Y) :-
    homem(X),
    primx(X, Y).

% X é primo de Y
prima(X, Y) :-
    mulher(X),
    primx(X, Y).
