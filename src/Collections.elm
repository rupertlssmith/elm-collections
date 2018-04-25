module Collections exposing (..)


type alias Equality a =
    { a
        | equals : Equality a -> Equality a -> Bool
        , hashCode : Equality a -> Int
    }


type alias Ordering a =
    { a
        | order : Ordering a -> Ordering a -> Order
    }
