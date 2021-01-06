module Main exposing (main)

import Browser
import Browser.Dom exposing (Viewport)
import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task


type alias Model =
    { width : Float, height : Float }


initialModel : Model
initialModel =
    { width = 0, height = 0 }


type Msg
    = NoOp
    | ReceivedViewport Viewport


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedViewport vp ->
            ( { model | width = vp.scene.width, height = vp.scene.height }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


type alias Planet =
    { name : String
    , size : Int
    , color : String
    }


type alias WindowDimensions =
    { width : Float
    , height : Float
    , centerX : Float
    , centerY : Float
    }


hardcodedPlanets : List Planet
hardcodedPlanets =
    [ { name = "Mercury", size = 8, color = "gray" }
    , { name = "Venus", size = 24, color = "yellow" }
    , { name = "Earth", size = 32, color = "blue" }
    , { name = "Mars", size = 16, color = "red" }
    , { name = "Saturn", size = 56, color = "orange" }
    , { name = "Jupiter", size = 64, color = "gold" }
    , { name = "Uranus", size = 48, color = "lightblue" }
    , { name = "Neptune", size = 40, color = "blue" }
    , { name = "Pluto", size = 8, color = "beige" }
    ]


viewOrbit : WindowDimensions -> Float -> Html msg
viewOrbit window index =
    circle
        [ cx (window.centerX |> String.fromFloat)
        , cy (window.centerY |> String.fromFloat)
        , r ((index + 1) * 50 |> String.fromFloat)
        , fill "none"
        , stroke "black"
        ]
        []


viewPlanet : WindowDimensions -> Float -> Planet -> Html msg
viewPlanet window index planet =
    circle
        [ cx ((window.centerX + sin index * ((index + 1) * 50)) |> String.fromFloat)
        , cy ((window.centerY + cos index * ((index + 1) * 50)) |> String.fromFloat)
        , r (planet.size |> String.fromInt)
        , fill planet.color
        , stroke "black"
        ]
        []


viewOrbits : WindowDimensions -> List (Svg msg)
viewOrbits window =
    hardcodedPlanets
        |> List.indexedMap (\index planet -> viewOrbit window (toFloat index))


viewPlanets : WindowDimensions -> List (Svg msg)
viewPlanets window =
    hardcodedPlanets
        |> List.indexedMap (\index planet -> viewPlanet window (toFloat index) planet)


view : Model -> Html msg
view model =
    let
        window =
            { width = model.width
            , height = model.height
            , centerX = model.width / 2
            , centerY = model.height / 2
            }
    in
    svg
        [ width (window.width |> String.fromFloat)
        , height (window.height |> String.fromFloat)
        , viewBox
            ("0 0 "
                ++ (window.width |> String.fromFloat)
                ++ " "
                ++ (window.height |> String.fromFloat)
            )
        ]
    <|
        viewOrbits window
            ++ viewPlanets window


main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err err ->
                    NoOp

                Ok vp ->
                    ReceivedViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
