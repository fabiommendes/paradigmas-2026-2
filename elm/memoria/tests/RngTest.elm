module RngTest exposing (suite)

import Expect
import Fuzz
import Rng
import Test exposing (Test, describe, fuzz, fuzz2, test)


suite : Test
suite =
    describe "Rng"
        [ fuzz2 Fuzz.int (Fuzz.list Fuzz.int) "shuffle devolve os mesmos elementos" <|
            \n list ->
                Rng.shuffle (Rng.seed n) list
                    |> Tuple.first
                    |> List.sort
                    |> Expect.equal (List.sort list)
        , fuzz Fuzz.int "a mesma semente dá o mesmo resultado" <|
            \n ->
                Rng.shuffle (Rng.seed n) (List.range 1 16)
                    |> Expect.equal (Rng.shuffle (Rng.seed n) (List.range 1 16))
        , fuzz Fuzz.int "int fica dentro do intervalo" <|
            \n ->
                Rng.int 3 7 (Rng.seed n)
                    |> Tuple.first
                    |> Expect.all [ Expect.atLeast 3, Expect.atMost 7 ]
        , test "sementes vizinhas embaralham de jeitos diferentes" <|
            \_ ->
                List.range 0 20
                    |> List.map (\n -> Tuple.first (Rng.shuffle (Rng.seed n) (List.range 1 16)))
                    |> unique
                    |> List.length
                    |> Expect.equal 21
        , test "todas as posições recebem cartas variadas" <|
            \_ ->
                -- Em 200 embaralhamentos, a primeira posição deve ver as 16 cartas.
                List.range 0 199
                    |> List.filterMap (\n -> List.head (Tuple.first (Rng.shuffle (Rng.seed n) (List.range 1 16))))
                    |> unique
                    |> List.length
                    |> Expect.equal 16
        ]


unique : List a -> List a
unique =
    List.foldl
        (\x acc ->
            if List.member x acc then
                acc

            else
                x :: acc
        )
        []
