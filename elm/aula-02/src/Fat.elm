module Fat exposing (..)
import Nat exposing (Nat)

fat : Nat -> Nat
fat nat =
    if Nat.gt nat Nat.zero then
        nat |> Nat.mul (fat (nat |> Nat.sub Nat.one))
    else
        Nat.one

