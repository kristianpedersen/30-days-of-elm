module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        lightMinutes =
            75

        currentHour =
            Time.toHour model.zone model.time

        currentMinute =
            Time.toMinute model.zone model.time

        newMinutes =
            (currentHour * 60) + currentMinute - lightMinutes

        h =
            floor (toFloat newMinutes / 60)
                |> String.fromInt
                |> String.padLeft 2 '0'

        m =
            remainderBy 60 newMinutes
                |> String.fromInt
                |> String.padLeft 2 '0'
    in
    h1 [] [ text <| h ++ ":" ++ m ]
