module Nat exposing (Nat, fromInt, zero, one, mul, sum, sub, gt, ge, toInt, fromIntUnsafe)


type Nat = IsPos Int

fromInt : Int -> Maybe Nat
fromInt n =
    if n >= 0 then
        Just (IsPos n)
    else
        Nothing

{-| Não confere se o argumento é inteiro.

Só use se conseguir provar isso por outros meios!
-}
fromIntUnsafe : Int ->  Nat
fromIntUnsafe n =
    IsPos n

toInt : Nat -> Int
toInt (IsPos n) =
    n

zero : Nat
zero = IsPos 0

one : Nat
one = IsPos 1

mul : Nat -> Nat -> Nat
mul (IsPos a) (IsPos b) =
    IsPos (a * b)

sum : Nat -> Nat -> Nat
sum (IsPos a) (IsPos b) =
    IsPos (a + b)

sub : Nat -> Nat -> Nat
sub (IsPos a) (IsPos b) =
    IsPos (max (a - b) 0)

gt : Nat -> Nat -> Bool
gt (IsPos a) (IsPos b) =
    a > b

ge : Nat -> Nat -> Bool
ge (IsPos a) (IsPos b) =
    a >= b