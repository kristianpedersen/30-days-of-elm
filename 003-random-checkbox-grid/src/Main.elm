module Main exposing (Model, init, main, update, view)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (checked, style, type_)
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
    { grid : List (List Bool)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { grid = [ [ True ] ] }, getGridValues )



-- Update


type Msg
    = RequestToElmRuntime
    | ResponseFromElmRuntime (List (List Bool))


getGridValues : Cmd Msg
getGridValues =
    Random.generate ResponseFromElmRuntime (Random.list 10 (Random.list 10 Random.Extra.bool))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestToElmRuntime ->
            ( model, getGridValues )

        ResponseFromElmRuntime theNewValues ->
            ( { model | grid = theNewValues }, Cmd.none )



-- Subscriptions (none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


convertBoolsToInputs : List Bool -> List (Html Msg)
convertBoolsToInputs elements =
    List.map (\boolValue -> input [ checked boolValue, type_ "checkbox" ] []) elements


createGrid : Model -> List (Html Msg)
createGrid model =
    List.map (\row -> div [] (convertBoolsToInputs row)) model.grid


view : Model -> Html Msg
view model =
    div [ style "padding" "1rem" ]
        [ button
            [ onClick RequestToElmRuntime
            , style "padding" "1rem"
            , style "margin-bottom" "1rem"
            ]
            [ text "Haha checkboxes go brrr" ]
        , div [] (createGrid model)
        ]
