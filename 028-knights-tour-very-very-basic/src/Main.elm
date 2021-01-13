module Main exposing (..)

import Html exposing (Html, div, p, text)


type alias Position =
    { x : Int
    , y : Int
    }


type alias NamedPosition =
    { x : String
    , y : Int
    }


type alias Board =
    List Position


main : Html a
main =
    div []
        [ p [] [ text "(0, 0) has the following valid destinations:" ]
        , p [] [ text (makeMove { x = 0, y = 0 } |> Debug.toString) ]
        , p [] [ text "And these are the destinations' destinations: " ]
        , p [] [ text (nextDestinations { x = 0, y = 0 } |> Debug.toString) ]
        ]


squareView : Int -> Int -> NamedPosition
squareView boardSize index =
    let
        sliceStart =
            modBy boardSize index

        sliceEnd =
            sliceStart + 1
    in
    { x = String.slice sliceStart sliceEnd "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    , y = (index // boardSize) + 1
    }


squareWithCoordinates : Int -> Int -> Position
squareWithCoordinates boardSize index =
    { x = modBy boardSize index
    , y = index // boardSize
    }


createBoard : Int -> List Position
createBoard boardSize =
    List.range 0 ((boardSize ^ 2) - 1)
        |> List.map (squareWithCoordinates boardSize)


chessBoard : List Position
chessBoard =
    createBoard 8


getValidDestinations : List Position -> Position -> List Position
getValidDestinations board current =
    board
        |> List.filter
            (\other ->
                let
                    ( xDistance, yDistance ) =
                        ( abs <| other.x - current.x
                        , abs <| other.y - current.y
                        )
                in
                (xDistance == 2 && yDistance == 1) || (xDistance == 1 && yDistance == 2)
            )


makeMove : Position -> List Position
makeMove position =
    getValidDestinations chessBoard position


nextDestinations : Position -> List (List Position)
nextDestinations position =
    makeMove position |> List.map (getValidDestinations chessBoard)
