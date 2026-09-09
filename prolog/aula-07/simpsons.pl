% Apresentando os personagens
mulher(marge).
mulher(lisa).
mulher(maggie).
mulher(selma).
mulher(patty).
mulher(jackie).
mulher(ling).
homem(homer).
homem(bart).
homem(abe).

% Relações familiares
progenitor(homer, bart).
progenitor(homer, lisa).
progenitor(homer, maggie).
progenitor(marge, bart).
progenitor(marge, lisa).
progenitor(marge, maggie).
progenitor(abe, homer).
progenitor(selma, ling).
progenitor(jackie, selma).
progenitor(jackie, patty).
progenitor(jackie, marge).

% Idades (meio inventadas)
idade(homer, 39).
idade(marge, 36).
idade(bart, 10).
idade(lisa, 8).
idade(maggie, 1).
idade(selma, 40).
idade(patty, 40).
idade(abe, 70).
idade(jackie, 65).
idade(ling, 2).

% Relações de parentesco
pai(X, Y) :- homem(X), progenitor(X, Y).
irma(X, Y) :- mulher(X), progenitor(Z, X), progenitor(Z, Y), X \= Y.


% ?- irma(lisa, X)
%   (40, X = lisa, Y = X) mulher(lisa), progenitor(Z, lisa), progenitor(Z, X), lisa \= X
%       (3) progenitor(Z, lisa), progenitor(Z, X), lisa \= X
%           (15, Z = homer) progenitor(homer, X), lisa \= X
%               (14, X = bart) lisa \= bart ==> true [ X = bart ]
%               ---
%               (15, X = lisa) lisa \= lisa ==> false
%               ---
%               (16, X = maggie) lisa \= maggie ==> true [ X = maggie ]
%           (18, Z = marge) progenitor(marge, X), lisa \= X
%               (17, X = bart) lisa \= bart ==> true [ X = bart ]
%               ---
%               (18, X = lisa) lisa \= lisa ==> false
%               ---
%               (19, X = maggie) lisa \= maggie ==> true [ X = maggie ]
%
