module Buffer exposing (..)

import Array exposing (Array)


type alias Buffer e buffer =
    { add : e -> buffer -> buffer
    , remove : buffer -> Maybe ( e, buffer )
    , element : buffer -> Maybe e
    }


stack : Buffer e (List e)
stack =
    { add = \item list -> item :: list
    , remove =
        \list ->
            case list of
                [] ->
                    Nothing

                x :: xs ->
                    Just ( x, xs )
    , element = List.head
    }


queue : Buffer e (Array e)
queue =
    { add = Array.push
    , remove =
        \array ->
            Array.get 0 array
                |> Maybe.andThen
                    (\result ->
                        Just
                            ( result
                            , Array.slice 1 (Array.length array) array
                            )
                    )
    , element = Array.get 0
    }
