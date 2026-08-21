% Formas canônicas de termos: operadores como +, *, :- e , são apenas
% "açúcar sintático" para termos compostos comuns. write_canonical/1 mostra
% a forma funcional pura, sem usar a notação de operador.

:- X = 1 + 2 * 3,
   write('Notação com operadores: '), write(X), nl,
   write('Forma canônica:         '), write_canonical(X), nl.

:- Y = (chove :- nublado, umido),
   write('Notação com operadores: '), write(Y), nl,
   write('Forma canônica:         '), write_canonical(Y), nl.

:- Z = homer é_progenitor_de bart,
   write('Notação com operadores: '), write(Z), nl,
   write('Forma canônica:         '), write_canonical(Z), nl.
