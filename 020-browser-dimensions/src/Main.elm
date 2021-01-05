module Main exposing (main)

import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Task



-- Model and Msg


type alias Model =
    { width : Float, height : Float }


initialModel : Model
initialModel =
    { width = 0, height = 0 }


type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )



-- Main and subscription


main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err err ->
                    NoOp

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize ( toFloat w, toFloat h ))



-- Update


setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ text
            ("The width is "
                ++ (model.width |> String.fromFloat)
                ++ "px, and the height is "
                ++ (model.height |> String.fromFloat)
                ++ "px"
            )
        ]
