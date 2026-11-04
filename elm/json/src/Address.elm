module Address exposing (..)

import Json.Encode as E exposing (Value)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D


type Address
    = Real { street: String, city: String }
    | Virtual { uri: String }


encode : Address -> Value
encode address =
    case address of
        Real { street, city } ->
            E.object
                [ ("type", E.string "real")
                , ("street", E.string street)
                , ("city", E.string city)
                ]
        Virtual { uri } ->
            E.object
                [ ("type", E.string "virtual")
                , ("uri", E.string uri)
                ]


decoder : Decoder Address
decoder =
    (D.field "type" D.string)
        |> D.andThen (
            \typ ->
            case typ of
                "real" ->
                    D.succeed (\street city -> Real {street = street, city = city })
                        |> D.required "street" D.string
                        |> D.required "city" D.string

                "virtual" ->
                    D.succeed (\uri -> Virtual {uri = uri })
                        |> D.required "uri" D.string

                _ ->
                    D.fail ("Tipo inválido: " ++ typ ++ ", esperava real ou virtual")

        )
