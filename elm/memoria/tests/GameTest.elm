module GameTest exposing (suite)

import Expect
import Game exposing (Face(..), Turn(..))
import Rng
import Test exposing (Test, describe, test)


{-| Monta um jogo sem embaralhar: a carta na posição `i` tem `id = i`.
-}
fromGroups : List Char -> Game.Game
fromGroups groups =
    { cards =
        List.indexedMap
            (\id group ->
                { id = id
                , group = group
                , description = String.fromChar group
                , url = ""
                , face = Down
                }
            )
            groups
    , turn = Waiting
    , flips = 0
    }


{-| Tabuleiro pequeno e previsível: a, a, b, b.
-}
smallGame : Game.Game
smallGame =
    fromGroups [ 'a', 'a', 'b', 'b' ]


{-| As 16 cartas que a API devolveria para um tema.
-}
infos : List { group : Char, description : String, url : String }
infos =
    String.toList "aabbccddeeffgghh"
        |> List.indexedMap
            (\i group ->
                { group = group
                , description = "carta " ++ String.fromInt i
                , url = "/cards/" ++ String.fromInt i ++ ".webp"
                }
            )


clickAll : List Int -> Game.Game -> Game.Game
clickAll ids game =
    List.foldl Game.reveal game ids


faces : Game.Game -> List Face
faces game =
    List.map .face game.cards


suite : Test
suite =
    describe "Game"
        [ describe "new"
            [ test "distribui as cartas viradas para baixo" <|
                \_ ->
                    Game.new (Rng.seed 7) infos
                        |> Tuple.first
                        |> faces
                        |> Expect.equal (List.repeat 16 Down)
            , test "mantém todas as cartas recebidas" <|
                \_ ->
                    (Tuple.first (Game.new (Rng.seed 7) infos)).cards
                        |> List.map .description
                        |> List.sort
                        |> Expect.equal (List.sort (List.map .description infos))
            , test "cada carta ganha um id diferente" <|
                \_ ->
                    (Tuple.first (Game.new (Rng.seed 7) infos)).cards
                        |> List.map .id
                        |> List.sort
                        |> Expect.equal (List.range 0 15)
            , test "a semente seguinte embaralha de outro jeito" <|
                \_ ->
                    let
                        ( first, next ) =
                            Game.new (Rng.seed 7) infos

                        ( second, _ ) =
                            Game.new next infos
                    in
                    Expect.notEqual first.cards second.cards
            ]
        , describe "reveal"
            [ test "a primeira carta fica virada para cima" <|
                \_ ->
                    clickAll [ 0 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ Up, Down, Down, Down ]
                            , .turn >> Expect.equal (OneRevealed ( 'a', 0 ))
                            ]
            , test "duas cartas do mesmo grupo formam par" <|
                \_ ->
                    clickAll [ 0, 1 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ Permanent, Permanent, Down, Down ]
                            , .turn >> Expect.equal Waiting
                            ]
            , test "um erro deixa as duas cartas à mostra" <|
                \_ ->
                    clickAll [ 0, 2 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ Up, Down, Up, Down ]
                            , .turn >> Expect.equal (TwoRevealed ( 'b', 2 ) ( 'a', 0 ))
                            ]
            , test "depois de um erro, outra carta desvira as duas e começa nova jogada" <|
                \_ ->
                    clickAll [ 0, 2, 3 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ Down, Down, Down, Up ]
                            , .turn >> Expect.equal (OneRevealed ( 'b', 3 ))
                            ]
            , test "depois de um erro, clicar numa das cartas só desvira as duas" <|
                \_ ->
                    clickAll [ 0, 2, 0 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ Down, Down, Down, Down ]
                            , .turn >> Expect.equal Waiting
                            ]
            , test "clicar de novo na mesma carta não conta" <|
                \_ ->
                    let
                        picked =
                            clickAll [ 0 ] smallGame
                    in
                    Game.reveal 0 picked
                        |> Expect.equal picked
            , test "cartas que já formaram par não viram de novo" <|
                \_ ->
                    let
                        paired =
                            clickAll [ 0, 1 ] smallGame
                    in
                    Game.reveal 0 paired
                        |> Expect.equal paired
            , test "um id que não existe é ignorado" <|
                \_ ->
                    Game.reveal 99 smallGame
                        |> Expect.equal smallGame
            ]
        , describe "hideMismatch"
            [ test "desvira as cartas erradas" <|
                \_ ->
                    clickAll [ 0, 2 ] smallGame
                        |> Game.hideMismatch
                        |> Expect.all
                            [ faces >> Expect.equal (List.repeat 4 Down)
                            , .turn >> Expect.equal Waiting
                            ]
            , test "não faz nada fora de um erro" <|
                \_ ->
                    let
                        picked =
                            clickAll [ 0 ] smallGame
                    in
                    Game.hideMismatch picked
                        |> Expect.equal picked
            ]
        , describe "flips"
            [ test "um jogo novo começa sem viradas" <|
                \_ ->
                    Game.new (Rng.seed 7) infos
                        |> Tuple.first
                        |> .flips
                        |> Expect.equal 0
            , test "cada carta que vira para cima conta uma virada" <|
                \_ ->
                    clickAll [ 0, 2, 3, 2 ] smallGame
                        |> .flips
                        |> Expect.equal 4
            , test "formar um par conta as duas viradas" <|
                \_ ->
                    clickAll [ 0, 1 ] smallGame
                        |> .flips
                        |> Expect.equal 2
            , test "clicar de novo na mesma carta não conta" <|
                \_ ->
                    clickAll [ 0, 0 ] smallGame
                        |> .flips
                        |> Expect.equal 1
            , test "clicar numa carta que já formou par não conta" <|
                \_ ->
                    clickAll [ 0, 1, 0 ] smallGame
                        |> .flips
                        |> Expect.equal 2
            , test "depois de um erro, clicar numa das cartas só desvira, não conta" <|
                \_ ->
                    clickAll [ 0, 2, 0 ] smallGame
                        |> .flips
                        |> Expect.equal 2
            , test "hideMismatch não mexe no contador" <|
                \_ ->
                    clickAll [ 0, 2 ] smallGame
                        |> Game.hideMismatch
                        |> .flips
                        |> Expect.equal 2
            ]
        , describe "isWon"
            [ test "um jogo novo não está ganho" <|
                \_ ->
                    Expect.equal False (Game.isWon smallGame)
            , test "com um par faltando, ainda não ganhou" <|
                \_ ->
                    clickAll [ 0, 1 ] smallGame
                        |> Game.isWon
                        |> Expect.equal False
            , test "formar todos os pares ganha o jogo" <|
                \_ ->
                    fromGroups [ 'a', 'b', 'a', 'b' ]
                        |> clickAll [ 0, 2, 1, 3 ]
                        |> Game.isWon
                        |> Expect.equal True
            ]
        ]
