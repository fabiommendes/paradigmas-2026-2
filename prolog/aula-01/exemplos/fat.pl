:- use_module(library(clpfd)).

% Prévia: no futuro veremos CLPFD em detalhe. Por ora, repare que a definição
% de fatorial é bem parecida com a versão matemática recursiva:
% const fat = (n) => n === 0? 1: n * fat(n - 1);

% Resultado é igual ao fatorial de N
fat(0, 1).
fat(N, Fatorial) :-
    N #> 0,
    NPrev #= N - 1,
    fat(NPrev, FatPrev),
    Fatorial #= N * FatPrev.


:- fat(5, N), write('Fatorial de 5 é '), write(N), write('.'), nl.
