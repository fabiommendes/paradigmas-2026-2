module Hello exposing (..)

import Html exposing (Html, div, text)
import Browser
import Html exposing (button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


type alias Model =
    { name : String }

type Msg
    = AddName String
    | Reset

main : Program ()  Model Msg
main = Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

init : Model
init = { name = "Joao" }

view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("Hello, " ++ model.name ++ "!") ]
        , div []
              [ button [ onClick (AddName "Maria") ] [ text "Maria" ]
              , button [ onClick (AddName "Jose") ] [ text "Jose" ]
              , button [ onClick Reset, style "background-color" "red" ] [ text "Reset" ]

              ]
        ]

update : Msg -> Model -> Model
update msg model =
    case msg of
        AddName name ->
            if model.name |> String.contains name then
                model
            else
                { model | name = model.name ++ " e " ++ name}
        Reset ->
            init