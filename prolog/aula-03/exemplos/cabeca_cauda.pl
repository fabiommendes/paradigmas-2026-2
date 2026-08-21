% A notação [Cabeca|Cauda] decompõe (ou constrói) uma lista via unificação.

primeiro(L, H) :- L = [H|_].
resto(L, T) :- L = [_|T].

:- primeiro([banana, pera, uva], X), write(X), nl.
:- resto([banana, pera, uva], X), write(X), nl.

% Dá para casar vários elementos do início de uma vez:
:- [A, B | Resto] = [1, 2, 3, 4, 5],
   format("A=~w B=~w Resto=~w~n", [A, B, Resto]).

% obs.: format/2 é o análogo do printf em C, e ~w é o "placeholder" para
% qualquer termo Prolog e ~n para nova linha.


% Cauda vazia indica lista com um único elemento.
:- ( [X | []] = [sozinho] ->
        write(X) ;
        write('não unificou')
    ), nl.

% obs.: o operador -> é o "if-then-else" do Prolog. A expressão à esquerda do -> é a condição,
% e a expressão à direita é o que acontece se a condição for verdadeira. Se a condição for falsa,
% o que vem depois do ; é executado.

% Se a lista não tiver elementos suficientes, a unificação falha.
:- ( [_, _] = [unico] -> write('ok') ; write('não unificou') ), nl.
