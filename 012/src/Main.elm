module Main exposing (Model, Msg, init, update, view)

import Binary
import Browser
import Html exposing (..)
import Html.Attributes exposing (autofocus, type_, value)
import Html.Events exposing (onInput)
import String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { currentInt : Int
    }


init : Model
init =
    { currentInt = 43
    }


type Msg
    = NewNumberEntered String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewNumberEntered n ->
            { model | currentInt = Maybe.withDefault 0 (String.toInt n) }


intToBinary : Int -> String
intToBinary integer =
    integer
        |> Binary.fromDecimal
        |> Binary.toIntegers
        |> List.map String.fromInt
        |> String.join ""


binaryToInt : String -> Int
binaryToInt binaryNumber =
    binaryNumber
        |> String.toList
        |> List.map String.fromChar
        |> List.map (\s -> Maybe.withDefault 0 (String.toInt s))
        |> Binary.fromIntegers
        |> Binary.toDecimal


numberOfBitsIn : Int -> Int
numberOfBitsIn n =
    ceiling (logBase 2 (toFloat n))


generateBits : Int -> List String
generateBits n =
    let
        min =
            n + 1

        max =
            2 ^ (1 + numberOfBitsIn n)
    in
    List.range min max
        |> List.map intToBinary


count1s : String -> Int
count1s binaryNumber =
    binaryNumber
        |> String.toList
        |> List.map String.fromChar
        |> List.filter (\n -> n == "1")
        |> List.length


getNextNumberWithSame1Bits : Int -> String
getNextNumberWithSame1Bits number =
    generateBits number
        |> List.foldl
            (\currentBinaryNumber acc ->
                if count1s currentBinaryNumber == count1s (intToBinary number) then
                    List.append acc [ currentBinaryNumber ]

                else
                    acc
            )
            []
        |> List.head
        |> Maybe.withDefault ""


view : Model -> Html Msg
view model =
    div []
        [ input
            [ type_ "number"
            , autofocus True
            , onInput NewNumberEntered
            , value <| String.fromInt model.currentInt
            ]
            []

        -- Int to binary
        , h1 [] [ text "Int to binary" ]
        , text <| String.fromInt model.currentInt ++ ": " ++ intToBinary model.currentInt
        , p [] [ text <| String.fromInt <| numberOfBitsIn model.currentInt ]

        -- Same bits or 1 more
        , div []
            [ h1 [] [ text "Same bits or 1 more:" ]
            , text <|
                (generateBits model.currentInt
                    |> String.join ", "
                )
            ]

        -- Next test
        , h1 [] [ text "Next number is: " ]
        , text <|
            let
                nextBinary =
                    getNextNumberWithSame1Bits model.currentInt

                nextInt =
                    nextBinary
                        |> binaryToInt
                        |> String.fromInt
            in
            nextInt
                ++ " ("
                ++ nextBinary
                ++ ")"
        ]
