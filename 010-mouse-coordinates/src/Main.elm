module Main exposing (main)

import Browser
import Browser.Events exposing (onMouseMove)
import Color exposing (Color, hsl, rgb255, toCssString)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Json.Decode as Decode


type alias Model =
    { message : String, color : Color }


init : flags -> ( Model, Cmd Msg )
init flags =
    ( { message = "Move the mouse pointer on the page"
      , color = rgb255 100 100 100
      }
    , Cmd.none
    )


type alias Msg =
    { x : Int, y : Int }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        { x, y } ->
            ( { model
                | message =
                    "You moved the mouse to page coordinates "
                        ++ String.fromInt x
                        ++ ", "
                        ++ String.fromInt y
                , color = hsl (x |> toFloat |> (\n -> n / 1000)) 0.5 0.5
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div [ style "background-color" (toCssString model.color) ] [ text model.message ]


subscriptions : Model -> Sub Msg
subscriptions model =
    onMouseMove
        (Decode.map2 Msg
            (Decode.field "pageX" Decode.int)
            (Decode.field "pageY" Decode.int)
        )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
