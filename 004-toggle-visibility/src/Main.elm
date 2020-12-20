module Main exposing (Msg(..), init, main)

import Browser
import Html exposing (Html, div, input, p, text)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onCheck)



-- Main


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- Model


type alias Model =
    { visible : Bool
    }


init : Model
init =
    { visible = False
    }



-- Update


type Msg
    = ToggleVisibility Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleVisibility checkboxValue ->
            { model | visible = checkboxValue }



-- View


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "checkbox", onCheck ToggleVisibility ] []
        , p []
            [ if model.visible then
                text "Hi!"

              else
                text ""
            ]
        ]
