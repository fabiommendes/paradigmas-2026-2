module Counter exposing (..)

import Browser
import Html as H exposing (Html, text)
import Html.Events exposing (onClick)

type alias Model =
    { count : Int }

type Msg = Incr Int
         | Decr Int
         | Reset

main : Program () Model Msg
main =
    Browser.sandbox
        { init = { count = 0 }
        , update = update
        , view = view }

update : Msg -> Model -> Model
update msg model =
    case msg of
        Incr n ->
            { model | count = model.count + n }

        Decr n ->
            { model | count = model.count - n }

        Reset ->
            { model | count = 0 }

view : Model -> Html Msg
view m =
    H.div []
        [ H.button [ onClick (Decr 10) ] [ text "-10" ]
        , H.button [ onClick (Decr 1) ] [ text "-" ]
        , H.span [] [ text (String.fromInt m.count) ]
        , H.button [ onClick (Incr 1) ] [ text "+" ]
        , H.button [ onClick (Incr 10) ] [ text "+10" ]
        , H.button [ onClick Reset ] [ text "reset" ]
        ]