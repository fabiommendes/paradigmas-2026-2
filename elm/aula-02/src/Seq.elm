module Seq exposing (..)

type Seq a
    = Empty
    | Cons a (Seq a)


-- Definicao de lista do Elm
-- type List a
--     = []
--     | a :: (Seq a)


fromList : List a -> Seq a
fromList lst =
    case lst of
        [] -> Empty
        x :: xs -> Cons x (fromList xs)


toList : Seq a -> List a
toList seq =
    case seq of
        Empty -> []
        Cons x xs -> x :: toList xs


map : (a -> b) -> Seq a -> Seq b
map f seq =
    case seq of
        Empty -> Empty
        Cons x xs -> Cons (f x) (map f xs)


reduce : (a -> b -> b) -> b -> Seq a -> b
reduce f acc seq =
    case seq of
        Empty -> acc
        Cons x xs -> f x (reduce f acc xs)
