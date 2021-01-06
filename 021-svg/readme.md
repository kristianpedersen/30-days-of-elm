This is day 21 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today I had some fun with [elm/svg](https://package.elm-lang.org/packages/elm/svg/latest/), using hardcoded data to draw some fake orbits and planets.

The reason I got into JavaScript in the first place was Daniel Shiffman's visualizations of mathematics, fractals, physics and animations. You're guaranteed to find something cool in his [Coding Challenge playlist](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6ZiZxtDDRCi6uhfTH4FilpH).

In other words, I had a great time drawing circles and lines with code again. :)

- [1. About the project](#1-about-the-project)
- [2. Imports, Model and Msg](#2-imports-model-and-msg)
- [3. The data](#3-the-data)
- [4. Displaying individual planets and orbits](#4-displaying-individual-planets-and-orbits)
- [5. Displaying multiple planets and orbits](#5-displaying-multiple-planets-and-orbits)
- [6. View](#6-view)
- [7. Main function with what's needed to get the browser width and height](#7-main-function-with-whats-needed-to-get-the-browser-width-and-height)
- [8. Conclusion](#8-conclusion)

# 1. About the project

I want to draw something, based on a data source.

Orbits: Transparent circles with black strokes. `radius = index * someNumber`

Planets: Filled circles. Index lets us calculate X and Y coordinates, by doing something like this:

```elm
x = middleOfScreen + (sin angle * (index * radius))
y = middleOfScreen + (cos angle * (index * radius))
```

# 2. Imports, Model and Msg

```elm
module Main exposing (main)

import Browser
import Browser.Dom exposing (Viewport)
import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task


type alias Model =
    { width : Float, height : Float }


initialModel : Model
initialModel =
    { width = 0, height = 0 }


type Msg
    = NoOp
    | ReceivedViewport Viewport
```

`Viewport` and `Task` are used to get the browser's dimensions. [Looking at my code from day 8](https://github.com/kristianpedersen/30-days-of-elm/blob/main/008-data-from-js-and-autoreload/src/Main.elm), I'm wondering if just getting those from JavaScript using `innerWidth` and `innerHeight` would be a cleaner solution. Maybe it has some drawbacks.

Yesterday, I used `Task` to get the browser size, but I also implemented a resize solution. Today, I decided not to bother with that, just to keep it simple.

`NoOp` is just "don't do any commands", while `ReceivedViewport` will be used to update the model.

# 3. The data

```elm
type alias Planet =
    { name : String
    , size : Int
    , color : String
    }


type alias WindowDimensions =
    { width : Float
    , height : Float
    , centerX : Float
    , centerY : Float
    }


hardcodedPlanets : List Planet
hardcodedPlanets =
    [ { name = "Mercury", size = 8, color = "gray" }
    , { name = "Venus", size = 24, color = "yellow" }
    , { name = "Earth", size = 32, color = "blue" }
    , { name = "Mars", size = 16, color = "red" }
    , { name = "Saturn", size = 56, color = "orange" }
    , { name = "Jupiter", size = 64, color = "gold" }
    , { name = "Uranus", size = 48, color = "lightblue" }
    , { name = "Neptune", size = 40, color = "blue" }
    , { name = "Pluto", size = 8, color = "beige" }
    ]
```

I'm appreciating type aliases and the resulting type annotations more and more. 

Seeing actual words instead of just `Float` and `List String` is really nice, and we'll see some examples of this later in the code.

# 4. Displaying individual planets and orbits

```elm
viewOrbit : WindowDimensions -> Float -> Html msg
viewOrbit window index =
    circle
        [ cx (window.centerX |> String.fromFloat)
        , cy (window.centerY |> String.fromFloat)
        , r ((index + 1) * 50 |> String.fromFloat)
        , fill "none"
        , stroke "black"
        ]
        []


viewPlanet : WindowDimensions -> Float -> Planet -> Html msg
viewPlanet window index planet =
    circle
        [ cx ((window.centerX + sin index * ((index + 1) * 50)) |> String.fromFloat)
        , cy ((window.centerY + cos index * ((index + 1) * 50)) |> String.fromFloat)
        , r (planet.size |> String.fromInt)
        , fill planet.color
        , stroke "black"
        ]
        []
```

Looking at this code, the `index` should have been part of the `Planet` instead. Oh well.

Because we're dealing with SVGs, the numbers need to be converted to strings. It's mildly annoying, but I can live with it.

As we can see, the orbits' radiuses will increase by the same number of pixels. It's not accurate, but visualizing the real orbits would have been silly.

The planet positions are calculated this way: centerOfScreen + (angle * radius). 

Using the index for angles is a bit silly, but I like doing silly things sometimes. Later on, my goal is to get accurate angles from my Python backend.

# 5. Displaying multiple planets and orbits

```elm
viewOrbits : WindowDimensions -> List (Svg msg)
viewOrbits window =
    hardcodedPlanets
        |> List.indexedMap (\index planet -> viewOrbit window (toFloat index))


viewPlanets : WindowDimensions -> List (Svg msg)
viewPlanets window =
    hardcodedPlanets
        |> List.indexedMap (\index planet -> viewPlanet window (toFloat index) planet)
```

These are almost identical, but I figured there might be scenarios where you might wish to toggle just one of them.

The `window` is just being passed to the individual `viewOrbit` and `viewPlanet` functions.

`List.indexedMap` gives us access to both the index and element, just like JavaScript does natively: `array.map((e, i) => ...)`.

# 6. View

```elm
view : Model -> Html msg
view model =
    let
        window =
            { width = model.width
            , height = model.height
            , centerX = model.width / 2
            , centerY = model.height / 2
            }
    in
    svg
        [ width (window.width |> String.fromFloat)
        , height (window.height |> String.fromFloat)
        , viewBox
            ("0 0 "
                ++ (window.width |> String.fromFloat)
                ++ " "
                ++ (window.height |> String.fromFloat)
            )
        ]
    <|
        viewOrbits window
            ++ viewPlanets window
```

The `let` statement isn't strictly necessary, but I just think `window.width` sounds a lot better than `model.width`.

There's a lot of `String.fromFloat` going on here. On one hand, I want to write a very short function to make things less verbose, but then everyone else would have to learn about my spcial snowflake function.

The `++` works for converting multiple lists into one, which is pretty cool. I almost created two separate SVG elements here!

# 7. Main function with what's needed to get the browser width and height

```elm
main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err err ->
                    NoOp

                Ok vp ->
                    ReceivedViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
```

If your read the let statement first, this may look confusing. Things look better if we start with `Browser.element`.

Init equals an anonymous function which returns a tuple, consisting of:
1. The inital model
2. A function called `Task.attempt`, which sends a message `handleResult`, depending on the outcome of `Browser.Dom.getViewport`

If you *then* read the let statement, things make a bit more sense. `NoOp` or `ReceivedViewport` get sent to the update function, I believe.

# 8. Conclusion

Drawing stuff with code is still fun.

It was good to have a more relaxing kind of project today. The last days have been challenging.

I went for two walks today, which was a very good idea. 