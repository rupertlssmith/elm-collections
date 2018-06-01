module ToString exposing (..)


type alias Serializable a self =
    { a
        | toString : self -> String
        , debug : self -> self
    }


dbg : String -> { a | toString : self -> String } -> self -> self
dbg caption toStringable val =
    let
        _ =
            Debug.log caption (toStringable.toString val)
    in
        val


type alias Example =
    Serializable { create : List String -> List String } (List String)


example : Example
example =
    { create = identity
    , toString = \list -> (toString list)
    , debug = \self -> dbg "example" example self
    }
