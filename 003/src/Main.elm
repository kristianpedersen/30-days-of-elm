module Main exposing (Model, init, main, update, view)

import Browser
import Html exposing (Html, button, div, input, p, span, text)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import Random
import Random.Extra



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { grid : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { grid = True }, Cmd.none )


type Msg
    = HeyElmGiveRandomBoolPlease
    | NewBoolFromElmRuntime Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeyElmGiveRandomBoolPlease ->
            ( model, Random.generate NewBoolFromElmRuntime Random.Extra.bool )

        NewBoolFromElmRuntime newBoolValue ->
            ( { model | grid = newBoolValue }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick HeyElmGiveRandomBoolPlease ] [ text "Toggle randomly" ]
        , input [ type_ "checkbox", checked model.grid ] []
        ]
