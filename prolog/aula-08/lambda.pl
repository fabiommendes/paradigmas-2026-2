:- dynamic var_idx/1.

:- op(500, fx,  λ).
:- op(600, xfy, :).
:- op(400, yfx, ·).

:- op(650, xfx, =>).
:- op(700, xfx, in).

%
% Apresentamos as notações para o cálculo lambda.
%
% Abstração: λ x: M representa uma função anônima com argumento x e corpo M.
% Aplicação: M · N representa a aplicação do termo M ao termo N.
%
% Os argumentos de uma função são representados por átomos.
% Veja a seção de exemplos para entender melhor a notação e algumas aplicações.
%

% Redução/conversão alfa: renomear variáveis não livres em um termo.
% Permite a reescrita de termos em termos equivalentes.
% Ex.: λ x : x pode virar λ y : y por conversão alfa.
alpha(X => Y in X, Y) :-
    atoms([X, Y]), !.
alpha(X => Y in V, V) :-
    atoms([X, Y, V]),
    V \= X, !.
alpha(X => Y in λ X : B, λ Y : B1) :-
    atoms([X, Y]),
    alpha(X => Y in B, B1), !.
alpha(X => Y in λ Z : B, λ Z : B1) :-
    atoms([X, Y, Z]),
    Z \= X,
    alpha(X => Y in B, B1), !.
alpha(X => Y in F · A, F1 · A1) :-
    atoms([X, Y]), !,
    alpha(X => Y in F, F1),
    alpha(X => Y in A, A1).

% Redução beta é a aplicação de uma função a um argumento: substituímos a variável
% ligada pelo argumento no corpo da função.
beta((λ X : B) · A, Out) :-
    subst(X => A in B, Out), !.
beta(λ X : B, λ X : B1) :-
    beta(B, B1), !.
beta((F · A), (F1 · A)) :-
    beta(F, F1), !.
beta((F · A), (F · A1)) :-
    beta(A, A1), !.

% Eval é conhecido como normalização para a forma normal β.
% Aplicamos repetidamente a redução beta até que não seja mais possível.
eval(T, T) :- \+(beta(T, _)), !.
eval(T, R) :- beta(T, T1), eval(T1, R).

% Troca todas as ocorrências livres de X em Body por Arg.
subst(X => Arg in X, Arg) :-
    atom(X).
subst(X => _ in V, V) :-
    atoms([X, V]),
    V \= X.
subst(X => _ in λ X : B, λ X : B) :-
    atom(X).
subst(X => Arg in λ Y : B, λ Y2 : B1) :-
    atoms([X, Y]),
    Y \= X,
    free_vars(Arg, FV),
    ( memberchk(Y, FV)
        % O argumento Y é uma variável livre de Arg, então precisamos renomear
        % Y no corpo da abstração λ Y : B(Y) para evitar captura.
        -> var_name(Y2),
           alpha(Y => Y2 in B, B2),
           subst(X => Arg in B2, B1)

        % Caso Y não seja uma variável livre de Arg, simplesmente
        % substituímos.
        ; Y2 = Y,
          subst(X => Arg in B, B1)
    ).
subst(X => Arg in F · A, F1 · A1) :-
    subst(X => Arg in F, F1),
    subst(X => Arg in A, A1).

% Variáveis livres
free_vars(X, [X]) :-
    atom(X).
free_vars(λ X : Y, Free) :-
    free_vars(Y, Free1),
    subtract(Free1, [X], Free).
free_vars(X · Y, Free) :-
    free_vars(X, FreeX),
    free_vars(Y, FreeY),
    union(FreeX, FreeY, Free).

% Variáveis auxiliares para geração de novos nomes de variáveis livres
% temporárias
var_idx(0).
var_name(Name) :-
    var_idx(N),
    atomic_list_concat(['_', N], Name),
    N1 is N + 1,
    !,
    retract(var_idx(N)),
    assertz(var_idx(N1)).

