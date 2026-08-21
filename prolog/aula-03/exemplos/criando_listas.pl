% Listas em Prolog: sequências entre colchetes, elementos separados por vírgula.
:- L = [1, 2, 3], write(L), nl.

% Podem misturar tipos: números, átomos, listas, strings...
:- L = [maca, 3, [1, 2], "texto"], write(L), nl.

% Lista vazia é o átomo especial [].
:- ( [] == [] -> write('lista vazia') ; write('nao vazia') ), nl.

% [1,2,3] é só açúcar sintático para [1|[2|[3|[]]]]: uma lista é, por baixo
% dos panos, um termo composto de aridade 2 (cabeça e cauda) repetido até [].
:- functor([1, 2, 3], F, A), format("functor=~w aridade=~w~n", [F, A]).
