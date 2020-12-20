This is day 4 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Code: https://github.com/kristianpedersen/30-days-of-elm/blob/main/004-toggle-visibility/src/Main.elm

Demo: https://kristianpedersen.github.io/30-days-of-elm/004-toggle-visibility/

My only goal today was to publish my three previous Elm projects as interactive web pages - not just their source code.

This was super easy!

1. Activate GitHub Pages by going to my GitHub repo's settings, scroll all the way down, and choose `main` as my source.
2. In each project folder, enter `elm make src/Main.elm`, which creates a big scary HTML file we don't need to worry about.
3. Push to GitHub.

All subfolders in my repo now have a URL in this format: `https://kristianpedersen.github.io/30-days-of-elm/[folder-name]`, showing `index.html` if it exists, or `readme.md`.

The only downside is that the generated HTML files are thousands of lines long, but they work fine, and there's some interesting and confusing stuff going on in them.

# Code project: Toggle visibility with checkbox

I wasn't planning to write any code today, but I ended up wanting to anyway.

Today's project is a lot simpler than yesterday's random generator bonanza.

Here's a Svelte example:

```javascript
<script>
	let visible = false
</script>

<input type="checkbox" bind:checked={visible} />

{#if visible}
	<p>Hi!</p>
{/if}
```

Today's code is a lot simpler than yesterday, but I learned a couple of interesting things along the way.

# Code walkthrough

1. Import and main
2. Model
3. Update
4. View

## 1. Import and main

```elm
module Main exposing (Msg(..), init, main)

import Browser
import Html exposing (Html, div, input, p, text)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onCheck)

main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }
```

If you know JavaScript, you might have expected to see a `change` event, but Elm calls it `onCheck`, which sounds a lot nicer.

https://package.elm-lang.org/packages/elm/html/latest/Html-Events

For the main function, I'm just using `Browser.sandbox` rather than `Browser.element`, since there's no communicating with external data.

## 2. Model

```elm
type alias Model =
    { visible : Bool
    }


init : Model
init =
    { visible = False
    }
```

This could even have been as simple as:

```elm
init = False
```

... but having it as a record makes it easier to add more fields later though. Also, the type annotations tend to result in better error messages.

## 3. Update

```elm
type Msg
    = ToggleVisibility Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleVisibility checkboxValue ->
            { model | visible = checkboxValue }
```

Elm events return an `Attribute msg`*. I guess that's a user-defined attribute, along with a `msg`, which is the event value. But what about the `msg` argument in my update function? Is that related to `Attribute msg`?

Because I'm a n00b, I was originally going to use `onInput`, but I discovered it sends the string representation of event.target.value:

\* https://package.elm-lang.org/packages/elm/html/latest/Html-Events

## 4. View

```elm
view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "checkbox", onCheck ToggleVisibility ] []
        , p []
            [ if model.visible then
                text "Hi!"

              else
                text ""
            ]
        ]
```

Nothing very fancy here, but I did learn two things about `if` statements:
1. You have to write `then`
2. There must be an `else` - Elm needs to have all cases handled, which is something I've heard about in videos before.

# Summary

* Deploying simple Elm projects to GitHub Pages is super easy!
* Elm has `onCheck` for checkbox events, instead of `change`.
* Events return an `Attribute msg`, which contains a user-defined attribute and a value from the event target (I guess).
* I'm confused by `msg` and `Attribute msg`. 