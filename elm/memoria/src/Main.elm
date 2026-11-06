module Main exposing (main)

{-| Ponto de entrada: liga as regras de `Game` à tela, seguindo a Arquitetura
Elm (modelo, mensagens, `update` e `view`).
-}

import Api exposing (CardInfo, Theme)
import Browser
import Game exposing (Card, Face(..), Game, Turn(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onClick, onInput)
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
    , themes : List Theme
    , theme : String
    , equalPairs : Bool
    }


{-| Em que ponto está a requisição das cartas.
-}
type State
    = Loading
    | Failed Http.Error
    | Playing Game


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { seed = Rng.seed flags
            , state = Loading
            , themes = []
            , theme = "animals"
            , equalPairs = False
            }
    in
    ( model, Cmd.batch [ Api.getThemes GotThemes, fetchCards model ] )


fetchCards : Model -> Cmd Msg
fetchCards model =
    Api.getCards model.theme model.equalPairs GotCards



-- ATUALIZAÇÃO


type Msg
    = CardClicked Int
    | MismatchTimeout Turn
    | NewGameClicked
    | GotCards (Result Http.Error (List CardInfo))
    | GotThemes (Result Http.Error (List Theme))
    | ThemeSelected String
    | EqualPairsToggled Bool


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
            ( { model | seed = nextSeed, state = Playing game }, Cmd.none )

        GotCards (Err err) ->
            ( { model | state = Failed err }, Cmd.none )

        CardClicked id ->
            case model.state of
                Playing game ->
                    let
                        newGame =
                            Game.reveal id game
                    in
                    ( { model | state = Playing newGame }, hideLater newGame.turn )

                _ ->
                    ( model, Cmd.none )

        MismatchTimeout turn ->
            case model.state of
                -- Só desvira se as mesmas duas cartas ainda estiverem à mostra.
                -- O jogador pode ter clicado em outra carta antes do tempo.
                Playing game ->
                    if game.turn == turn then
                        ( { model | state = Playing (Game.hideMismatch game) }, Cmd.none )

                    else
                        ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NewGameClicked ->
            startNewGame model

        GotThemes (Ok themes) ->
            ( { model | themes = themes }, Cmd.none )

        GotThemes (Err _) ->
            ( model, Cmd.none )

        ThemeSelected theme ->
            startNewGame { model | theme = theme }

        EqualPairsToggled equalPairs ->
            startNewGame { model | equalPairs = equalPairs }


startNewGame : Model -> ( Model, Cmd Msg )
startNewGame model =
    ( { model | state = Loading }, fetchCards model )


{-| Agenda `MismatchTimeout` quando há duas cartas erradas à mostra.
-}
hideLater : Turn -> Cmd Msg
hideLater turn =
    case turn of
        TwoRevealed _ _ ->
            Process.sleep mismatchDelay
                |> Task.perform (\_ -> MismatchTimeout turn)

        _ ->
            Cmd.none



-- VISUALIZAÇÃO


{-| HTML esperado (exemplo sem vitória):
-}
view : Model -> Html Msg
view model =
    main_
        [ class "table" ]
        [ viewToolbar model
        , case model.state of
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


viewToolbar : Model -> Html Msg
viewToolbar model =
    div [ class "toolbar" ]
        [ label []
            [ text "Tema "
            , select [ onInput ThemeSelected ]
                (model.themes |> List.map (viewThemeOption model.theme))
            ]
        , label []
            [ input
                [ type_ "checkbox"
                , checked model.equalPairs
                , onCheck EqualPairsToggled
                ]
                []
            , text " Pares iguais"
            ]
        ]


viewThemeOption : String -> Theme -> Html Msg
viewThemeOption current theme =
    option [ value theme.id, selected (theme.id == current) ] [ text theme.name ]


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
