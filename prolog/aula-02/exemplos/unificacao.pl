% Consultas e unificação: o operador =/2 tenta unificar dois termos,
% associando variáveis para que ambos os lados fiquem idênticos.

:- ( foo(A, b) = foo(1, B) ->
       write('Unificou: A='), write(A), write(', B='), write(B), nl
   ;   write('Não unificou'), nl
   ).

:- ( foo(a) = bar(a) ->
       write('Unificou')
   ;   write('Não unificou: functors diferentes')
   ), nl.

:- ( progenitor(homer, X) = progenitor(homer, bart) ->
       write('Unificou com X = '), write(X), nl
   ;   write('Não unificou'), nl
   ).
