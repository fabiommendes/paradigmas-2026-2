:- use_module(library(clpfd)).

rainhas(N, Opcoes, Posicoes) :-
    length(Posicoes, N),
    Posicoes ins 1..N,
    all_different(Posicoes),
    seguras(Posicoes),
    labeling(Opcoes, Posicoes).

seguras([]).
seguras([Q|Qs]) :- seguras(Qs, Q, 1), seguras(Qs).
seguras([], _, _).
seguras([Q|Qs], Q0, D0) :-
    abs(Q0 - Q) #\= D0,
    D1 #= D0 + 1,
    seguras(Qs, Q0, D1).

% labeling/2 recebe uma lista de OPÇÕES além das variáveis. As opções
% controlam a ESTRATÉGIA DE BUSCA: qual variável escolher a cada passo, e
% qual valor tentar primeiro para ela. label(Vars) é só labeling([], Vars).
%
%   Seleção de variável:
%     leftmost (padrão) - sempre a primeira variável da lista
%     ff               - "first fail": a variável com domínio mais estreito
%     ffc              - como ff, mas desempata pela mais restringida
%   Seleção de valor:
%     up (padrão) - tenta valores do menor para o maior
%     down        - do maior para o menor

bench(N, Opcoes) :-
    get_time(T0),
    rainhas(N, Opcoes, _),
    !,
    get_time(T1),
    Dt is T1 - T0,
    format("N=~w opcoes=~w tempo=~3fs~n", [N, Opcoes, Dt]).

% Com a estratégia padrão (leftmost, valores crescentes), o Prolog erra
% muito antes de achar uma solução para tabuleiros maiores.
:- bench(20, []).

% "ff" escolhe sempre a rainha mais restringida no momento -- errando
% muito menos, e achando a solução ordens de magnitude mais rápido.
:- bench(20, [ff]).
:- bench(50, [ff]).
