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

import Api exposing (CardInfo)
import Rng exposing (Seed)


type alias Game =
    { cards : List Card
    , turn : Turn
    , flips : Int
    }


{-| Cada carta pertence a um grupo; a imagem e a descrição vêm da API.
-}
type alias Card =
    { id : CardId
    , group : Char
    , description : String
    , url : String
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


{-| Embaralha as cartas recebidas e começa um jogo. Devolve também a
semente seguinte, para a próxima partida sair diferente.
-}
new : Seed -> List CardInfo -> ( Game, Seed )
new seed infos =
    let
        ( cards, newSeed ) =
            infos
                |> List.indexedMap
                    (\id info ->
                        { id = id
                        , group = info.group
                        , description = info.description
                        , url = info.url
                        , face = Down
                        }
                    )
                |> Rng.shuffle seed
    in
    ( { cards = cards, turn = Waiting, flips = 0 }, newSeed )


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

Cada carta que vira para cima conta uma virada em `flips`.

-}
pick : Card -> Game -> Game
pick card game =
    case game.turn of
        Waiting ->
            { cards = game.cards |> setFace Up [ card.id ]
            , turn = OneRevealed ( card.group, card.id )
            , flips = game.flips + 1
            }

        OneRevealed ( group, id ) ->
            if card.id == id then
                game

            else if card.group == group then
                { cards = game.cards |> setFace Permanent [ card.id, id ]
                , turn = Waiting
                , flips = game.flips + 1
                }

            else
                { cards = game.cards |> setFace Up [ card.id ]
                , turn = TwoRevealed ( card.group, card.id ) ( group, id )
                , flips = game.flips + 1
                }

        TwoRevealed ( _, idA ) ( _, idB ) ->
            { game
                | cards = game.cards |> setFace Down [ idA, idB ]
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
    case game.turn of
        TwoRevealed ( _, idA ) ( _, idB ) ->
            { game
                | cards = game.cards |> setFace Down [ idA, idB ]
                , turn = Waiting
            }

        _ ->
            game


{-| Indica se todas as cartas já formam pares.
-}
isWon : Game -> Bool
isWon game =
    List.all (\card -> card.face == Permanent) game.cards


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
