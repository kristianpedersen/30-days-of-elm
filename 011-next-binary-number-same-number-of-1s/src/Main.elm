module Main exposing (main, squareEveryDigit)

import Browser
import Browser.Dom exposing (focus)
import Html exposing (..)
import Html.Attributes exposing (autofocus, placeholder, style, type_)
import Html.Events exposing (onInput)


type Msg
    = UpdateInt String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { currentInt : Int
    , currentBinary : String
    }


init : Model
init =
    { currentInt = 42, currentBinary = "101010" }


update msg model =
    case msg of
        UpdateInt newNumber ->
            let
                n =
                    Maybe.withDefault 0 (String.toInt newNumber)
            in
            { currentInt = n
            , currentBinary = (generateBinaryNumber n).binaryNumber
            }


squareEveryDigit : Int -> Int
squareEveryDigit num =
    num
        -- 1234 -> "1234"
        |> String.fromInt
        -- "1234" -> ["1", "2", "3", "4"]
        |> String.split ""
        -- ["1", "2", "3", "4"] -> [1, 2, 3, 4]
        |> List.map (\s -> Maybe.withDefault 0 (String.toInt s))
        -- [1, 2, 3, 4] -> [1, 4, 9, 16]
        |> List.map (\n -> n * n)
        -- ["1", "4", "9", "16"]
        |> List.map String.fromInt
        -- "14916"
        |> String.join ""
        -- 14916
        |> String.toInt
        -- toInt returns a Maybe Int. In case the conversion doesn't work, we set 0 as the default.
        |> Maybe.withDefault 0


upperIfIndex0 : Int -> String -> String
upperIfIndex0 index character =
    if index == 0 then
        String.toUpper character

    else
        character


repeatIndexPlus1Times : Int -> Char -> String
repeatIndexPlus1Times index character =
    List.repeat (index + 1) (String.fromChar character)
        |> List.indexedMap upperIfIndex0
        |> String.join ""


accum : String -> String
accum s =
    s
        |> String.toLower
        |> String.toList
        |> List.indexedMap repeatIndexPlus1Times
        |> String.join "-"


countBits : Float -> Int -> Int
countBits number count =
    if number >= 1 then
        countBits (number / 2) (count + 1)

    else
        count


generateBits : Int -> List Int
generateBits numberOfBits =
    List.range 0 (numberOfBits - 1)
        |> List.map (\n -> 2 ^ n)
        |> List.reverse


type alias BinaryNumber =
    { tempNumber : Int, binaryNumber : String }


generateBinaryNumber : Int -> BinaryNumber
generateBinaryNumber number =
    List.foldl
        (\currentBit accumulator ->
            if accumulator.tempNumber >= currentBit then
                { tempNumber = accumulator.tempNumber - currentBit
                , binaryNumber = accumulator.binaryNumber ++ "1"
                }

            else
                { accumulator | binaryNumber = accumulator.binaryNumber ++ "0" }
        )
        { tempNumber = number, binaryNumber = "" }
        (generateBits (countBits (toFloat number) 0))


getWithNBitsOrNPlusOne : Int -> List String
getWithNBitsOrNPlusOne number =
    let
        min =
            -1 + countBits (toFloat number) 0

        max =
            min + 2
    in
    List.range (2 ^ min) ((2 ^ max) - 1)
        |> List.map generateBinaryNumber
        |> List.map (\bn -> bn.binaryNumber)


getNumberOf1s : String -> Int
getNumberOf1s binaryNumber =
    binaryNumber
        |> String.toList
        |> List.map (\char -> String.fromChar char)
        |> List.filter (\c -> c == "1")
        |> List.length


binaryToInt : String -> Int
binaryToInt binaryNumber =
    let
        bits =
            generateBits <| String.length binaryNumber

        digits =
            String.toList binaryNumber
                |> List.map String.fromChar
                |> List.map String.toInt
                |> List.map (Maybe.withDefault 0)
    in
    List.map2 (*) bits digits |> List.sum


getAllMatchingBinaryNumbers : Int -> List String
getAllMatchingBinaryNumbers n =
    getWithNBitsOrNPlusOne n
        |> List.filter
            (\num ->
                getNumberOf1s num == getNumberOf1s (generateBinaryNumber n).binaryNumber
            )


getFirstMatchingBinaryNumber : Int -> String
getFirstMatchingBinaryNumber n =
    getWithNBitsOrNPlusOne n
        |> List.filter
            (\num ->
                (getNumberOf1s num == getNumberOf1s (generateBinaryNumber n).binaryNumber)
                    && (binaryToInt num > n)
            )
        |> List.head
        |> Maybe.withDefault ""


view model =
    div [ style "font-family" "sans-serif", style "padding" "1rem" ]
        -- Enter number here
        [ input
            [ type_ "number"
            , placeholder "123"
            , onInput UpdateInt
            , autofocus True
            ]
            []

        -- Square every digit
        -- , h1 [] [ text "Square every digit" ]
        -- , text (squareEveryDigit model.currentInt |> String.fromInt)
        -- Repeat letters n times
        -- , h1 [] [ text "Repeat each letter (index+1) times (unrelated function)" ]
        -- , text <| accum "Spongebob"
        -- Generate binary number
        , h1 [] [ text "Int to binary" ]
        , text <| (model.currentInt |> String.fromInt) ++ ": " ++ (generateBinaryNumber model.currentInt).binaryNumber

        -- Find closest higher number with same number of bits
        , h1 [] [ text "The next number with the same number of 1 bits is: " ]
        , text <|
            getFirstMatchingBinaryNumber model.currentInt
                ++ " ("
                ++ (getFirstMatchingBinaryNumber model.currentInt
                        |> binaryToInt
                        |> String.fromInt
                   )
                ++ ")"

        -- Find closest higher number with same number of bits
        , h1 [] [ text "Number of bits is the same or 1 more" ]
        , text
            (getWithNBitsOrNPlusOne model.currentInt
                |> String.join ", "
            )

        -- Find closest higher number with same number of bits
        , h1 [] [ text ("All numbers with the same number of 1's as " ++ (generateBinaryNumber model.currentInt).binaryNumber) ]
        , text (getAllMatchingBinaryNumbers model.currentInt |> String.join ", ")
        ]
