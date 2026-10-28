module MyResult exposing (..)


type MyResult err a = Ok a | Err err

map : (a -> b) -> MyResult err a -> MyResult err b
map f res =
    case res of
        Ok x -> Ok (f x)
        Err e -> Err e

mapError : (e1 -> e2) -> MyResult e1 a -> MyResult e2 a
mapError f res =
    case res of
        Ok x -> Ok x
        Err e -> Err (f e)


andThen : (a -> MyResult err b) -> MyResult err a -> MyResult err b
andThen f res =
    case res of
        Ok x -> f x
        Err e -> Err e


unwrap : MyResult a a -> a
unwrap res =
    case res of
        Ok x -> x
        Err e -> e

withDefault : a -> MyResult err a -> a
withDefault default res =
    res |> mapError (\_ -> default) |> unwrap


withDefaultElse : (err -> a) -> MyResult err a -> a
withDefaultElse f res =
    res |> mapError f |> unwrap

id : a -> a
id x = x

always : a -> b -> a
always x = \_ -> x