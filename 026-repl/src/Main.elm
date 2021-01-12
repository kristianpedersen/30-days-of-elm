module Main exposing (..)

import Html exposing (Html, text)


test : String
test =
    "Hi from test function!"


xyFromIndex : Int -> ( Int, Int )
xyFromIndex i =
    let
        num =
            toFloat i

        x =
            modBy 8 (floor num)

        y =
            floor (num / 8)
    in
    ( x, y )


rangeEcho =
    List.range 1 5
        |> List.map
            (\n ->
                let
                    _ =
                        Debug.log "The number is: " n
                in
                n
            )


grid : List ( Int, Int )
grid =
    List.range 0 63 |> List.map xyFromIndex


main : Html a
main =
    text (rangeEcho |> Debug.toString)
