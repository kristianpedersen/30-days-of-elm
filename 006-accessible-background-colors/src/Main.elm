module Main exposing (..)

import Browser
import Html exposing (Html, div, form, input, label, li, span, text, ul)
import Html.Attributes exposing (for, name, step, style, type_)
import Html.Events exposing (onInput)
import Html.Events.Extra exposing (onChange)
import Maybe exposing (withDefault)
import Palette.Cubehelix as Cubehelix
import SolidColor exposing (SolidColor)
import SolidColor.Accessibility exposing (checkContrast, meetsAA, meetsAAA)



-- Setup


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = GenerateNewColors String String
    | ChangeAccessibilityRating String String



-- Model


type alias Model =
    { palette : List SolidColor
    , rating : SolidColor.Accessibility.Rating
    , cubehelixStart : ( Int, Int, Int )
    , cubehelixRotations : Float
    , cubehelixGamma : Float
    }


initialColors : List SolidColor
initialColors =
    Cubehelix.generateAdvanced 100
        { start = SolidColor.fromHSL ( 80, 100, 0 )
        , rotationDirection = Cubehelix.BGR
        , rotations = 1.2
        , gamma = 0.9
        }


init : Model
init =
    { palette = initialColors
    , rating = SolidColor.Accessibility.AA
    , cubehelixStart = ( 80, 100, 0 )
    , cubehelixRotations = 1.2
    , cubehelixGamma = 0.9
    }



-- View


isBlackTextReadable : Model -> SolidColor -> Bool
isBlackTextReadable model backgroundColor =
    checkContrast { fontSize = 12, fontWeight = 700 }
        backgroundColor
        (SolidColor.fromRGB ( 0, 0, 0 ))
        |> (case model.rating of
                SolidColor.Accessibility.AA ->
                    meetsAA

                SolidColor.Accessibility.AAA ->
                    meetsAAA

                _ ->
                    meetsAAA
           )


selectAAorAAA : Html Msg
selectAAorAAA =
    form []
        [ label []
            [ input
                [ type_ "radio"
                , name "accessibility-type"
                , onChange (ChangeAccessibilityRating "AA")
                ]
                []
            , text "AA"
            ]
        , label []
            [ input
                [ type_ "radio"
                , name "accessibility-type"
                , onChange (ChangeAccessibilityRating "AAA")
                ]
                []
            , text "AAA"
            ]
        ]


adjustColors : Html Msg
adjustColors =
    form []
        [ label [ for "hue" ]
            [ text "Hue"
            , input
                [ type_ "range"
                , onInput (GenerateNewColors "hue")
                , Html.Attributes.min "0"
                , Html.Attributes.max "360"
                , Html.Attributes.value "0"
                , step "5"
                ]
                []
            ]
        , label [ for "rotations" ]
            [ text "Rotations"
            , input
                [ type_ "range"
                , onInput (GenerateNewColors "rotations")
                , Html.Attributes.min "0"
                , Html.Attributes.max "2"
                , Html.Attributes.value "1.2"
                , step "0.1"
                ]
                []
            ]
        , label [ for "gamma" ]
            [ text "Gamma"
            , input
                [ type_ "range"
                , onInput (GenerateNewColors "gamma")
                , Html.Attributes.min "0"
                , Html.Attributes.max "2"
                , Html.Attributes.value "0.8"
                , step "0.1"
                ]
                []
            ]
        ]


showCubehelixInfo : Model -> Html Msg
showCubehelixInfo model =
    div []
        [ let
            ( h, s, l ) =
                model.cubehelixStart

            rotations =
                model.cubehelixRotations

            gamma =
                model.cubehelixGamma

            hslText =
                text
                    ("HSL: "
                        ++ ([ h, s, l ]
                                |> List.map String.fromInt
                                -- Convert each item to a String
                                |> String.join ", "
                            -- Put them into one string with commas between
                           )
                    )

            rotationsText =
                text ("Rotations: " ++ String.fromFloat rotations)

            gammaText =
                text ("Gamma: " ++ String.fromFloat gamma)
          in
          ul []
            [ li [] [ hslText ]
            , li [] [ rotationsText ]
            , li [] [ gammaText ]
            ]
        ]


colorRectangles : Model -> Html Msg
colorRectangles model =
    div [] <|
        List.map
            (\color ->
                span
                    [ style "background-color" (SolidColor.toHSLString color)
                    , style "display" "inline-block"
                    , style "padding" "1rem"
                    , style "width" "calc(10vw - 1rem)"
                    , style "color"
                        (if isBlackTextReadable model color then
                            "black"

                         else
                            "white"
                        )
                    ]
                    [ text (SolidColor.toHex color)
                    ]
            )
            model.palette


view : Model -> Html Msg
view model =
    div [ style "font-family" "sans-serif" ]
        [ selectAAorAAA
        , adjustColors
        , showCubehelixInfo model
        , colorRectangles model
        ]



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeAccessibilityRating rating _ ->
            case rating of
                "AA" ->
                    { model | rating = SolidColor.Accessibility.AA }

                "AAA" ->
                    { model | rating = SolidColor.Accessibility.AAA }

                _ ->
                    model

        GenerateNewColors parameter value ->
            let
                hue =
                    withDefault 0 (String.toFloat value)

                rotations =
                    model.cubehelixRotations

                gamma =
                    model.cubehelixGamma

                updatedPalette =
                    Cubehelix.generateAdvanced 100
                        { start = SolidColor.fromHSL ( 80, 100, 0 )
                        , rotationDirection = Cubehelix.BGR
                        , rotations = rotations
                        , gamma = gamma
                        }
            in
            case parameter of
                "hue" ->
                    { model
                        | cubehelixStart = ( floor hue, 100, 0 )
                        , palette =
                            Cubehelix.generateAdvanced 100
                                { start = SolidColor.fromHSL ( hue, 100, 0 )
                                , rotationDirection = Cubehelix.BGR
                                , rotations = rotations
                                , gamma = gamma
                                }
                    }

                "rotations" ->
                    { model
                        | cubehelixRotations = withDefault 0 (String.toFloat value)
                        , palette = updatedPalette
                    }

                "gamma" ->
                    { model
                        | cubehelixGamma = withDefault 0 (String.toFloat value)
                        , palette = updatedPalette
                    }

                _ ->
                    model
