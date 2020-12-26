Today's useful little piece of knowledge was how to get information from browser events.

I wanted to get the X and Y position of the mouse pointer, so I found this Stack Overflow answer by O.O.Balance: https://stackoverflow.com/questions/57645824/how-can-i-listen-for-global-mouse-events-in-elm-0-19

In this case, were getting `pageX` and `pageY`. To see a full list, you can open your browser's dev tools and paste this:

```javascript
document.addEventListener("mousemove", event => console.log(event))
```

```elm
module Main exposing (main)

import Browser
import Browser.Events exposing (onMouseMove)
import Html exposing (Html, text)
import Json.Decode as Decode


type alias Model =
    { message : String }


init : flags -> ( Model, Cmd Msg )
init flags =
    ( { message = "Move the mouse pointer on the page" }, Cmd.none )


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
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    text model.message


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
```

Here's the new program, in which the cursor's X position affects the hue:

```elm
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
```

See you tomorrow!