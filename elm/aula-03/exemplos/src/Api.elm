module Api exposing (Card, Theme, getCards, getThemes)

{-| Tipos, decoders e requisições da API do jogo da memória.

Cada função `get...` devolve um `Cmd msg`: o Elm faz a requisição e, quando
a resposta chega, entrega uma mensagem com um `Result Http.Error a`.

-}

import Http
import Json.Decode as D exposing (Decoder)
import Url.Builder


{-| Endereço base. Com o proxy do Vite, basta "" (mesma origem).
-}
baseUrl : String
baseUrl =
    "http://localhost:8000"



-- TEMAS


type alias Theme =
    { id : String
    , name : String
    , description : String
    , cover : String
    }


themeDecoder : Decoder Theme
themeDecoder =
    D.map4 Theme
        (D.field "id" D.string)
        (D.field "name" D.string)
        (D.field "description" D.string)
        (D.field "cover" (D.map absolute D.string))


getThemes : (Result Http.Error (List Theme) -> msg) -> Cmd msg
getThemes toMsg =
    Http.get
        { url = baseUrl ++ "/api/themes"
        , expect = Http.expectJson toMsg (D.list themeDecoder)
        }



-- CARTAS


type alias Card =
    { group : Char
    , description : String
    , url : String
    }


cardDecoder : Decoder Card
cardDecoder =
    D.map3 Card
        (D.field "group" charDecoder)
        (D.field "description" D.string)
        (D.field "url" (D.map absolute D.string))


{-| JSON não tem caractere, só string. Validamos que a string tem uma letra.
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


{-| Imagens locais vêm como "/cards/...", as externas já vêm completas.
-}
absolute : String -> String
absolute url =
    if String.startsWith "/" url then
        baseUrl ++ url

    else
        url


{-| `Url.Builder` monta a query string e escapa os valores:
/api/cards?theme=ia&equalPairs=true
-}
getCards : String -> Bool -> (Result Http.Error (List Card) -> msg) -> Cmd msg
getCards theme equalPairs toMsg =
    let
        query =
            [ Url.Builder.string "theme" theme
            , Url.Builder.string "equalPairs"
                (if equalPairs then
                    "true"

                 else
                    "false"
                )
            ]
    in
    Http.get
        { url = baseUrl ++ Url.Builder.absolute [ "api", "cards" ] query
        , expect = Http.expectJson toMsg (D.list cardDecoder)
        }
