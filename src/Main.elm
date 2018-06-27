module Main exposing (main)

{-| Just to get it to build.

@docs main

-}

import Html exposing (Html)
import Collections
import ToString
import Buffer
import Traits
import Tree


{-| Main
-}
main : Html msg
main =
    let
        example =
            ToString.example

        ex2 =
            example.create [ "a", "b", "c" ]

        ex3 =
            example.debug ex2
    in
        Html.text "main"
