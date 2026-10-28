module Address exposing (..)

import Json.Encode as E exposing (Value)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D

type alias Address =
    { street: String
    , city: String
    }

encode : Address -> Value
encode address =
    E.object
        [ ("street", E.string address.street)
        , ("city", E.string address.city)
        ]


decoder : Decoder Address
decoder =
    D.succeed Address                             -- Decoder (String -> String -> Address)
        |> D.required "street" D.string           -- Decoder (String -> Address)
        |> D.optional "city" D.string "Brasília"  -- Decoder Address