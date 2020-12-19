module Main exposing (initialState, main)

import Browser
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (..)


main : Program () Model a
main =
    Browser.sandbox { init = initialState, update = update, view = view }


type alias Model =
    { listOfPeople : List String }


initialState : Model
initialState =
    { listOfPeople = [ "You", "Me", "They" ] }


update : a -> Model -> Model
update msg model =
    model


view : Model -> Html msg
view model =
    div [] (List.map (\person -> div [] [ text person ]) model.listOfPeople)
