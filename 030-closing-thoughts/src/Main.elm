module Main exposing (..)

import Browser
import Html exposing (button, div, input, p, text)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


init =
    { number = 0
    , userInput = ""
    }


type Msg
    = Increment
    | ReceivedInput String


update msg model =
    case msg of
        Increment ->
            { model | number = model.number + 1 }

        ReceivedInput input ->
            { model | userInput = input }


view model =
    div []
        [ button [ onClick Increment ] [ text (String.fromInt model.number) ]
        , input [ onInput ReceivedInput ] []
        , p [] [ text ("The model is: " ++ (model |> Debug.toString)) ]
        ]
