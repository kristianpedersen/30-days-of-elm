module Main exposing (Model, Msg(..), init, main, update, view)

import Binary
import Browser
import Html exposing (..)
import LineChart


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init =
    42


type alias Model =
    Int


type Msg
    = UpdatedInt String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdatedInt n ->
            model


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


getNextNumbersFromRange : List Point
getNextNumbersFromRange =
    List.range 0 100
        |> List.map
            (\index ->
                { x = index |> toFloat
                , y =
                    getNextNumberWithSame1Bits index
                        |> binaryToInt
                        |> toFloat
                }
            )


type alias Point =
    { x : Float, y : Float }


chart : Html msg
chart =
    LineChart.view2
        .x
        .y
        -- First line
        getNextNumbersFromRange
        -- Second line
        (List.range
            0
            100
            |> List.foldl
                (\val acc ->
                    if modBy 10 val == 0 then
                        val :: acc

                    else
                        acc
                )
                []
            |> List.map toFloat
            |> List.map
                (\v ->
                    { x = v
                    , y = v
                    }
                )
        )


view : Model -> Html Msg
view model =
    div [] [ chart ]
