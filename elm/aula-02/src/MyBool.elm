module MyBool exposing (..)

type MyBool = MyTrue | MyFalse


{-| Nega o argumento booleano -}
not : MyBool -> MyBool
not value =
    case value of
        MyTrue -> MyFalse
        MyFalse -> MyTrue

{-| E logico entre dois booleanos -}
and : MyBool -> MyBool -> MyBool
and left right =
    if left == MyTrue && right == MyTrue then
        MyTrue
    else
        MyFalse