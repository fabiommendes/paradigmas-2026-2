# Sintaxe do Prolog (fatos e regras)

Considere a base de conhecimento abaixo:

```prolog
homem(homer).
mulher(marge).
progenitor(homer, bart).
progenitor(marge, bart).
```

Qual das alternativas abaixo define corretamente uma **regra** que diz que
"X é pai de Y se X é homem e progenitor de Y"?

* [*] `pai(X, Y) :- homem(X), progenitor(X, Y).`
* [ ] `pai(X, Y) = homem(X), progenitor(X, Y).`
* [ ] `pai(X, Y) :- homem(Y), progenitor(Y, X).`
* [ ] `pai(homem(X), progenitor(X, Y)).`


## Justificativa

Regras em Prolog usam `:-` para separar a cabeça do corpo, e os literais do
corpo são separados por vírgula (conjunção "e"). A opção (a) verifica que X é
homem e que X é progenitor de Y, exatamente a definição de "pai". A opção (c)
inverte os papéis de X e Y; (b) usa `=` no lugar de `:-`; (d) não é sintaxe
válida de regra.
