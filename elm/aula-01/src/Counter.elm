module Counter exposing (..)

import Html exposing (Html, div, text, span)
import Browser
import Html exposing (button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


type alias Model =
    { number : Int }

type Msg
    = Incr Int
    | Decr Int
    | Reset

main : Program ()  Model Msg
main = Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

init : Model
init = { number = 0 }

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Decr 10) ] [ text "-10" ]
        , button [ onClick (Decr 1) ] [ text "-" ]
        , span [ style "padding" "1rem" ] [ text (String.fromInt model.number) ]
        , button [ onClick (Incr 1) ] [ text "+" ]
        , button [ onClick (Incr 10) ] [ text "+10" ]
        , button [ onClick Reset, style "background-color" "red" ] [ text "reset" ]

        ]

update : Msg -> Model -> Model
update msg model =
    case msg of
        Incr n ->
            { model | number = model.number + n}
        Decr n ->
            { model | number = model.number - n}
        Reset ->
            init