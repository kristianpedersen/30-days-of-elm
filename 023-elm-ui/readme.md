This is day 23 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Try + view source: https://ellie-app.com/c2WWjMTM4ZLa1

# About today's project

I made a React project a few months back that I eventually want to remake in Elm: https://kristianpedersen.github.io/knights-tour-react/

Basically, you click a chess board position, and the program finds a valid sequence of moves where the knight visits every position on the board.

I'm happy with the concept and interactions, but the visuals need a lot of work.

Especially the board being positioned all the way to the left looks weird, and somehow in my caffeine-crazed coding bonanza, I managed to get the SVG lines to resize, but a "fix" stopped the board from resizing. :D

Also, the colors and borders make it look like it was made 15 years ago.

# Elm-ui is much nicer to read

I touched upon this in [my previous quick elm-ui encounter](https://dev.to/kristianpedersen/30daysofelm-day-7-centered-div-and-content-hfa), but CSS can be difficult. 

In my case, struggling with CSS is mostly my own fault for not bothering to learn it properly.

Still though, here's a centered div:

```html
<html>
    <head>
    <style>
        .center-screen {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            min-height: 100vh;
        }

    </style>
    </head>
    
    <body>
        <div class="center-screen">
            I'm in the center
        </div>
    </body>
 </html>
```

From https://stackoverflow.com/questions/31217268/center-div-on-the-middle-of-screen

Here's my elm-ui program from day 7:

```elm
module Main exposing (..)

import Colors.Opaque exposing (lime)
import Element exposing (..)
import Element.Background as Background


centeredDiv =
    column
        [ Background.color lime
        , width (px 200)
        , height (px 200)
        , centerX
        , centerY
        ]
        [ el [ centerX, centerY ] (text "I am centered")
        ]


main =
    layout [] centeredDiv
```

There's just a lot less noise in the second example. Now, if this is true in such a small example, imagine how this adds up.

# Today's code

I'm still an `elm-ui` beginner. I had some problems initially that happened because I provided the wrong type annotations. 

Once I removed them, the errors went away too, so today is an automatic type inference day.

## Generic slider function

The code for making a slider in `elm-ui` is kind of long, to be honest.

My project needed two sliders, but I didn't want two huge slider functions, so I made one generalized slider function:

```elm
slider attributes =
    Input.slider
        [ height (px 30)
        , behindContent
            (el
                [ width fill
                , height (px 2)
                , centerY
                , Background.color (rgb255 255 255 255)
                , Border.rounded 2
                ]
                none
            )
        ]
        { onChange = attributes.message
        , label =
            Input.labelAbove []
                (text attributes.text)
        , min = attributes.min
        , max = attributes.max
        , step = Just 1
        , value = attributes.value
        , thumb =
            Input.defaultThumb
        }
```

`attributes` is a record that contains the info I would want in a smaller slider function.

The sliders for the board size and animation speed now look nicer, instead of repeating the whole mess above twice:

```elm
sliderBoardSize model =
    el [ alignLeft ]
        (slider
            { min = 5
            , max = 26
            , value = model.boardSize
            , text = "Board size"
            , message = UpdateBoardSize
            }
        )


sliderAnimationRate model =
    el [ alignRight ]
        (slider
            { min = 5
            , max = 1000
            , value = model.animationSpeed
            , text = "Animation speed"
            , message = UpdateAnimationSpeed
            }
        )
```

## Panel for the controls

The two sliders then get included in a "nav bar", which looks like this:

```elm
controls model =
    row [ width fill, centerX, spacing 30, padding 30, Background.color (rgb255 200 200 100) ]
        [ sliderBoardSize model
        , sliderAnimationRate model
        ]
```

What's there to say? It's a full-width row with two sliders in it. `elm-ui` code is just so nice to look at! <3

## Info text

Then underneath the controls, I wanted some info text to be displayed:

```elm
infoText model =
    row
        [ width fill
        , centerX
        , spacing 30
        , padding 30
        , Background.color (rgb255 50 50 50)
        , Font.color (rgb255 200 200 200)
        ]
        [ el [ centerX ]
            (text
                ("The board size is "
                    ++ (model.boardSize |> Debug.toString)
                    ++ ", and the animation interval is "
                    ++ (model.animationSpeed |> Debug.toString)
                    ++ " ms"
                )
            )
        ]
```

## "Board"

Honestly, I just want to watch some Netflix right now, so I didn't bother doing the board properly with the letters and numbers. I'll do that tomorrow.

For now, it expands and contracts along with the board size slider, which I think is pretty cool. :)

```elm
showRow model =
    row [ width fill, height fill ] <|
        (List.range 1 (floor model.boardSize)
            |> List.map (\_ -> el [ width fill, centerY ] (text "Hi there"))
        )


showBoard model =
    column [ width fill, height fill, Font.center ]
        (List.range 1 (floor model.boardSize)
            |> List.map (\_ -> showRow model)
        )
```

First, we create a row of 8 cells: ********
Then, we create a column with 8 of those:

```
********
********
********
********
********
********
********
********
```

## The main fullscreen container, and the view function

```elm
view model =
    Element.layout []
        (fullscreenContainer model)


fullscreenContainer model =
    column [ width fill, height fill, spacing 0, padding 0 ] <|
        List.map
            (\elmUiSection -> elmUiSection model)
            -- I want to add the "buttons" function to this list, but Elm won't let me because of a type mismatch
            [ controls, infoText, showBoard ]
```

`Element.layout` is the topmost level in this `elm-ui` application. In my case, it just takes a `column` that contains everything.

I'm using map, because each of the `elmUiSection`s, ([controls, infoText, showBoard]) take the model as their argument.

I could have also written this:

```elm
column [ width fill, height fill, spacing 0, padding 0 ] <|
    [ controls model, infoText model, showBoard model ]
```

But that kind of needless repetition just puts me asleep.

The "buttons" function didn't work in this list. Lists can only consist of items of the same type, and the button is a different type because of its `onPress` message.

## Main, model, update, the usual stuff

```elm
module Main exposing (..)

import Browser
import Element exposing (Element, alignLeft, alignRight, behindContent, centerX, centerY, column, el, fill, height, none, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { boardSize : Float
    , animationSpeed : Float
    }


init : Model
init =
    { boardSize = 8, animationSpeed = 50 }


type Msg
    = UpdateBoardSize Float
    | UpdateAnimationSpeed Float
    | BoardSizeFromButton Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateBoardSize v ->
            { model | boardSize = v }

        UpdateAnimationSpeed v ->
            { model | animationSpeed = v }

        BoardSizeFromButton v ->
            { model | boardSize = toFloat v }
```

This is a very standard Elm setup. I'd definitely change the Msg names, as they're not really clear. `SliderBoardSize`, `SliderAnimationSpeed` and `ButtonBoardSize` would be better names for me.

Also, almost at the top, rather than exposing so many individual things from Element, I think I would just expose all.

# Conclusion

This was my 2nd time using `elm-ui`. Type annotations gave me some trouble to begin with, but other than that, I must say that it feels really intuitive.

I'm just going to be honest and say that it would have taken me a lot more effort to make today's project in CSS.

My CSS skills aren't good, so I use `elm-ui`, and my React code gives me runtime errors, so I use `elm`.

I'll definitely look more into elm-ui for future projects - it's really nice.