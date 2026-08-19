% const fat = (n) => n === 0? 1: n * fat(n - 1);
% Res é igual ao fatorial de N
fat(0, 1).
fat(N, Res) :-
    N #> 0,
    NPrev #= N - 1,
    fat(NPrev, FatPrev),
    Res #= N * FatPrev.


:- fat(5, N), write('Fatorial de 5 é '), write(N), write('.'), nl.