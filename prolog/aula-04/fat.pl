% Fatorial sem usar CLPFD (sem operadores #)
fat_(0, 1).
fat_(N, Fat) :-
    N > 0,
    NPrev is N - 1,
    fat_(NPrev, FatPrev), % FatPrev = fat_(N - 1)
    Fat is N * FatPrev.

% Fatorial usando operadores #
fat(0, 1).
fat(N, Fat) :-
    N #> 0,
    NPrev #= N - 1,
    fat(NPrev, FatPrev), % FatPrev = fat_(N - 1)
    Fat #= N * FatPrev.

