module Main exposing (..)

import Colors.Opaque exposing (beige, lightblue, salmon)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html)


main : Html.Html msg
main =
    fullscreenContainer
        [ centeredDiv 200 40 lightblue
        , centeredDiv 40 200 beige
        , centeredDiv 100 100 salmon
        ]


fullscreenContainer : List (Element msg) -> Html msg
fullscreenContainer stuff =
    layout [] <|
        column [ width fill, height fill, spacing 15 ] stuff


centeredDiv : Int -> Int -> Color -> Element msg
centeredDiv divWidth divHeight backgroundColor =
    row
        [ Background.color backgroundColor
        , Border.width 2
        , centerX
        , centerY
        , width (px divWidth)
        , height (px divHeight)
        ]
        [ el [ centerX, centerY ] (text "Hi!") ]
