% Implementações recursivas de predicados clássicos sobre listas.
% O padrão é sempre o mesmo: um caso base para a lista vazia e um caso
% recursivo que resolve a cauda e combina o resultado com a cabeça.

% tamanho(Lista, N): N é o número de elementos de Lista.
tamanho([], 0).
tamanho([_|T], N) :- tamanho(T, N0), N is N0 + 1.

% soma(Lista, Soma): soma dos elementos numéricos de Lista.
soma([], 0).
soma([H|T], S) :- soma(T, S0), S is S0 + H.

% pertence(X, Lista): X ocorre em Lista (é assim que member/2 é definido).
pertence(X, [X|_]).
pertence(X, [_|T]) :- pertence(X, T).

:- tamanho([a, b, c, d], N), write(N), nl.
:- soma([1, 2, 3, 4, 5], S), write(S), nl.
:- ( pertence(c, [a, b, c, d]) -> write('c esta na lista') ; write('nao esta') ), nl.

% pertence/2 também gera candidatos por backtracking, não só testa:
:- findall(X, pertence(X, [a, b, c]), Todos), write(Todos), nl.
