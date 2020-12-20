# 1/30: Show input value in p tag

Code: https://github.com/kristianpedersen/30-days-of-elm/blob/main/001-show-slider-value-in-p-tag/src/Main.elm

Demo: https://kristianpedersen.github.io/30-days-of-elm/001-show-slider-value-in-p-tag/

## My elm experience before today

I've gone through the Elm intro course on Frontend Masters, but I really don't learn much from following along.

These 30 days, I will instead come up with ideas that are suitable for my current level. That's how I learned JavaScript, so I think it's a good approach.

## Disclaimer

I really don't know what I'm doing. Copy my code at your own risk.

## Goal

My goal today is to have a range slider's value be shown in a p tag.

Here's the code I'll try to recreate, written in Svelte:

```html
<script>
	let n = 0;
</script>

<input type="range" bind:value={n}>
<p>{n}</p>
```

Obviously, the Elm equivalent isn't going to be nearly as simple as this, but I'm up for a good challenge.

I'm probably just going to add type annotations to my Elm code. People say they make the code more readable, and it lets the compiler provide better error messages.

## Thoughts about cool/confusing aspects of Elm

This is a step-by-step walkthrough of today's code.

Many parts of the code are taken from this example: [https://guide.elm-lang.org/architecture/text_fields.html](https://guide.elm-lang.org/architecture/text_fields.html)

### 1. Import statements
```elm
module Main exposing (main)

import Browser
import Html exposing (Html, div, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
```

if you've written HTML before, these word should be familiar. The first line was added automatically by VS Code. `(..)` means everything.

### 2. Main function / Browser.sandbox

```elm
main : Program () Model Msg
main =
    Browser.sandbox { init = initialState, update = update, view = view }
```

The first line was suggested to me by VS Code, so why not. Is this a function that returns a "program parenthesis model message"? ¯\\_(ツ)_/¯

What's being passed in here seems like the basic Elm structure that I've heard of before: Model (state), update function and view function.

`Browser.sandbox` seems interesting. What other things can be added to the main function?

Do people always write `update = update` and `view = view`, or is there a more elegant way? In modern JavaScript for example, we can do this:
```javascript
	// These produce the same result
	const oldWay = { update: update, view: view }
	const newWay = { update, view }
``` 

[The Browser.sandbox documentation](https://package.elm-lang.org/packages/elm/browser/latest/Browser) isn't very clear to me. Is it just a construct to get something up and running for complete beginners?

### 3 Model

```elm
type alias Model =
    { value : String
    , message : String
    }


initialState : Model
initialState =
    { value = "0"
    , message = "Hi!"
    }
```
For such a simple app, this feels unnecessary. I can do that in two lines of JavaScript. At the same time, it does look pretty neat.

From what I understood, the [input event listener](https://package.elm-lang.org/packages/elm/html/latest/Html-Events) in Elm only returns `event.target.value` as a string.

I did try to convert that string to an int, but the `String.toInt` function returns a `Maybe Int` and not an `Int`. 

I guess this would be handled with a case statement, but I'll leave that for another day.

### 4. Update function

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | value = newContent }
```

How is this function invoked? Is that taken care of by `Browser.sandbox`? Is the return value from `onInput` connected to it?

The phrasing "case msg of" sounds weird, not like something people would say out loud. Am I correct in thinking of it as "check the variable msg for these cases" instead?

`Change newContent`: I guess `Change` is a message or symbol, and `newContent` is the return value from the event listener. Is that right?

### 5. View function

```elm
view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "range", onInput Change ] []
        , p [] [ text model.value ]
        , p [] [ text model.message ]
        ]
```

I don't know exactly what an Html Msg is yet, but it's probably just HTML.

When I first saw this kind of syntax, I didn't like it at all. Now I think it's alright.

From what I understand, these HTML elements are functions that take two arguments: attributes and a list of child elements.

Having the commas at the beginning of the line is very nice.

`type` is probably a reserved keyword in Elm, so I guess that's why it's called `type_` instead.

# Summary

Today, I've taken my first steps in Elm! For such a simple project, I would much rather recommend Svelte, but I'm sure Elm is very useful in more complex projects.

Even before I started this challenge today, I missed Elm:

Earlier today, I was working on an Express/React application for a technical interview. As usual, the React compiler said everything was okay, and a few clicks later - a huge red Chrome screen because of a runtime error.

I don't know what tomorrow's Elm project will be, but it won't have any runtime errors.

Please let me know if you spot any errors, misunderstandings or ugly code! :)

Here's today's full code:

```elm
module Main exposing (main)

import Browser
import Html exposing (Html, div, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
    Browser.sandbox { init = initialState, update = update, view = view }


type alias Model =
    { value : String
    , message : String
    }


initialState : Model
initialState =
    { value = "0"
    , message = "Hi!"
    }


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | value = newContent }


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "range", onInput Change ] []
        , p [] [ text model.value ]
        , p [] [ text model.message ]
        ]
```