module Option exposing (..)


-- Functor (F a)
-- map  : (a -> b) -> F a -> F b
-- pure : a -> F a
-- map id fx = fx
type Option a = Some a | None
-- type Maybe a = Just a | Nothing

pure : a -> Option a
pure = Some

map : (a -> b) -> Option a -> Option b
map f opt =
    case opt of
        Some x -> Some (f x)
        None -> None

-- Verificando implementação honestas
-- map id (Some x) = Some x
-- map id None = None
-- ==> map id opt = opt

-- Mônada (M a)
-- andThen : (a -> M b) -> M a -> M b
-- andThen pure mx = mx
-- flat : M (M a) -> M a
-- andThen pure mx = mx


andThen : (a -> Option b) -> Option a -> Option b
andThen f opt =
-- andThen f opt = map f opt |> flat
    case opt of
        Some x -> f x
        None -> None

flat : Option (Option a) -> Option a
flat opt =
    case opt of
        Some x -> x
        None -> None


-- filter pred opt = opt |> andThen (\x -> if pred x then Some x else None)
filter : (a -> Bool) -> Option a -> Option a
filter pred opt =
    case opt of
        Some x -> if pred x then Some x else None
        None -> None


removeNones : List (Option a) -> List a
removeNones lst =
    case lst of
        head :: tail ->
            case head of
                Some x -> x :: removeNones tail
                None -> removeNones tail
        [] -> []