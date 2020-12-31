module Main exposing (Model(..), Msg(..), getPlanetsFromAPI, init, main, planetDecoder, subscriptions, update, view, viewGif)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Task exposing (succeed)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success (List Planet)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getPlanetsFromAPI )



-- UPDATE


type Msg
    = MorePlease
    | GotPlanets (Result Http.Error (List Planet))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( Loading, getPlanetsFromAPI )

        GotPlanets result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err scaryErrorMessage ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ viewGif model ]


viewGif : Model -> Html Msg
viewGif model =
    let
        _ =
            Debug.log "hm" model
    in
    case model of
        Failure ->
            div []
                [ text "Something went wrong"
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div []
                [ button [ onClick MorePlease, Html.Attributes.style "display" "block" ] [ text "More Please!" ]
                , text "url goes here"
                ]



-- HTTP


getPlanetsFromAPI : Cmd Msg
getPlanetsFromAPI =
    Http.get
        { url = "/info"
        , expect = Http.expectJson GotPlanets planetsDecoder
        }


type alias Planets =
    List Planet


type alias Planet =
    { planetName : PlanetInfo }


type alias PlanetInfo =
    { lightMinutes : Float
    , xyz : List Float
    }



-- planetInfoDecoder : Decoder PlanetInfo
-- planetInfoDecoder =
-- something something


planetDecoder : Decoder Planet
planetDecoder =
    Decode.succeed Planet
        |> Json.Decode.Pipeline.required "lightMinutes" Decode.float
        |> Json.Decode.Pipeline.required "xyz" (Decode.list Decode.float)


planetsDecoder : Decoder (List Planet)
planetsDecoder =
    Decode.list planetDecoder
