module Temas exposing (main)

{-| Navegador de temas: lista os temas da API e mostra as cartas do escolhido.
A caixa "Pares iguais" decide o valor de `equalPairs` na requisição.

Rode a API (`pnpm api`, porta 8000) e, nesta pasta,
`elm reactor --port 8001`. Abra <http://localhost:8001/src/Temas.elm>

-}

import Api exposing (Card, Theme)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onClick)
import Http


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


{-| Uma requisição pode estar em andamento, ter falhado ou ter dado certo.
Um tipo soma deixa os três casos explícitos (e impossíveis de misturar).
-}
type Remote a
    = Loading
    | Failure Http.Error
    | Success a


type alias Model =
    { themes : Remote (List Theme)
    , equalPairs : Bool
    , cards : Maybe (Remote (List Card))
    }


type Msg
    = GotThemes (Result Http.Error (List Theme))
    | EqualPairsToggled Bool
    | ThemeClicked String
    | GotCards (Result Http.Error (List Card))


init : () -> ( Model, Cmd Msg )
init _ =
    ( { themes = Loading, equalPairs = False, cards = Nothing }
    , Api.getThemes GotThemes
    )


fromResult : Result Http.Error a -> Remote a
fromResult result =
    case result of
        Ok value ->
            Success value

        Err err ->
            Failure err


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotThemes result ->
            ( { model | themes = fromResult result }, Cmd.none )

        EqualPairsToggled value ->
            ( { model | equalPairs = value }, Cmd.none )

        ThemeClicked id ->
            ( { model | cards = Just Loading }
            , Api.getCards id model.equalPairs GotCards
            )

        GotCards result ->
            ( { model | cards = Just (fromResult result) }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ style "font-family" "sans-serif", style "padding" "1rem" ]
        [ h1 [] [ text "Temas" ]
        , label []
            [ input
                [ type_ "checkbox"
                , checked model.equalPairs
                , onCheck EqualPairsToggled
                ]
                []
            , text " Pares iguais"
            ]
        , viewRemote viewThemes model.themes
        , case model.cards of
            Nothing ->
                text ""

            Just cards ->
                viewRemote viewCards cards
        ]


viewRemote : (a -> Html Msg) -> Remote a -> Html Msg
viewRemote viewSuccess remote =
    case remote of
        Loading ->
            p [] [ text "Carregando..." ]

        Failure err ->
            p [ style "color" "darkred" ] [ text (errorToString err) ]

        Success value ->
            viewSuccess value


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl url ->
            "URL inválida: " ++ url

        Http.Timeout ->
            "O servidor demorou demais."

        Http.NetworkError ->
            "Sem conexão. A API está rodando?"

        Http.BadStatus status ->
            "O servidor respondeu com erro " ++ String.fromInt status

        Http.BadBody message ->
            "JSON inesperado: " ++ message


viewThemes : List Theme -> Html Msg
viewThemes themes =
    ul [ style "display" "flex", style "gap" "1rem", style "list-style" "none" ]
        (List.map viewThemeButton themes)


viewThemeButton : Theme -> Html Msg
viewThemeButton theme =
    li []
        [ button [ onClick (ThemeClicked theme.id) ]
            [ img [ src theme.cover, width 96, height 96 ] []
            , div [] [ strong [] [ text theme.name ] ]
            ]
        , p [ style "max-width" "12rem" ] [ text theme.description ]
        ]


viewCards : List Card -> Html Msg
viewCards cards =
    div
        [ style "display" "grid"
        , style "grid-template-columns" "repeat(8, 100px)"
        , style "gap" "0.5rem"
        ]
        (List.map viewCard cards)


viewCard : Card -> Html Msg
viewCard card =
    figure [ style "margin" "0" ]
        [ img [ src card.url, alt card.description, width 100, height 100 ] []
        , figcaption [ style "font-size" "0.75rem" ]
            [ text (String.fromChar card.group ++ ": " ++ card.description) ]
        ]
