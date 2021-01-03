module Main exposing (Model(..), Msg(..), Planet, fetchPlanets, init, main, planetDecoder, subscriptions, update, view, viewPlanet, viewPlanets)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, float, list, map3, string)



-- MAIN AND SUBSCRIPTIONS


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


type Model
    = Failure String
    | FirstClick
    | Loading
    | Success (List Planet)


init : () -> ( Model, Cmd Msg )
init _ =
    ( FirstClick, Cmd.none )



-- REQUESTS AND DECODER


fetchPlanets : Cmd Msg
fetchPlanets =
    Http.get
        { url = "info"
        , expect = Http.expectJson PlanetRequest (Json.Decode.list planetDecoder)
        }


type alias Planet =
    { name : String
    , lightMinutes : Float
    , xyz : List Float
    }


planetDecoder : Decoder Planet
planetDecoder =
    map3 Planet
        (field "name" string)
        (field "lightMinutes" float)
        (field "xyz" (Json.Decode.list float))



-- UPDATE


type Msg
    = GetPlanets
    | PlanetRequest (Result Http.Error (List Planet))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetPlanets ->
            ( Loading, fetchPlanets )

        PlanetRequest result ->
            case result of
                Ok planetData ->
                    ( Success planetData, Cmd.none )

                Err errorMessage ->
                    ( Failure (errorMessage |> Debug.toString), Cmd.none )



-- VIEW


viewPlanet : Planet -> Html Msg
viewPlanet planet =
    div []
        [ h1 [] [ text planet.name ]
        , p [] [ text ((planet.lightMinutes |> String.fromFloat) ++ " light minutes away") ]
        ]


viewPlanets : Model -> Html Msg
viewPlanets model =
    case model of
        FirstClick ->
            button [ onClick GetPlanets ] [ text "Get planets" ]

        Loading ->
            text "beep boop lol"

        Success planetData ->
            div []
                [ button [ onClick GetPlanets, style "display" "block" ] [ text "Refresh" ]
                , div [] <| List.map viewPlanet planetData
                ]

        Failure errorMessage ->
            div []
                [ button [ onClick GetPlanets ] [ text "Try Again!" ]
                , p [] [ text ("Error message: " ++ errorMessage) ]
                ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "It's planet time" ]
        , viewPlanets model
        ]
