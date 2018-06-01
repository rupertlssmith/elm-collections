module ToString exposing (..)


type alias SomeRecord a self =
    { a
        | toString : self -> String
    }


debug : String -> { a | toString : self -> String } -> { a | toString : self -> String }
debug caption record =
    let
        _ =
            Debug.log caption (record.toString record)
    in
        record
