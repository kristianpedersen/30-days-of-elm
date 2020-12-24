This is day 8 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Merry Christmas!

Today we're getting some data from JavaScript, using `flags`.

For the most part, I've just followed this guide: https://guide.elm-lang.org/interop/flags.html

- [Getting up and running](#getting-up-and-running)
- [Setup](#setup)
	- [1. Automatically run "elm make ..." on save](#1-automatically-run-elm-make--on-save)
	- [2. Automatic browser reload with live-server](#2-automatic-browser-reload-with-live-server)
- [1. Create the HTML file, and add static data](#1-create-the-html-file-and-add-static-data)
- [2. Setup, subscriptions](#2-setup-subscriptions)
- [3. Model](#3-model)
- [4. Update](#4-update)
- [5. View](#5-view)

# Getting up and running
In previous projects, I've used [elm reactor](https://guide.elm-lang.org/install/elm.html) and gone to `http://localhost:8000/src/Main.elm`.

Today, we need to generate a JavaScript file, and reference it in an `index.html` file.

1. In your project root directory, run `elm make src/Main.elm --output=main.js`.
2. Create an `index.html` with the code from the flags tutorial above. 

This can however lead to some annoying repetition. Imagine doing this manually for every change: 

* Make changes to `Main.elm`
* Re-run `elm make src/Main.elm --output=main.js`
* Reload the browser.

# Setup

To solve this, I use `nodemon` and `live-server`. If you have Node.js installed, you can install them like this: `npm install -g nodemon live-server`

## 1. Automatically run "elm make ..." on save

`nodemon` is typically used to re-run Node.js scripts when you hit save, but I've also used it with Python and Ruby before!

In our case, we can just enter `nodemon --exec elm make src/Main.elm --output=main.js`, and let it do its thing in the background. :)

## 2. Automatic browser reload with live-server

**Open a new terminal**, navigate to the folder with your `index.html` file, and enter `live-server`. 

A new browser tab will be opened. Any file changes will reload the browser.

# 1. Create the HTML file, and add static data

I just copied the code from https://guide.elm-lang.org/interop/flags.html

The `main.js` file we're referencing was created when we ran `elm make src/Main.elm --output=main.js`

The `flags` object is the stuff that gets sent to Elm, which you can see here:

```html
<html>

<head>
	<meta charset="UTF-8">
	<title>Main</title>
	<script src="main.js"></script>
</head>

<body>
	<div id="myapp"></div>
	<script>
		const d = new Date()
		const isChristmas = d.getDate() === 24 && d.getMonth() === 11 // lol wtf

		var app = Elm.Main.init({
			node: document.getElementById('myapp'),
			flags: {
				isChristmas,
				messageFromSanta: "Merry Christmas!",
				randomNumbersDivisibleBy42: [...Array(1000)]
					.map(n => Math.random() * 1000)
					.map(Math.floor)
					.filter(n => n % 42 === 0 && n !== 0)
			}
		});
	</script>
</body>

</html>
```

# 2. Setup, subscriptions

I haven't read much about subscriptions yet, but they're needed to receive data from `index.html`.

```elm
module Main exposing (..)

import Browser
import Html exposing (Html, div, text)


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
```

Here's the documentation on commands and subscriptions, which I'll definitely get into one of these next days: https://guide.elm-lang.org/effects/

# 3. Model

```elm
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
```

First, the `Model` type alias has to match the data structure coming from `index.html`.

Then it's passed to the init function. I still think `Cmd.none` looks weird.

It would have been nice if I could just do the destructuring in the `let` part of the statement, and not having to write repetitive stuff like `isXmas = isXmas`.

# 4. Update

Doesn't do anything as far as I can tell:

```elm
type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )
```

# 5. View

```elm
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
```

Nothing crazy going on in the view. 

You don't have to use the arrows, but I find them nicer to read than this:

```elm
String.join ", " (List.map String.fromInt model.rnd42)
```

I hope this project was useful to you. Merry Christmas, and see you tomorrow!