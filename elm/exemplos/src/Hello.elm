module Hello exposing (main)


import Browser
import Html exposing (Html, text)

main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = \_ -> text "Hello, World!" 
        }