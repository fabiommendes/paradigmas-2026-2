module Lens exposing (..)

type alias User =
    { name: String
    , email: String
    , address:
        { street: String
        , city: String
        , zip: String
        }
    }

type alias Address =
    { street: String
    , city: String
    , zip: String
    }

user : User
user =
    { name = "John Doe"
    , email = "john.doe@example.com"
    , address =
        { street = "123 Elm St"
        , city = "Somewhere"
        , zip = "12345"
        }
    }
user2 : User
user2 = user |> cityAtUser.set "Springfield"


cityAtUser : Lens User String
cityAtUser =
    compose address city

type alias Lens a b =
    { get : a -> b
    , set : b -> a -> a
    }


address : Lens { a | address : b } b
address =
    { get = .address
    , set = \value root -> { root | address = value }
    }

city : Lens { a | city : b } b
city =
    { get = .city
    , set = \value root -> { root | city = value }
    }

name : Lens { a | name : b } b
name =
    { get = .name
    , set = \value root -> { root | name = value }
    }

email : Lens { a | email : b } b
email =
    { get = .email
    , set = \value root -> { root | email = value }
    }

age : Lens { a | age : b } b
age =
    { get = .age
    , set = \value root -> { root | age = value }
    }

bar : Lens { a | bar : b } b
bar =
    { get = .bar
    , set = \value root -> { root | bar = value }
    }


compose : Lens a b -> Lens b c -> Lens a c
compose outer inner =
    { get = outer.get >> inner.get
    , set = \value root ->
        root |> outer.set (root |> outer.get |> inner.set value)
    }


type alias Vector = { x: Float, y: Float }

x : Lens { x : b } b
x =
    { get = .x
    , set = \value root -> { root | x = value }
    }


y : Lens { y : b } b
y =
    { get = .y
    , set = \value root -> { root | y = value }
    }


length : Lens Vector Float
length =
    { get = \v -> sqrt (v.x ^ 2 + v.y ^ 2)
    , set = \value root ->
        let
            currentLength = sqrt (root.x ^ 2 + root.y ^ 2)
            scale = if currentLength == 0 then 0 else value / currentLength
        in
        { root | x = root.x * scale, y = root.y * scale }
    }


v1 = { x = 1, y = 2}

v2 = v1 |> length.set 1.0

size = v1 |> length.get


first : Lens (a, b) a
first =
    { get = Tuple.first
    , set = \value (_, b) -> (value, b)
    }

second : Lens (a, b) b
second =
    { get = Tuple.second
    , set = \value (a, _) -> (a, value)
    }


type alias Foo =
    { bar: (Int, String) }


foo =
    { bar = (42, "Hello") }

foo2 = foo |> (compose bar first).set 100