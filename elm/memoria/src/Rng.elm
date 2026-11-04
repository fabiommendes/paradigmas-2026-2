module Rng exposing (Seed, seed, int, shuffle)

{-| Gerador de números pseudoaleatórios puro.

Este módulo é infraestrutura fornecida pronta: os alunos usam, mas não
precisam escrevê-lo. Ele evita `elm/random` para que o embaralhamento seja
uma função pura comum, sem `Cmd` nem `Generator`:

    ( embaralhada, proxima ) =
        shuffle (seed 42) [ 1, 2, 3 ]

A mesma semente sempre gera a mesma sequência. Para variar entre partidas,
guarde a semente devolvida e use-a na próxima chamada.

O algoritmo é um gerador congruencial linear com as constantes do livro
Numerical Recipes:

    x' = (1664525 * x + 1013904223) mod 2^32

O produto cabe nos 53 bits exatos de um número do JavaScript, então a conta
é feita com `Int` comum.

@docs Seed, seed, int, shuffle

-}

import Array exposing (Array)


{-| Estado do gerador. É opaco: só este módulo sabe o que tem dentro.
-}
type Seed
    = Seed Int


{-| Cria uma semente a partir de um inteiro qualquer, por exemplo o valor
recebido do JavaScript nas flags.

Sementes vizinhas, como 1 e 2, dariam primeiros sorteios quase iguais. Dois
passos do gerador já bastam para afastá-las.

-}
seed : Int -> Seed
seed n =
    Seed (modBy modulus n) |> next |> next


{-| Sorteia um inteiro entre `low` e `high`, incluindo os dois.

Usa a fração `x / 2^32` em vez de `modBy`, porque os bits baixos de um
gerador congruencial se repetem em ciclos curtos.

-}
int : Int -> Int -> Seed -> ( Int, Seed )
int low high current =
    let
        ((Seed x) as following) =
            next current

        fraction =
            toFloat x / toFloat modulus
    in
    ( low + floor (fraction * toFloat (high - low + 1)), following )


{-| Embaralha uma lista com o algoritmo de Fisher-Yates.
-}
shuffle : Seed -> List a -> ( List a, Seed )
shuffle current list =
    let
        array =
            Array.fromList list

        step : Int -> ( Array a, Seed ) -> ( Array a, Seed )
        step i ( acc, s ) =
            let
                ( j, s2 ) =
                    int 0 i s
            in
            ( swap i j acc, s2 )

        swap : Int -> Int -> Array a -> Array a
        swap i j items =
            case ( Array.get i items, Array.get j items ) of
                ( Just a, Just b ) ->
                    items |> Array.set i b |> Array.set j a

                _ ->
                    items
    in
    List.range 1 (Array.length array - 1)
        |> List.reverse
        |> List.foldl step ( array, current )
        |> Tuple.mapFirst Array.toList


next : Seed -> Seed
next (Seed x) =
    Seed ((1664525 * x + 1013904223) |> modBy modulus)


modulus : Int
modulus =
    4294967296
