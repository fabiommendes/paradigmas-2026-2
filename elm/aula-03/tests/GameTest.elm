module GameTest exposing (suite)

import Expect
import Game exposing (Face(..), Turn(..))
import Rng
import Test exposing (Test, describe, test)


{-| Tabuleiro pequeno e previsível: a1, a2, b1, b2 e outro b1.
-}
smallGame : Game.Game
smallGame =
    Game.fromDeck
        [ ( 'a', 1 )
        , ( 'a', 2 )
        , ( 'b', 1 )
        , ( 'b', 2 )
        , ( 'b', 1 )
        ]


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
            [ test "distribui 16 cartas viradas para baixo" <|
                \_ ->
                    Game.new (Rng.seed 7)
                        |> Tuple.first
                        |> faces
                        |> Expect.equal (List.repeat 16 FaceDown)
            , test "cada grupo aparece uma vez com o membro 1 e uma vez com o 2" <|
                \_ ->
                    (Tuple.first (Game.new (Rng.seed 7))).cards
                        |> List.map (\c -> String.fromChar c.group ++ String.fromInt c.member)
                        |> List.sort
                        |> Expect.equal
                            [ "a1", "a2", "b1", "b2", "c1", "c2", "d1", "d2", "e1", "e2", "f1", "f2", "g1", "g2", "h1", "h2" ]
            , test "a semente seguinte embaralha de outro jeito" <|
                \_ ->
                    let
                        ( first, next ) =
                            Game.new (Rng.seed 7)

                        ( second, _ ) =
                            Game.new next
                    in
                    Expect.notEqual first.cards second.cards
            ]
        , describe "isPair"
            [ test "mesmo grupo e membros diferentes formam par" <|
                \_ ->
                    case smallGame.cards of
                        a1 :: a2 :: _ ->
                            Expect.equal True (Game.isPair a1 a2)

                        _ ->
                            Expect.fail "tabuleiro inesperado"
            , test "grupos diferentes não formam par" <|
                \_ ->
                    case smallGame.cards of
                        _ :: a2 :: b1 :: _ ->
                            Expect.equal False (Game.isPair a2 b1)

                        _ ->
                            Expect.fail "tabuleiro inesperado"
            , test "mesmo grupo e mesmo membro não formam par" <|
                \_ ->
                    case smallGame.cards of
                        _ :: _ :: b1 :: _ :: otherB1 :: _ ->
                            Expect.equal False (Game.isPair b1 otherB1)

                        _ ->
                            Expect.fail "tabuleiro inesperado"
            ]
        , describe "reveal"
            [ test "a primeira carta fica virada para cima" <|
                \_ ->
                    clickAll [ 0 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ FaceUp, FaceDown, FaceDown, FaceDown, FaceDown ]
                            , .turn >> Expect.equal (OnePicked 0)
                            , .moves >> Expect.equal 0
                            ]
            , test "um casal fica marcado como encontrado" <|
                \_ ->
                    clickAll [ 0, 1 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ Matched, Matched, FaceDown, FaceDown, FaceDown ]
                            , .turn >> Expect.equal Waiting
                            , .moves >> Expect.equal 1
                            ]
            , test "um erro deixa as duas cartas à mostra" <|
                \_ ->
                    clickAll [ 0, 2 ] smallGame
                        |> Expect.all
                            [ faces >> Expect.equal [ FaceUp, FaceDown, FaceUp, FaceDown, FaceDown ]
                            , .turn >> Expect.equal (Mismatch 0 2)
                            , .moves >> Expect.equal 1
                            ]
            , test "duas cartas b1 não formam par" <|
                \_ ->
                    clickAll [ 2, 4 ] smallGame
                        |> .turn
                        |> Expect.equal (Mismatch 2 4)
            , test "cliques durante um erro são ignorados" <|
                \_ ->
                    let
                        missed =
                            clickAll [ 0, 2 ] smallGame
                    in
                    Game.reveal 3 missed
                        |> Expect.equal missed
            , test "clicar de novo na mesma carta não conta" <|
                \_ ->
                    let
                        picked =
                            clickAll [ 0 ] smallGame
                    in
                    Game.reveal 0 picked
                        |> Expect.equal picked
            , test "cartas já encontradas não viram de novo" <|
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
                            [ faces >> Expect.equal (List.repeat 5 FaceDown)
                            , .turn >> Expect.equal Waiting
                            , .moves >> Expect.equal 1
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
        , describe "isWon"
            [ test "um jogo novo não está ganho" <|
                \_ ->
                    Expect.equal False (Game.isWon smallGame)
            , test "formar todos os casais ganha o jogo" <|
                \_ ->
                    Game.fromDeck [ ( 'a', 1 ), ( 'b', 2 ), ( 'a', 2 ), ( 'b', 1 ) ]
                        |> clickAll [ 0, 2, 1, 3 ]
                        |> Expect.all
                            [ Game.isWon >> Expect.equal True
                            , .moves >> Expect.equal 2
                            ]
            ]
        ]
