port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- PORTS


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { sliderValue : String
    , noiseValueFromTD : String
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { sliderValue = "50", noiseValueFromTD = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReceivedNoise String
    | NewSliderValue String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedNoise noiseValue ->
            ( { model | noiseValueFromTD = noiseValue }, Cmd.none )

        NewSliderValue v ->
            ( { model | sliderValue = v }, sendMessage model.sliderValue )


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver ReceivedNoise



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| "From TouchDesigner: " ++ model.noiseValueFromTD ]
        , input [ type_ "range", onInput NewSliderValue, Html.Attributes.min "0", Html.Attributes.max "100" ] []
        , p [] [ text <| "Slider value is " ++ model.sliderValue ]
        ]
