module Game exposing (..)

{-| As regras do jogo da memória, sem nenhuma parte visual.

Tudo aqui é função pura: recebe um jogo e devolve outro. Isso permite
testar as regras sem abrir o navegador (veja `tests/GameTest.elm`).

Cada carta pertence a um grupo (`'a'` a `'h'`) e é o membro 1 ou 2 dele.
No tema dos animais, o grupo é a espécie e o membro é o macho ou a fêmea.
A regra que diferencia este jogo do tradicional fica em `isPair`: duas
cartas formam par quando são do mesmo grupo e membros diferentes, e não
quando são iguais.

-}

import Rng exposing (Seed)


type alias Game =
    { cards : List Card
    , turn : Turn
    }


{-| Assets de cada carta são identificados por um par (letra, numero), como
"a1", "b2", etc
-}
type alias Card =
    { id : CardId
    , group : Char
    , index : Int
    , face : Face
    }


type alias CardData =
    ( Char, Int )


type alias CardId =
    Int


type Face
    = Up
    | Down
    | Permanent


{-| Em que ponto da jogada estamos.
-}
type Turn
    = Waiting
    | OneRevealed CardData
    | TwoRevealed CardData CardData


{-| Embaralha as cartas e começa um jogo. Devolve também a semente seguinte,
para a próxima partida sair diferente.
-}
new : Seed -> ( Game, Seed )
new seed =
    let
        ( cards, newSeed ) =
            [ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' ]
                |> List.map (\chr -> [ { group = chr, index = 1 }, { group = chr, index = 2 } ])
                |> List.concat
                |> List.indexedMap
                    (\id { group, index } ->
                        { id = id
                        , group = group
                        , index = index
                        , face = Down
                        }
                    )
                |> Rng.shuffle seed

        game =
            { cards = cards, turn = Waiting }
    in
    ( game, newSeed )


{-| Vira a carta com este `id`. Cartas que já formaram par são ignoradas.
-}
reveal : CardId -> Game -> Game
reveal id game =
    case findCard id game of
        Just card ->
            if card.face == Permanent then
                game

            else
                pick card game

        Nothing ->
            game


{-| Processa a carta escolhida de acordo com o estado da jogada.
-}
pick : Card -> Game -> Game
pick card game =
    case game.turn of
        Waiting ->
            { cards = game.cards |> setFace Up [ card.id ]
            , turn = OneRevealed ( card.group, card.id )
            }

        OneRevealed ( group, id ) ->
            if card.id == id then
                game

            else if card.group == group then
                { cards = game.cards |> setFace Permanent [ card.id, id ]
                , turn = Waiting
                }

            else
                { cards = game.cards |> setFace Up [ card.id ]
                , turn = TwoRevealed ( card.group, card.id ) ( group, id )
                }

        TwoRevealed ( _, idA ) ( _, idB ) ->
            { cards = game.cards |> setFace Down [ idA, idB ]
            , turn = Waiting
            }
                |> runIf (card.id /= idA && card.id /= idB) (pick card)


runIf : Bool -> (b -> b) -> (b -> b)
runIf cond fn =
    if cond then
        fn

    else
        \x -> x


{-| Desvira as duas cartas que não formaram par.
-}
hideMismatch : Game -> Game
hideMismatch game =
    Debug.todo "hideMismatch"


{-| Indica se todas as cartas já formam pares.
-}
isWon : Game -> Bool
isWon game =
    Debug.todo "isWon"


{-| Procura uma carta pelo identificador.
-}
findCard : CardId -> Game -> Maybe Card
findCard id game =
    game.cards
        |> List.filter (\card -> card.id == id)
        |> List.head


{-| Atualiza a face das cartas cujos identificadores foram informados.
-}
setFace : Face -> List CardId -> List Card -> List Card
setFace face ids cards =
    cards
        |> List.map
            (\card ->
                if List.member card.id ids then
                    { card | face = face }

                else
                    card
            )
