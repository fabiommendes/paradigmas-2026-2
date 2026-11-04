module Api exposing (CardInfo, getCards)

{-| Comunicação com a API do jogo da memória (veja `server/main.py`).
-}

import Http
import Json.Decode as D exposing (Decoder)
import Url.Builder



-- CARTAS


{-| Uma carta como vem da API, antes de entrar no jogo.
-}
type alias CardInfo =
    { group : Char
    , description : String
    , url : String
    }


cardDecoder : Decoder CardInfo
cardDecoder =
    D.map3 CardInfo
        (D.field "group" charDecoder)
        (D.field "description" D.string)
        (D.field "url" D.string)


{-| O JSON não tem caractere, só string. Aceita apenas strings com uma letra.
-}
charDecoder : Decoder Char
charDecoder =
    D.string
        |> D.andThen
            (\s ->
                case String.toList s of
                    [ c ] ->
                        D.succeed c

                    _ ->
                        D.fail ("esperava uma letra, veio " ++ s)
            )


{-| Pede as cartas de um tema. Monta a URL
`/api/cards?theme=animals&equalPairs=false`.
-}
getCards : String -> Bool -> (Result Http.Error (List CardInfo) -> msg) -> Cmd msg
getCards theme equalPairs toMsg =
    Http.get
        { url =
            Url.Builder.absolute [ "api", "cards" ]
                [ Url.Builder.string "theme" theme
                , Url.Builder.string "equalPairs" (boolToString equalPairs)
                ]
        , expect = Http.expectJson toMsg (D.list cardDecoder)
        }


boolToString : Bool -> String
boolToString b =
    if b then
        "true"

    else
        "false"
