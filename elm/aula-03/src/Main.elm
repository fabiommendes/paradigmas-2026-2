module Main exposing (main)

{-| Ponto de entrada: liga as regras de `Game` à tela, seguindo a Arquitetura
Elm (modelo, mensagens, `update` e `view`).
-}

import Browser
import Game exposing (Card, Face(..), Game, Turn(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Process
import Rng exposing (Seed)
import Task


{-| O JavaScript passa um número aleatório como semente (veja `src/main.js`).
-}
type alias Flags =
    Int


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODELO


type alias Model =
    { game : Game
    , seed : Seed
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( newModel (Rng.seed flags), Cmd.none )


newModel : Seed -> Model
newModel seed =
    let
        ( game, nextSeed ) =
            Game.new seed
    in
    { game = game, seed = nextSeed }



-- ATUALIZAÇÃO


type Msg
    = CardClicked Int
    | MismatchTimeout
    | NewGameClicked


{-| Tempo, em milissegundos, que as duas cartas erradas ficam à mostra.
-}
mismatchDelay : Float
mismatchDelay =
    1000


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CardClicked id ->
            ( { model | game = Game.reveal id model.game }, Cmd.none )

        NewGameClicked ->
            let
                ( newGame, newSeed ) =
                    Game.new model.seed
            in
            ( { game = newGame, seed = newSeed }, Cmd.none )

        MismatchTimeout ->
            ( model, Cmd.none )



-- VISUALIZAÇÃO


{-| HTML esperado (exemplo sem vitória):
-}
view : Model -> Html Msg
view model =
    main_
        [ class "table" ]
        [ ol
            [ class "board"
            , attribute "aria-label" "Tabuleiro"
            ]
            (model.game.cards |> List.map (viewCard model.game.turn))
        , viewNewGameButton
        ]


viewNewGameButton : Html Msg
viewNewGameButton =
    button
        [ class "fab"
        , type_ "button"
        , attribute "aria-label" "Novo jogo"
        , title "Novo jogo"
        , onClick NewGameClicked
        ]
        []


viewCard : Turn -> Card -> Html Msg
viewCard turn card =
    let
        cardClasses =
            case card.face of
                Up ->
                    "card card--up"

                Down ->
                    "card"

                Permanent ->
                    "card card--up card--matched"
    in
    li
        [ class "board__slot"
        ]
        [ button
            [ type_ "button"
            , class cardClasses
            , onClick (CardClicked card.id)
            ]
            [ span
                [ class "card__inner"
                ]
                [ span
                    [ class "card__back"
                    ]
                    []
                , span
                    [ class "card__front"
                    ]
                    [ img
                        [ class "card__image"
                        , src (cardUrl card)
                        , alt ""
                        ]
                        []
                    ]
                ]
            ]
        ]


cardUrl : Card -> String
cardUrl card =
    "cards/animals/" ++ (card.group |> String.fromChar) ++ (card.index |> String.fromInt) ++ ".webp"


isMissed : Turn -> Card -> Bool
isMissed turn card =
    False


viewVictory : Game -> Html Msg
viewVictory game =
    div
        [ class "overlay" ]
        [ node "dialog"
            [ class "victory"
            , attribute "open" ""
            , attribute "aria-labelledby" "victory-title"
            ]
            [ h2
                [ id "victory-title"
                , class "victory__title"
                ]
                [ text "Parabéns!" ]
            , p
                [ class "victory__text"
                ]
                [ text "8 jogadas" ]
            , button
                [ class "button button--primary"
                , type_ "button"
                , autofocus True
                ]
                [ text "Jogar de novo" ]
            ]
        ]


todo : Html msg
todo =
    div [] [ text "TODO" ]
