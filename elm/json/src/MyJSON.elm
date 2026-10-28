module MyJSON exposing (..)
import Dict exposing (Dict)


type Value
   = Null
   | Bool Bool
   | Float Float
   | Int Int
   | String String
   | Array (List Value)
   | Object (Dict String Value)



string : String -> Value
string = String

int : Int -> Value
int = Int


bool : Bool -> Value
bool = Bool

list : (a -> Value) -> List a -> Value
list fn = List.map fn >> Array


object : List (String, Value) -> Value
object = Dict.fromList >> Object


type alias User = { name: String, age: Int }


encode : User -> Value
encode user =
    object
        [ ("name", string user.name)
        , ("age", int user.age)
        ]