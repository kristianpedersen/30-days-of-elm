module Main exposing (Model, init, main, update, view)

import Browser
import Html exposing (Html, button, div, h1, input, p, span, text)
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
    { grid : List (List Bool)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { grid = [ [ True ] ] }, getGridValues )


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick RequestToElmRuntime ] [ text "Toggle randomly" ]
        , div [] (List.map (\row -> div [] (List.map (\col -> span [] [ input [ checked col, type_ "checkbox" ] [] ]) row)) model.grid)
        , h1 [] [ text "Second attempt:" ]
        ]
