module Main exposing (..)

import Browser
import Element exposing (Element, alignLeft, alignRight, behindContent, centerX, centerY, column, el, fill, height, none, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { boardSize : Float
    , animationSpeed : Float
    }


init : Model
init =
    { boardSize = 8, animationSpeed = 50 }


type Msg
    = UpdateBoardSize Float
    | UpdateAnimationSpeed Float
    | BoardSizeFromButton Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateBoardSize v ->
            { model | boardSize = v }

        UpdateAnimationSpeed v ->
            { model | animationSpeed = v }

        BoardSizeFromButton v ->
            { model | boardSize = toFloat v }


view model =
    Element.layout []
        (fullscreenContainer model)


fullscreenContainer model =
    column [ width fill, height fill, spacing 0, padding 0 ] <|
        List.map
            (\elmUiSection -> elmUiSection model)
            -- I want to add the "buttons" function to this list, but Elm won't let me because of a type mismatch
            [ controls, infoText, showBoard ]


sliderBoardSize model =
    el [ alignLeft ]
        (slider
            { min = 5
            , max = 26
            , value = model.boardSize
            , text = "Board size"
            , message = UpdateBoardSize
            }
        )


sliderAnimationRate model =
    el [ alignRight ]
        (slider
            { min = 5
            , max = 1000
            , value = model.animationSpeed
            , text = "Animation speed"
            , message = UpdateAnimationSpeed
            }
        )


slider attributes =
    Input.slider
        [ height (px 30)
        , behindContent
            (el
                [ width fill
                , height (px 2)
                , centerY
                , Background.color (rgb255 255 255 255)
                , Border.rounded 2
                ]
                none
            )
        ]
        { onChange = attributes.message
        , label =
            Input.labelAbove []
                (text attributes.text)
        , min = attributes.min
        , max = attributes.max
        , step = Just 1
        , value = attributes.value
        , thumb =
            Input.defaultThumb
        }


controls model =
    row [ width fill, centerX, spacing 30, padding 30, Background.color (rgb255 200 200 100) ]
        [ sliderBoardSize model
        , sliderAnimationRate model
        ]


buttons model =
    row []
        [ el [] (Input.button [] { label = text "hei", onPress = Just BoardSizeFromButton })
        ]


infoText model =
    row
        [ width fill
        , centerX
        , spacing 30
        , padding 30
        , Background.color (rgb255 50 50 50)
        , Font.color (rgb255 200 200 200)
        ]
        [ el [ centerX ]
            (text
                ("The board size is "
                    ++ (model.boardSize |> Debug.toString)
                    ++ ", and the animation interval is "
                    ++ (model.animationSpeed |> Debug.toString)
                    ++ " ms"
                )
            )
        ]


showBoard model =
    column [ width fill, height fill, Font.center ]
        (List.range 1 (floor model.boardSize)
            |> List.map (\_ -> showRow model)
        )


showRow model =
    row [ width fill, height fill ] <|
        (List.range 1 (floor model.boardSize)
            |> List.map (\_ -> el [ width fill, centerY ] (text "Hi there"))
        )
