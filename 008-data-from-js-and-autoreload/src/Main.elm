module Main exposing (..)

import Browser
import Html exposing (Html, div, text)



-- Setup


main : Program Model Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MODEL


type alias Model =
    { isXmas : Bool
    , santaMsg : String
    , rnd42 : List Int
    }


init : Model -> ( Model, Cmd Msg )
init dataFromIndexHTML =
    let
        { isXmas, santaMsg, rnd42 } =
            dataFromIndexHTML
    in
    ( { isXmas = isXmas
      , santaMsg = santaMsg
      , rnd42 = rnd42
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ if model.isXmas then
            text model.santaMsg

          else
            text
                ("Not Christmas yet, but here are some random numbers that are divisible by 42: "
                    ++ (model.rnd42
                            |> List.map String.fromInt
                            |> String.join ", "
                       )
                )
        ]
