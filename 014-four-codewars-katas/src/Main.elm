module Main exposing (Model, Msg, init, update, view)

import Array
import Browser
import Html exposing (..)
import List
import Round
import String exposing (toInt)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { myNum : Int
    }


init : Model
init =
    { myNum = 42 }


type Msg
    = Msg1
    | Msg2


update : Msg -> Model -> Model
update msg model =
    case msg of
        Msg1 ->
            model

        Msg2 ->
            model


squareEveryDigit : Int -> Int
squareEveryDigit num =
    -- 123
    -- |> "123"
    -- |> ["1", "2", "3"]
    -- |> [1, 2, 3]
    -- |> [1, 4, 9]
    -- |> ["1", "4", "9"]
    -- |> "149"
    -- |> 149
    num
        |> String.fromInt
        |> String.split ""
        |> List.map String.toInt
        |> List.map (Maybe.withDefault 0)
        |> List.map (\n -> n * n)
        |> List.map String.fromInt
        |> String.join ""
        |> String.toInt
        |> Maybe.withDefault 0


accum : String -> String
accum s =
    s
        |> String.toLower
        |> String.split ""
        |> List.indexedMap
            (\index character ->
                List.repeat (index + 1) character
                    |> List.indexedMap
                        (\index2 character2 ->
                            if index == 0 then
                                String.toUpper character

                            else
                                character
                        )
                    |> String.join ""
            )
        |> String.join "-"


isBalanced : Int -> String
isBalanced n =
    -- Split digits into array
    let
        digits =
            n
                |> String.fromInt
                |> String.split ""
                |> List.map String.toInt
                |> List.map (Maybe.withDefault 0)
                |> Array.fromList

        oneIfEven =
            1 - modBy 2 (Array.length digits)

        digitsLength =
            toFloat (Array.length digits)

        -- Determine where to slice into left and right arrays
        middleIndex1 =
            (digitsLength / 2 |> floor) - oneIfEven

        middleIndex2 =
            (digitsLength / 2 |> ceiling) + oneIfEven

        left =
            Array.slice 0 middleIndex1 digits

        right =
            Array.slice middleIndex2 (Array.length digits) digits

        -- Summing and comparing left and right
        resultForDigitsIs3 =
            if Array.get 0 digits == Array.get 2 digits then
                "balanced"

            else
                "not balanced"

        leftSum =
            Array.toList left |> List.sum

        rightSum =
            Array.toList right |> List.sum

        result =
            if digitsLength <= 2 then
                "balanced"

            else if digitsLength == 3 then
                resultForDigitsIs3

            else if leftSum == rightSum then
                "balanced"

            else
                "not balanced"
    in
    String.fromInt n ++ " is " ++ result


circleOfNumbers : Int -> Int -> Int
circleOfNumbers howManyNumbers numberToCheck =
    let
        distance =
            360 / toFloat howManyNumbers

        angles =
            List.range 0 (howManyNumbers - 1)
                |> List.map
                    (\index ->
                        { index = index
                        , angle = Round.round 5 (toFloat index * distance)
                        }
                    )

        thisAngle =
            angles
                |> List.filter (\angle -> angle.index == numberToCheck)
                |> List.map (\record -> record.angle)
                |> List.head
                |> Maybe.withDefault ""
                |> String.toFloat
                |> Maybe.withDefault 0

        otherAngleFloat =
            thisAngle + 180

        otherAngleOverflowString =
            Round.round 5 <| otherAngleFloat - 360

        otherAngleAsString =
            Round.round 5 <| thisAngle + 180

        otherIndex =
            angles
                |> List.filter
                    (\this ->
                        if otherAngleFloat < 360 then
                            this.angle == otherAngleAsString

                        else
                            this.angle == otherAngleOverflowString
                    )
                |> List.map (\record -> record.index)
                |> List.head
                |> Maybe.withDefault 0
    in
    otherIndex


circleOfNumbers2 : Float -> Float -> Float
circleOfNumbers2 n numberToFind =
    let
        num =
            numberToFind + n / 2

        result =
            if num > n then
                num - n

            else
                num
    in
    result


view : Model -> Html Msg
view model =
    div []
        [ p [] [ squareEveryDigit 12345 |> String.fromInt |> text ]
        , p [] [ accum "Kristian" |> text ]
        , p [] [ isBalanced 959 |> text ]
        , p [] [ isBalanced 432 |> text ]
        , p [] [ isBalanced 56239814 |> text ]

        -- Opposite angles
        , p [] [ circleOfNumbers 10 2 |> String.fromInt |> text ]
        , p [] [ circleOfNumbers 770 711 |> String.fromInt |> text ]
        , p [] [ circleOfNumbers2 10 2 |> String.fromFloat |> text ]
        , p [] [ circleOfNumbers2 194 44 |> String.fromFloat |> text ]
        ]
