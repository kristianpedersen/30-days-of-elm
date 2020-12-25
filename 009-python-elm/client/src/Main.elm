module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (Html, button, div, pre, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http



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
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Cmd.none
    )



-- UPDATE


type Msg
    = GotText (Result Http.Error String)
    | ButtonClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

        ButtonClicked ->
            ( Loading
            , Http.get
                { url = "https://elmspacekp.herokuapp.com/info" -- or "http://localhost:5000/info"
                , expect = Http.expectString GotText
                }
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            text "oi"

        Loading ->
            button [ onClick ButtonClicked, style "padding" "1rem" ] [ text "Load data from Python backend" ]

        Success fullText ->
            pre [] [ text fullText ]