% Funções auxiliares
atoms([]).
atoms([H|T]) :- atom(H), atoms(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  Exemplos                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Funções básicas e combinadores
ex(id, λ x: x).
ex(ycomb, λ f: (λ x: f · (x · x)) · (λ x: f · (x · x))).
ex(zcomb, λ f: (λ y: f · (x · x · y)) · (λ y: f · (x · x · y))).

% Pares
ex(pair, λ x: λ y: λ f: f · x · y).
ex(first, λ p: p · (λ x: λ y: x)).
ex(second, λ p: p · (λ x: λ y: y)).

% Booleanos
ex(true, λ x: λ y: x).
ex(false, λ x: λ y: y).
ex(if, λ cond: λ then: λ else: cond · then · else).
ex(and, λ a: λ b: a · b · a).
ex(or, λ a: λ b: a · a · b).
ex(not, λ b: b · False · True) :-
    ex(false, False), ex(true, True).

% Números naturais: codificamos como N = λ f: λ x: B, onde no
% corpo aplicamos N vezes a função f ao argumento x.
ex(0, λ f: λ x: x).
ex(N, V) :-
    number(N), !,
    N > 0,
    number_body(N, f, x, B),
    V = λ f: λ x: B.

% Operações com numerais
ex(add, λ a: λ b: λ f: λ x: a · f · (b · f · x)).
ex(mul, λ a: λ b: λ f: λ x: a · (b · f) · x).
ex(succ, λ n: λ f: λ x: f · (n · f · x)).

ex(pred, λ n: λ f: λ x: n · (λ mkx: λ g: g · (mkx · f)) · (λ any: x) · Id) :-
    ex(id, Id).

ex(iszero, λ n: n · (λ x: False) · True) :-
    ex(false, False), ex(true, True).

% % fat2: (rec, n) => (n === 0)? 1 : n * rec(rec, n - 1)
% ex(fat/2, λ rec: λ n: (IsZero · n) · One · (Mul · n · (rec · rec · (Pred · n)))) :-
%     ex(iszero, IsZero),
%     ex(1, One),
%     ex(mul, Mul),
%     ex(pred, Pred).

% % fat: (n) => fat2(fat2, n)
% ex(fat, λ n: Fat2 · Fat2 · n) :-
%     ex(fat/2, Fat2).

ex(fat, λ n: λ f: n · (λ r: λ a: a · (r · (Succ · a))) · (λ a: f) · One) :-
    ex(succ, Succ),
    ex(1, One).

ex(add(A, B), V) :-
    ex(A, CA),
    ex(B, CB),
    ex(add, Add),
    eval((Add · CA) · CB, V).

ex(mul(A, B), V) :-
    ex(A, CA),
    ex(B, CB),
    ex(mul, Mul),
    eval((Mul · CA) · CB, V).

ex(pred(N), V) :-
    ex(N, CN),
    ex(pred, Pred),
    eval(Pred · CN, V).

ex(succ(N), V) :-
    ex(N, CN),
    ex(succ, Succ),
    eval(Succ · CN, V).

ex(fat(N), V) :-
    ex(fat, Fat),
    ex(N, CN),
    eval(Fat · CN, V).

ex(iszero(N), V) :-
    ex(iszero, IsZero),
    ex(N, CN),
    eval(IsZero · CN, V).

% Constrói o corpo de um numeral de Church a partir de um número natural.
number_body(0, _F, X, X).
number_body(N, F, X, F · B) :-
    N > 0,
    N1 is N - 1,
    number_body(N1, F, X, B).

% Inverte número de Church
num(CN, N) :-
    eval(CN · f · x, CNBody),
    inv_body(CNBody, N).

% Inverte booleanos de Church
bool(CB, B) :-
    eval(CB · true · false, B).

% Inverte pares de Church
pair(CP, Pair) :-
    ex(first, First),
    ex(second, Second),
    eval(First · CP, F),
    eval(Second · CP, S),
    Pair = pair(F, S).

inv_body(x, 0).
inv_body(f · X, N) :-
    inv_body(X, N1),
    N is N1 + 1.
