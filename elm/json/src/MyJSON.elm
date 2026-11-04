module MyJSON exposing (..)
import Dict exposing (Dict)

type Value
    = Null
    | True
    | False
    | Int Int
    | Float Float
    | String String
    | Array (List Value)
    | Object (Dict String Value)

null : Value
null = Null

bool : Bool -> Value
bool value =
    if value then
        True
    else
        False

int : Int -> Value
int value =
    Int value

float : Float -> Value
float value =
    Float value

string : String -> Value
string value =
    String value


list : (a -> Value) -> List a -> Value
list fn lst =
    lst
        |> List.map fn
        |> Array

object : List (String, Value) -> Value
object data =
    data
        |> Dict.fromList
        |> Object


type alias User =
    { name: String
    , age: Int
    }

encode : User -> Value
encode user =
    object
        [ ("name", string user.name)
        , ("age", int user.age )
        ]

