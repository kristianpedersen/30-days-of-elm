module Main exposing (grid, letters, main, rowDiv)

import Html exposing (..)


letters : String
letters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


singleCell : Int -> Int -> String
singleCell x y =
    String.slice (x - 1) (x + 0) letters ++ String.fromInt (y + 1)


chessRow : Int -> List Int -> List String
chessRow y row =
    row |> List.map (\x -> singleCell x y)


grid : List (List String)
grid =
    List.range 1 8
        |> List.map (\row -> List.range 1 8)
        |> List.indexedMap chessRow
        |> List.reverse


main : Html a
main =
    div [] (grid |> List.map rowDiv)


rowDiv : List String -> Html a
rowDiv row =
    div [] (row |> List.map (\boardPosition -> text boardPosition))
