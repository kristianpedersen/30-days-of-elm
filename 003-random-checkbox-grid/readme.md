This is day 3 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today I'm making a 10x10 grid of checkboxes, which will be randomly checked when I click a button.

Code: https://github.com/kristianpedersen/30-days-of-elm/blob/main/003-random-checkbox-grid/src/Main.elm

Demo: https://kristianpedersen.github.io/30-days-of-elm/003-random-checkbox-grid/

I started out by prototyping it in React. Turns out it's really fun to watch random checkboxes!

```jsx
import { useState } from "react"
import './App.css'

export default function App() {
  const randomArray = n => [...Array(n)].map(() => Math.random() < 0.5)
  const createGrid = n => randomArray(n).map(() => randomArray(n))

  const [grid, setGrid] = useState(createGrid(10))

  return (
    <>
      <button onClick={() => setGrid(createGrid(10))}>Randomize</button>
        {grid.map(row => (
          <div>{row.map(randomBool => <input type="checkbox" checked={randomBool} />)}</div>
        ))}
    </>
  )
}
```

# Summary

1. Working with random values in Elm is very different from anything else I've tried. Expect to be confused.
2. That feeling when the compiler doesn't show any errors is great! I can't say the same for React.
3. Tomorrow's project will be simpler than this one. Phew! :)

