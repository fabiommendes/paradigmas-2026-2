module Hello exposing (..)

import Browser
import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)

type alias Model =
    String

type alias Msg =
    String

main : Program () Model Msg
main =
    Browser.sandbox
        { init = "galera"
        , update = \msg model -> msg
        , view = view }


view : String -> Html Msg
view name =
    div []
        [ div [] [ text ("Hello, " ++ name ++ "!") ]
        , div
            []
            [ button [ onClick "Joao" ] [ text "Joao" ]
            , button [ onClick "Maria" ] [ text "Maria" ]
            , button [ onClick "Jose" ] [ text "Jose" ]
            , button [ onClick "Ana" ] [ text "Ana" ]
            ]
        ]