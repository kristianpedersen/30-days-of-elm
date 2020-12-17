module Main exposing (main)

import Browser
import Html exposing (Html, div, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
    Browser.sandbox { init = initialState, update = update, view = view }


type alias Model =
    { value : String
    , message : String
    }


initialState : Model
initialState =
    { value = "0"
    , message = "Hi!"
    }


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | value = newContent }


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "range", onInput Change ] []
        , p [] [ text model.value ]
        , p [] [ text model.message ]
        ]
