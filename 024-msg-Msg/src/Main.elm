module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { boardSize : Float
    , animationSpeed : Float
    }


type alias SliderAttributes =
    { message : Float -> Msg
    , min : Float
    , max : Float
    , text : String
    , value : Float
    , step : Maybe Float
    }


init =
    { boardSize = 8, animationSpeed = 50 }


type Msg
    = NewBoardSize Float
    | NewAnimationSpeed Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewBoardSize bs ->
            { model | boardSize = bs }

        NewAnimationSpeed ms ->
            { model | animationSpeed = ms }


createSlider : Model -> SliderAttributes -> Element Msg
createSlider model attributes =
    column [] <|
        [ Input.slider
            [ height (px 30)
            , width (px 200)

            -- Here is where we're creating/styling the "track"
            , behindContent
                (el
                    [ width fill
                    , height (px 2)
                    , centerY
                    , Background.color (rgb255 0 100 200)
                    , Border.rounded 2
                    ]
                    none
                )
            ]
            { onChange = attributes.message
            , label =
                Input.labelAbove [ centerX ]
                    (text (attributes.value |> Debug.toString))
            , min = attributes.min
            , max = attributes.max
            , step = attributes.step
            , value = attributes.value
            , thumb =
                Input.defaultThumb
            }
        ]


view model =
    Element.layout [] (sliders model)


sliders : Model -> Element Msg
sliders model =
    row
        [ width fill, padding 30, spacing 30, Background.color (rgb255 255 100 200) ]
        [ createSlider model
            { message = NewBoardSize
            , min = 5
            , max = 26
            , text = "Set board size"
            , value = model.boardSize
            , step = Just 1
            }
        , createSlider model
            { message = NewAnimationSpeed
            , min = 5
            , max = 1500
            , text = "Set animation speed"
            , value = model.animationSpeed
            , step = Just 10
            }
        ]
