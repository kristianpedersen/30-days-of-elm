module Main exposing (main)

import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Decimals(..), usLocale)
import Html exposing (div, p, text)


checkIfFactor : Int -> Int -> Bool
checkIfFactor factor base =
    remainderBy base factor == 0


summation : Int -> Int
summation n =
    List.range 1 n |> List.sum


monkeyCount : Int -> List Int
monkeyCount x =
    List.range 1 x


monkeyCount2 : Int -> List Int
monkeyCount2 =
    List.range 1


millisecondsSinceMidnight : Int -> Int -> Int -> Int
millisecondsSinceMidnight h m s =
    (s * 1000)
        + (m * 1000 * 60)
        + (h * 1000 * 60 * 60)


noSpace : String -> String
noSpace s =
    s |> String.split " " |> String.join ""


noSpaces : String -> String
noSpaces s =
    s |> String.replace " " ""


main =
    div []
        [ -- True
          p [] [ text (checkIfFactor 10 2 |> Debug.toString) ]

        -- False
        , p [] [ text (checkIfFactor 9 2 |> Debug.toString) ]

        -- Sum 1 to n
        , p [] [ text (summation 10 |> Debug.toString) ]

        -- My monkey count
        , p [] [ text (monkeyCount 10 |> Debug.toString) ]

        -- Alternative monkey count with partial application
        , p [] [ text (monkeyCount2 10 |> Debug.toString) ]

        -- Milliseconds since midnight
        , p []
            [ text
                (millisecondsSinceMidnight 13 37 42
                    |> Debug.toString
                )
            ]

        -- Formatted milliseconds since midnight, but it adds .00 :/
        , p []
            [ text
                (toFloat (millisecondsSinceMidnight 13 37 42)
                    |> format usLocale
                )
            ]

        -- Formatted milliseconds since midnight, without .00
        , p []
            [ text
                (toFloat (millisecondsSinceMidnight 13 37 42)
                    |> format { usLocale | decimals = Exact 0 }
                )
            ]

        -- No spaces
        , p [] [ text (noSpaces " Hey    Macarena! ") ]
        ]
