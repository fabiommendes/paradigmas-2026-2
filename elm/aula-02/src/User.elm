module User exposing (..)

type alias UserId = Int
type alias Age = Int
type alias Name = String

type alias User =
    { name: Name
    , email: Email
    , age: Age
    , id: UserId
    }

{-| Cria a linha de contato tipo 'nome <email>' -}
makeContact : Name -> Email -> String
makeContact name email =
    name ++ " <" ++ (toString email) ++ ">"



type Email = Email String


fromString : String -> Maybe Email
fromString data =
    if isValidEmail data then
        Just (Email data)
    else
        Nothing


fromStringUnsafe : String -> Email
fromStringUnsafe str = Email str

toString : Email -> String
toString (Email data) = data


myEmail = fromString "not-an-email"


isValidEmail : String -> Bool
isValidEmail str =
    str |> String.contains "@"