This is day 7 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

I want to relax today, so I'll just trying using `elm-ui` to center some divs and their content.

Code/demo: https://ellie-app.com/bSNRPYHz6nna1

Today's project uses these packages:
* [mdgriffith/elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/)
* [phollyer/elm-ui-colors](https://package.elm-lang.org/packages/phollyer/elm-ui-colors/latest) (because I like HTML color names)
  
I highly recommend watching ["Building a Toolkit for Design" by Matthew Griffith
](https://www.youtube.com/watch?v=Ie-gqwSHQr0)

# Background

I remember trying to figure out how to center a div and its content as a beginner. 

Still, the top result for me is from W3Schools, which includes things like both absolute and relative positioning, and translating by -50%.

Flexbox improved things a lot, but I still wished there was something simpler. 

I don't do much CSS, so I still get tripped up by aligning, justifying, flex-this, flex-that.

Anyway, here's how I would center a div and its contents using regular CSS.

```html
<html>

<head>
	<style>
		body {
			align-items: center;
			display: flex;
			justify-content: center;
		}

		div {
			background-color: lime;
			display: flex;
			align-items: center;
			justify-content: center;
			width: 200px;
			height: 200px;
		}
	</style>
</head>

<body>
	<div>
		<p>I am centered!</p>
	</div>
</body>

</html>
```

Here's how to do it with `elm-ui`. Man, that's nice:

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

Here's today's code - two rectangles and a square saying hi to you!

That's it. See you tomorrow!

```elm
module Main exposing (..)

import Colors.Opaque exposing (beige, lightblue, salmon)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html)


main : Html.Html msg
main =
    fullscreenContainer
        [ centeredDiv 200 40 lightblue
        , centeredDiv 40 200 beige
        , centeredDiv 100 100 salmon
        ]


fullscreenContainer : List (Element msg) -> Html msg
fullscreenContainer stuff =
    layout [] <|
        column [ width fill, height fill, spacing 15 ] stuff


centeredDiv : Int -> Int -> Color -> Element msg
centeredDiv divWidth divHeight backgroundColor =
    row
        [ Background.color backgroundColor
        , Border.width 2
        , centerX
        , centerY
        , width (px divWidth)
        , height (px divHeight)
        ]
        [ el [ centerX, centerY ] (text "Hi!") ]
```