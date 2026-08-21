% Representação homoicônica: um termo Prolog pode ser inspecionado e
% construído como dado, usando =.. (univ) e functor/3.

:- T = progenitor(homer, bart),
   T =.. Lista,
   write('progenitor(homer, bart) =.. '), write(Lista), nl.

:- functor(progenitor(homer, bart), Nome, Aridade),
   write('functor/nome: '), write(Nome),
   write(', aridade: '), write(Aridade), nl.

:- Novo =.. [soma, 1, 2],
   write('Termo construído a partir de uma lista: '), write(Novo), nl.
