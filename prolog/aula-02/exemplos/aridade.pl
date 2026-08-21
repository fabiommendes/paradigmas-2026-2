% Aridade: o mesmo nome de functor com número diferente de argumentos define
% predicados distintos — soma/3 e soma/4 não têm relação entre si.

soma(X, Y, Soma) :- Soma is X + Y.
soma(X, Y, Z, Soma) :- Soma is X + Y + Z.

:- functor(soma(1, 2, 3), Nome, Aridade),
   write(Nome), write('/'), write(Aridade), nl.

:- functor(soma(1, 2, 3, 4), Nome2, Aridade2),
   write(Nome2), write('/'), write(Aridade2), nl.

:- soma(2, 3, R), write('soma/3 -> '), write(R), nl.
:- soma(2, 3, 4, R2), write('soma/4 -> '), write(R2), nl.
