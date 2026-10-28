module Tree exposing (..)

type Tree a b = Leaf a | Node b (Tree a b) (Tree a b)


depth : Tree a b -> Int
depth tree =
    case tree of
        Leaf _ -> 0
        Node _ left right -> 1 + max (depth left) (depth right)


sort : Tree comparable b -> Tree comparable b
sort tree =
    case tree of
        Leaf _ -> tree
        Node v (Leaf x) (Leaf y) ->
            let
                smaller = min x y
                bigger = max x y
            in Node v (Leaf smaller) (Leaf bigger)
        Node v (Leaf x) (Node w left right) ->
            Debug.todo "..."
        Node v (Node w left right) (Leaf x) ->
            Debug.todo "..."
        Node v (Node a left right) (Node b left1 right2) ->
            Debug.todo "..."
