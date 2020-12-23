-- All improvements by @bukkfrig: https://dev.to/bukkfrig/comment/19fl1


module MainImprovedByBukkfrig exposing (..)

import Browser
import Html exposing (Html, div, form, input, label, li, span, text, ul)
import Html.Attributes exposing (checked, for, name, step, style, type_)
import Html.Events exposing (onInput)
import Html.Lazy
import Palette.Cubehelix as Cubehelix
import SolidColor exposing (SolidColor)
import SolidColor.Accessibility exposing (checkContrast, meetsAA, meetsAAA)



-- Setup


type Msg
    = ChangeColorParameter ColorParameter
    | ChangeAccessibilityRating Rating


type ColorParameter
    = Hue Float
    | Rotations Float
    | Gamma Float


type Rating
    = AA
    | AAA


type alias Model =
    { rating : Rating
    , cubehelixStart : ( Float, Float, Float )
    , cubehelixRotations : Float
    , cubehelixGamma : Float
    }


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- Model


init : Model
init =
    { rating = AA
    , cubehelixStart = ( 80, 100, 0 )
    , cubehelixRotations = 1.2
    , cubehelixGamma = 0.9
    }



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeAccessibilityRating rating ->
            { model | rating = rating }

        ChangeColorParameter (Hue hue) ->
            { model | cubehelixStart = ( hue, 100, 0 ) }

        ChangeColorParameter (Rotations rotations) ->
            { model | cubehelixRotations = rotations }

        ChangeColorParameter (Gamma gamma) ->
            { model | cubehelixGamma = gamma }



-- View


isBlackTextReadable : Model -> SolidColor -> Bool
isBlackTextReadable model backgroundColor =
    checkContrast { fontSize = 12, fontWeight = 700 }
        backgroundColor
        (SolidColor.fromRGB ( 0, 0, 0 ))
        |> (case model.rating of
                AA ->
                    meetsAA

                AAA ->
                    meetsAAA
           )


selectAAorAAA : Model -> Html Msg
selectAAorAAA model =
    form []
        [ label []
            [ input
                [ type_ "radio"
                , name "accessibility-type"
                , onInput (\str -> ChangeAccessibilityRating AA)
                , checked (model.rating == AA)
                ]
                []
            , text "AA"
            ]
        , label []
            [ input
                [ type_ "radio"
                , name "accessibility-type"
                , onInput (\str -> ChangeAccessibilityRating AAA)
                , checked (model.rating == AAA)
                ]
                []
            , text "AAA"
            ]
        ]


adjustColors : Model -> Html Msg
adjustColors model =
    form []
        [ label [ for "hue" ]
            [ text "Hue"
            , input
                [ type_ "range"
                , onInput (\val -> ChangeColorParameter (Hue (Maybe.withDefault 0 (String.toFloat val))))
                , Html.Attributes.min "0"
                , Html.Attributes.max "360"
                , Html.Attributes.value <|
                    case model.cubehelixStart of
                        ( hue, _, _ ) ->
                            String.fromFloat hue
                , step "5"
                ]
                []
            ]
        , label [ for "rotations" ]
            [ text "Rotations"
            , input
                [ type_ "range"
                , onInput (\val -> ChangeColorParameter (Rotations (Maybe.withDefault 0 (String.toFloat val))))
                , Html.Attributes.min "0"
                , Html.Attributes.max "2"
                , Html.Attributes.value (String.fromFloat model.cubehelixRotations)
                , step "0.1"
                ]
                []
            ]
        , label [ for "gamma" ]
            [ text "Gamma"
            , input
                [ type_ "range"
                , onInput (\val -> ChangeColorParameter (Gamma (Maybe.withDefault 0 (String.toFloat val))))
                , Html.Attributes.min "0"
                , Html.Attributes.max "2"
                , Html.Attributes.value (String.fromFloat model.cubehelixGamma)
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
                text ("HSL: " ++ String.join ", " (List.map String.fromFloat [ h, s, l ]))

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
        <|
            Cubehelix.generateAdvanced 100
                { start = SolidColor.fromHSL model.cubehelixStart
                , rotationDirection = Cubehelix.BGR
                , rotations = model.cubehelixRotations
                , gamma = model.cubehelixGamma
                }


view : Model -> Html Msg
view model =
    div [ style "font-family" "sans-serif" ]
        [ selectAAorAAA model
        , adjustColors model
        , showCubehelixInfo model
        , Html.Lazy.lazy colorRectangles model
        ]