[Skip to full Elm code example](#7-closing-thoughts-and-code)

# Code walkthrough

## 0. Acknowledgments / Help from Slack

First, I want to thank Slack users Arkham and joelq for their help!

I almost had the basic view ready, but my `randomList` function returned `List (Random.Generator Bool)`, instead of `List Bool`:

```elm
randomList n =
    List.map (\num -> Random.Extra.bool) (List.range 0 n)


view : Model -> Html Msg
view model =
    div [] (List.map (\rndBool -> input [ checked rndBool ] []) (randomList 10))
```

Arkham had this to say:

> Generating random values is impure, and therefore requires to send a Cmd to the elm runtime.

https://guide.elm-lang.org/effects/random.html

joelq provided a working example to go by, which was really useful: https://ellie-app.com/bQBLvPD7vJMa1

## 1. Imports

```elm
module Main exposing (Model, init, main, update, view)

import Browser
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (checked, style, type_)
import Html.Events exposing (onClick)
import Random
import Random.Extra
```

If you know HTML, you can mostly guess what these do.

`Random.Extra` includes a function for generating random booleans, which I found referenced at the bottom of the [elm/random documentation](https://package.elm-lang.org/packages/elm/random/latest/).

Remember to do `elm install elm/random` and `elm install elm-community/random-extra`

## 2. Main function

I'm using `Browser.element` instead of `Browser.sandbox` today. Sandboxed programs can't communicate with the outside world, and in Elm, random values are considered part of the outside world:

https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox

```elm
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
```

I still need to re-read the [previous comment by bukkfrig](https://dev.to/bukkfrig/comment/19b0m), but I'll understand what the type annotation means eventually.

New from yesterday is the `subscriptions` field. What am I subscribed to? Nothing, apparently:

> The other new thing in this program is the subscription function. It lets you look at the Model and decide if you want to subscribe to certain information. In our example, we say Sub.none to indicate that we do not need to subscribe to anything, but we will soon see an example of a clock where we want to subscribe to the current time!

Taken from https://guide.elm-lang.org/effects/http.html

Subscriptions seem to be required for `Browser.element`, so I'm not going to worry too much about them for now: https://package.elm-lang.org/packages/elm/browser/latest/Browser#element

## 3. Model

My model is a 10x10 grid of `True` and `False`, which in code is a list of bool lists.

This is what a 3x3 grid would look like in JavaScript:

```javascript
const grid3x3 = [
  [true, false, false],
  [true, true, false],
  [false, false true]
]
```

Here's the blueprint for the Elm structure:

```elm
type alias Model =
    { grid : List (List Bool)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { grid = [ [ True ] ] }, getGridValues )
```
The parentheses were [explained to me yesterday by bukkfrig](https://dev.to/bukkfrig/comment/19b0m), but I'm not entirely sure about the underscore `_`. I'll re-visit that another day.

`Cmd Msg` was one of today's new concepts. I read a bit about it here:
* https://guide.elm-lang.org/effects/
* https://guide.elm-lang.org/effects/random.html

From my understanding, when we want to access impure functions with unpredictable results, we send a message to the Elm runtime to handle it for us.

`getGridValues` is just a message I give to the Elm runtime, which will be returned to me as a different message, along with the requested data.

## 4. Update

### 4.1 Two possible message types

```elm
type Msg
    = RequestToElmRuntime
    | ResponseFromElmRuntime (List (List Bool))
```

In this application, there are two possible messages:
1. `RequestToElmRuntime`: When I click the button, this is the message that gets sent. It doesn't contain any values - it just tells Elm to fetch some data.
2. `ResponseFromElmRuntime`: Elm responds to the message, giving me a `List (List Bool)`

### 4.2 getGridValues function

```elm
getGridValues : Cmd Msg
getGridValues =
    Random.generate ResponseFromElmRuntime (Random.list 10 (Random.list 10 Random.Extra.bool))
```

Take note of the type annotation here. `getGridValues` doesn't return any values. It returns the `Cmd Msg` that Elm brings with it to the runtime.

I was stuck here for quite some time, since I was trying to pass this to my view function:

```elm
randomList n =
    List.map (\num -> Random.Extra.bool) (List.range 0 n)
```

As I know now, the `Random` functions only return *generators*, which are converted to `Cmd Msg` by `Random.generate`. 

The values need to be fetched by the runtime after receiving these messages.

### 4.3 Update function

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestToElmRuntime ->
            ( model, getGridValues )

        ResponseFromElmRuntime theNewValues ->
            ( { model | grid = theNewValues }, Cmd.none )
```

Here we respond to two possible messages. One is `requestToElmRuntime`, which gets sent when the button is clicked.

The second message - `ResponseFromElmRuntime` - brings with it a variable called `theNewValues`, which matches the specification from the `getGridValues` function.

Phew! I think that's the gist of it. Please let me know if there's anything I misssed. 

That was a lot of work just to get some random boolean values, right?

However, according to the documentation, many find this approach advantageous:

>... once people become familiar with generators, they often report that it is easier than the traditional imperative APIs for most cases. For example, jump to the docs for Random.map4 for an example of generating random quadtrees and think about what it would look like to do that in JavaScript!

- From [elm/random, Mindset Shift](https://package.elm-lang.org/packages/elm/random/latest)

## 5. Subscriptions

There aren't any, so this part feels a bit silly :)

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
```

## 6. View

My initial view was pretty messy, but after extracting things into their own functions, I think it looks pretty good!

```elm
convertBoolsToInputs : List Bool -> List (Html Msg)
convertBoolsToInputs elements =
    List.map (\boolValue -> input [ checked boolValue, type_ "checkbox" ] []) elements


createGrid : Model -> List (Html Msg)
createGrid model =
    List.map (\row -> div [] (convertBoolsToInputs row)) model.grid


view : Model -> Html Msg
view model =
    div [ style "padding" "1rem" ]
        [ button
            [ onClick RequestToElmRuntime
            , style "padding" "1rem"
            , style "margin-bottom" "1rem"
            ]
            [ text "Haha checkboxes go brrr" ]
        , div [] (createGrid model)
        ]
```

I added some padding to the button because I like large click targets.

`List.map myFunction myList` applies `myFunction` to each item in `myList`.

`\boolValue ->` just means that each item in the list gets the name "boolValue", and has the function applied to it.

Remember that `input` and `div` aren't HTML elements - they're functions!

https://package.elm-lang.org/packages/elm/html/1.0.0/Html

# 7. Closing thoughts and code

This was a tough project, but I learned a lot!

I'll probably do something way easier tomorrow, like combining a couple of things from the core library: https://package.elm-lang.org/packages/elm/core/latest

Any project counts, as long as I can say "I didn't know how to do that yesterday".

Here's the final code:

```elm
module Main exposing (Model, init, main, update, view)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (checked, style, type_)
import Html.Events exposing (onClick)
import Random
import Random.Extra



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { grid : List (List Bool)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { grid = [ [ True ] ] }, getGridValues )



-- Update


type Msg
    = RequestToElmRuntime
    | ResponseFromElmRuntime (List (List Bool))


getGridValues : Cmd Msg
getGridValues =
    Random.generate ResponseFromElmRuntime (Random.list 10 (Random.list 10 Random.Extra.bool))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestToElmRuntime ->
            ( model, getGridValues )

        ResponseFromElmRuntime theNewValues ->
            ( { model | grid = theNewValues }, Cmd.none )



-- Subscriptions (none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


convertBoolsToInputs : List Bool -> List (Html Msg)
convertBoolsToInputs elements =
    List.map (\boolValue -> input [ checked boolValue, type_ "checkbox" ] []) elements


createGrid : Model -> List (Html Msg)
createGrid model =
    List.map (\row -> div [] (convertBoolsToInputs row)) model.grid


view : Model -> Html Msg
view model =
    div [ style "padding" "1rem" ]
        [ button
            [ onClick RequestToElmRuntime
            , style "padding" "1rem"
            , style "margin-bottom" "1rem"
            ]
            [ text "Haha checkboxes go brrr" ]
        , div [] (createGrid model)
        ]

```