% Máximo entre dois números usando o operador de cut
%      max(+X, +Y, ?R)
% ATENÇÂO: cut vermelho: pode causar bugs dependendo das variáveis instanciadas.
max(X, Y, X) :- X > Y, !.
max(_, Y, Y).  % :- X < Y.

% Max com o operador cut pode produzir soluções erradas se for usado
% com variávies não instanciadas fora da última posição
%
% max(2, Y, 4) -> (5) Y = 4.
% max(4, Y, 4) -> (4) X = 4, Y = Y, 4 > Y.
%                                   ^^^^^^
% max(X, 2, 4) -> (4) X = 4, 4 > 2, !  <-- não testa a cláusula na linha 5
% max(X, 4, 4) -> (4) X = 4, 4 > 4     <-- erro, passa para a linha 5
%              .. (5) X = X.
%                     ^^^^^
%                     Aceita a solução errada (ex. X = 5, seria válido mas não resolve max)

% Implementação CLPFD não possui esses problemas.
max_(X, Y, X) :- X #>= Y.
max_(X, Y, Y) :- Y #> X.