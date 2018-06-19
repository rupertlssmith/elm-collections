module Collections exposing (..)


type alias Equality s a =
    { a
        | equals : s -> s -> Bool
        , hashCode : s -> Int
    }


type alias Ordering s a =
    { a
        | order : s -> s -> Order
    }
