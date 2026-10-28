module Recursao exposing (..)

factorial : Int -> Int
factorial n =
    if n == 0 then
        1
    else
         n * (factorial (n - 1))


fat : Int -> Int
fat =
    let
        do : Int -> Int -> Int
        do acc n =
            if n == 0 then
                acc
            else
                do (acc * n) (n - 1)
    in do 1

-- acc = 1
-- while (n != 0) {
--     acc = acc * n
--     n = n - 1
-- }
-- return acc


sumList1 : List number -> number
sumList1 lst =
    case lst of
      [] ->
        0
      x :: xs ->
        x + sumList1 xs

sumList2 : List number -> number
sumList2 =
    let
        do acc lst =
            case lst of
                [] -> acc
                x :: xs -> do (acc + x) xs
    in do 0


sumList3 : List number -> number
sumList3 = List.foldl (+) 0


concat : List String -> String
concat = List.foldl (swap (++)) ""

-- PARA CASA! tire os pontos (argumentos) da função abaixo.
join : String -> List String -> String
join sep = List.foldl (\x y -> y ++ sep ++ x) ""


id : a -> a
id x = x

swap : (a -> b -> c) -> b -> a -> c
swap f x y = f y x

ex : List Int
ex = List.range 0 20000