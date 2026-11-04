module Main exposing (main)

{-| Ponto de entrada: liga as regras de `Game` à tela, seguindo a Arquitetura
Elm (modelo, mensagens, `update` e `view`).
-}

import Api exposing (CardInfo)
import Browser
import Game exposing (Card, Face(..), Game, Turn(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
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
    { seed : Seed
    , state : State
    }


{-| Em que ponto está a requisição das cartas.
-}
type State
    = Loading
    | Failed Http.Error
    | Playing Game


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { seed = Rng.seed flags, state = Loading }, fetchCards )


fetchCards : Cmd Msg
fetchCards =
    Api.getCards "animals" False GotCards



-- ATUALIZAÇÃO


type Msg
    = CardClicked Int
    | MismatchTimeout
    | NewGameClicked
    | GotCards (Result Http.Error (List CardInfo))


{-| Tempo, em milissegundos, que as duas cartas erradas ficam à mostra.
-}
mismatchDelay : Float
mismatchDelay =
    1000


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCards (Ok infos) ->
            let
                ( game, nextSeed ) =
                    Game.new model.seed infos
            in
            ( { seed = nextSeed, state = Playing game }, Cmd.none )

        GotCards (Err err) ->
            ( { model | state = Failed err }, Cmd.none )

        CardClicked id ->
            case model.state of
                Playing game ->
                    ( { model | state = Playing (Game.reveal id game) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NewGameClicked ->
            ( { model | state = Loading }, fetchCards )

        MismatchTimeout ->
            ( model, Cmd.none )



-- VISUALIZAÇÃO


{-| HTML esperado (exemplo sem vitória):
-}
view : Model -> Html Msg
view model =
    main_
        [ class "table" ]
        [ case model.state of
            Loading ->
                p [ class "status" ] [ text "Carregando as cartas..." ]

            Failed err ->
                p [ class "status status--error" ] [ text (errorToString err) ]

            Playing game ->
                ol
                    [ class "board"
                    , attribute "aria-label" "Tabuleiro"
                    ]
                    (game.cards |> List.map (viewCard game.turn))
        , viewNewGameButton
        ]


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl url ->
            "URL inválida: " ++ url

        Http.Timeout ->
            "O servidor demorou demais para responder."

        Http.NetworkError ->
            "Sem conexão com o servidor. A API está rodando?"

        Http.BadStatus 404 ->
            "Tema não encontrado."

        Http.BadStatus status ->
            "O servidor respondeu com erro " ++ String.fromInt status ++ "."

        Http.BadBody message ->
            "Resposta inesperada do servidor: " ++ message


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
                        , src card.url
                        , alt card.description
                        ]
                        []
                    ]
                ]
            ]
        ]


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
