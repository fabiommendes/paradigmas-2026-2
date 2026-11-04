module User exposing (..)

import Address exposing (Address)
import Json.Encode as E exposing (Value)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D


type alias User =
    { name: String
    , age: Int
    , email: String
    , address: Address
    }

encode : User -> Value
encode user =
    E.object
        [ ("name", E.string user.name)
        , ("age", E.int user.age)
        , ("email", E.string user.email)
        , ("address", Address.encode user.address)
        ]

decoder : Decoder User
decoder =
    D.succeed User
        |> D.required "name" D.string
        |> D.required "age" D.int
        |> D.required "email" D.string
        |> D.required "address" Address.decoder

