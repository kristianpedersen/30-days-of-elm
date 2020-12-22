This is day 6 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Code/demo: https://ellie-app.com/bSjxHwhPS4Za1

# About today's project / Acknowledgments

Today's project is about generating colors, and checking whether black or white text is the most readable, according to [Web Content Accessibility Guidelines (WCAG) standards](https://www.w3.org/TR/UNDERSTANDING-WCAG20/conformance.html#uc-levels-head).

<img src="https://i.imgur.com/Dfs2Zh8.png" />

## Tessa Kelly
The colors and accessibility parts of today's project were made possible by [tesk9/palette](https://package.elm-lang.org/packages/tesk9/palette/3.0.1/). I discovered it through a talk by the package's author Tessa Kelly: [Color coding with Elm](https://www.youtube.com/watch?v=UzvCX-8bTDs). Just look at that swirly Cubehelix at 30:17! :D

## Wolfgang Schuster / @wolfadex
[His comment on yesterday's post](https://dev.to/wolfadex/comment/19eie) (and the other ones) taught me a lot! The Elm community in general has been really helpful and supportive.

## megapctr @ Slack
Thanks for reminding me that the update function needs *two* arguments. I would have gotten stuck for an hour if you hadn't helped me! :D

# Table of contents

- [About today's project / Acknowledgments](#about-todays-project--acknowledgments)
	- [Tessa Kelly](#tessa-kelly)
	- [Wolfgang Schuster / @wolfadex](#wolfgang-schuster--wolfadex)
	- [megapctr @ Slack](#megapctr--slack)
- [Table of contents](#table-of-contents)
- [Main.elm walkthrough](#mainelm-walkthrough)
- [1. Imports](#1-imports)
- [2. Main and Msg](#2-main-and-msg)
- [3. Model](#3-model)
- [4. View](#4-view)
	- [4.1 Select AA or AAA rating](#41-select-aa-or-aaa-rating)
	- [4.2 Sliders for adjusting color](#42-sliders-for-adjusting-color)
	- [4.3 Show Cubehelix info](#43-show-cubehelix-info)
	- [4.4 Check readability on selected background color](#44-check-readability-on-selected-background-color)
	- [4.5 Color rectangles](#45-color-rectangles)
- [5. Update](#5-update)
- [6. Conclusion](#6-conclusion)

# Main.elm walkthrough

This is my longest project so far. `elm-format` likes having tall files, which is something I'll get used to eventually.

I realize my order has been kind of wrong previously. It's called "model, view, update", but I think I've had the view last.

From now on, I'll stick to the MVU convention.

# 1. Imports

Luckily, the Elm VS Code extension can add things to the imports automatically. If you type `div` without having imported it, a tooltip shows up which asks if you want to add it to the imports.

```elm
module Main exposing (..)

import Browser
import Html exposing (Html, div, form, input, label, li, span, text, ul)
import Html.Attributes exposing (for, name, step, style, type_)
import Html.Events exposing (onInput)
import Html.Events.Extra exposing (onChange)
import Maybe exposing (withDefault)
import Palette.Cubehelix as Cubehelix
import SolidColor exposing (SolidColor)
import SolidColor.Accessibility exposing (checkContrast, meetsAA, meetsAAA)
```

Today's two installs were:
1. `elm install tesk9/palette`
2. `elm install elm-community/html-extra`

Html.Extra contains the onChange events, which I wanted to use. No point in updating the model with onClick, if it's the same radio button being clicked.

`tesk9/palette` includes both `Palette.Cubehelix` and `SolidColor`.

`SolidColor` is just how you generate colors, I guess.

`Cubehelix` is this super cool swirl of RGB - just look at that!

<img src="https://i.imgur.com/MxplkM3.png" />

# 2. Main and Msg

```elm
main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = GenerateNewColors String String
    | ChangeAccessibilityRating String String
```

`main` is the same old main function we've seen before.

The `Msg` type is something I'm understanding better now, and it gives a good overview of the available user actions. 

Events send some information by default, which is listed in the [event documentation](https://package.elm-lang.org/packages/elm/html/latest/Html-Events), but you can also decide to send other things with them.

`onInput` and `onChange` first grab the string value of `event.target.value`, but then it can also pass additional information, which in this case is another string.

If I wanted to pass a tuple of XY values, I could have written `type Msg = GenerateNewColors (Int, Int) String`.

# 3. Model

```elm
type alias Model =
    { palette : List SolidColor
    , rating : SolidColor.Accessibility.Rating
    , cubehelixStart : ( Int, Int, Int )
    , cubehelixRotations : Float
    , cubehelixGamma : Float
    }


initialColors : List SolidColor
initialColors =
    Cubehelix.generateAdvanced 100
        { start = SolidColor.fromHSL ( 80, 100, 0 )
        , rotationDirection = Cubehelix.BGR
        , rotations = 1.2
        , gamma = 0.9
        }


init : Model
init =
    { palette = initialColors
    , rating = SolidColor.Accessibility.AA
    , cubehelixStart = ( 80, 100, 0 )
    , cubehelixRotations = 1.2
    , cubehelixGamma = 0.9
    }
```

Today's most difficult obstacle was the model. Initially, I had a nested structure, but I couldn't figure out how to do it with the record update syntax. 

Also, nested models seem quite frowned upon: 
* https://www.reddit.com/r/elm/comments/b2f7f6/any_plans_for_nested_record_syntax/
* https://discourse.elm-lang.org/t/updating-nested-records-again/1488/9

I can see how multiple levels of nesting can be problematic, but I think my model would have looked better like this:

```elm
type alias Model =
    { palette : List SolidColor
    , rating : SolidColor.Accessibility.Rating
	, cubehelixSettings : 
		{ start : ( Int, Int, Int )
		, rotations : Float
		, gamma: Float
		}
    }
```

The `initialColors` makes the `init` function nicer to read.

# 4. View

Check out this beautiful view function! 

It's all right there, I can tell immediately how my layout is structured, and I can easily re-order it.

```elm
view : Model -> Html Msg
view model =
    div [ style "font-family" "sans-serif" ]
        [ selectAAorAAA
        , adjustColors
        , showCubehelixInfo model
        , colorRectangles model
        ]
```

Let's go check out what these 4 functions do:

## 4.1 Select AA or AAA rating

```elm
selectAAorAAA : Html Msg
selectAAorAAA =
    form []
        [ label []
            [ input
                [ type_ "radio"
                , name "accessibility-type"
                , onChange (ChangeAccessibilityRating "AA")
                ]
                []
            , text "AA"
            ]
        , label []
            [ input
                [ type_ "radio"
                , name "accessibility-type"
                , onChange (ChangeAccessibilityRating "AAA")
                ]
                []
            , text "AAA"
            ]
        ]
```
The labels allow me to click the text to change the radio buttons. Please do this!

As discussed previously, events can have any kind of message associated with them! `onChange` passes `event.target.value`, and then the string I specify. We'll see how these are used in the `update` function later.

AA and AAA are the mid-range and highest levels of conformance to the [Web Content Accessibility Guidelines](https://www.ucop.edu/electronic-accessibility/standards-and-best-practices/levels-of-conformance-a-aa-aaa.html#:~:text=WCAG%202.0%20guidelines%20are%20categorized,%2C%20and%20AAA%20(highest).&text=For%20example%2C%20by%20conforming%20to,A%20and%20AA%20conformance%20levels.).

In today's project, we're only using these in the context of background/foreground color contrast. 

Accessibility is something I'm familiar with beyond using the right HTML tags and not having yellow text on a while background. 

Accessible websites also benefit me, and [Norwegian websites are required by law to be accessible](https://medium.com/confrere/its-illegal-to-have-an-inaccessible-website-in-norway-and-that-s-good-news-for-all-of-us-b59a9e929d54).

## 4.2 Sliders for adjusting color

```elm
adjustColors : Html Msg
adjustColors =
    form []
        [ label [ for "hue" ]
            [ text "Hue"
            , input
                [ type_ "range"
                , onInput (GenerateNewColors "hue")
                , Html.Attributes.min "0"
                , Html.Attributes.max "360"
                , Html.Attributes.value "0"
                , step "5"
                ]
                []
            ]
        , label [ for "rotations" ]
            [ text "Rotations"
            , input
                [ type_ "range"
                , onInput (GenerateNewColors "rotations")
                , Html.Attributes.min "0"
                , Html.Attributes.max "2"
                , Html.Attributes.value "1.2"
                , step "0.1"
                ]
                []
            ]
        , label [ for "gamma" ]
            [ text "Gamma"
            , input
                [ type_ "range"
                , onInput (GenerateNewColors "gamma")
                , Html.Attributes.min "0"
                , Html.Attributes.max "2"
                , Html.Attributes.value "0.8"
                , step "0.1"
                ]
                []
            ]
        ]
```

Again, we see how the events match the `Msg` type defined earlier. In addition to `GenerateNewColors` and a custom message, the update function also receives `event.target.value` as a string.

## 4.3 Show Cubehelix info

This is a function that just displays parts of the model as text.

When writing this, I saw that `hslText` had to be read backwards to make sense. I found a nice way to fix this problem, which is shown below the code:

```elm
showCubehelixInfo : Model -> Html Msg
showCubehelixInfo model =
    div []
        [ let
            ( h, s, l ) =
                model.cubehelixStart

            rotations =
                model.cubehelixRotations

            gamma =
                model.cubehelixGamma

            hslText =
                text ("HSL: " ++ String.join ", " (List.map String.fromInt [ h, s, l ]))

            rotationsText =
                text ("Rotations: " ++ String.fromFloat rotations)

            gammaText =
                text ("Gamma: " ++ String.fromFloat gamma)
          in
          ul []
            [ li [] [ hslText ]
            , li [] [ rotationsText ]
            , li [] [ gammaText ]
            ]
        ]
```

`model.cubehelixStart` contains a tuple of three values `(Int, Int, Int)`, which are extracted into three variables, `h`, `s` and `l`.

* Hue: Which color of the rainbow?
* Saturation: 0% - 100% = grayscale -> color -> MS Paint color 
* Lightness: 0% - 100% = black - color - white

`[h, s, l]` contains three `Int`s. These are converted to strings, and then joined into one string, with commas as the separator. However, the code seems kind of backwards!

To fix this, let's use the pipe operator instead. I haven't read anything about it yet, but I've seen several code examples that use it. 

I think the order makes a lot more sense now:

```elm
hslText =
	text
		("HSL: "
			++ ([ h, s, l ]
					|> List.map String.fromInt
					|> String.join ", " 
				)
		)
```

## 4.4 Check readability on selected background color

This function is used in function 4.5 that renders all the colored rectangles.

```elm
isBlackTextReadable : Model -> SolidColor -> Bool
isBlackTextReadable model backgroundColor =
    checkContrast { fontSize = 12, fontWeight = 700 }
        backgroundColor
        (SolidColor.fromRGB ( 0, 0, 0 ))
        |> (case model.rating of
                SolidColor.Accessibility.AA ->
                    meetsAA

                SolidColor.Accessibility.AAA ->
                    meetsAAA

                _ ->
                    meetsAAA
           )
```

The `checkContrast` function comes from `SolidColor.Accessibility`. I just copied the example, but to be honest, I would have prefered to write it as `SolidColor.Accessibility.checkContrast`. 

It's a long name, but at least I can tell at a glance that it's not just some function I made and forgot about.

If the model's `rating` is AA, return `meetsAA` - otherwise, return `meetsAAA`. 

## 4.5 Color rectangles

```elm
colorRectangles : Model -> Html Msg
colorRectangles model =
    div [] <|
        List.map
            (\color ->
                span
                    [ style "background-color" (SolidColor.toHSLString color)
                    , style "display" "inline-block"
                    , style "padding" "1rem"
                    , style "width" "calc(10vw - 1rem)"
                    , style "color"
                        (if isBlackTextReadable model color then
                            "black"

                         else
                            "white"
                        )
                    ]
                    [ text (SolidColor.toHex color)
                    ]
            )
            model.palette
```

For each color in the model palette, make a `span` element, with the color as a hex string.

I could have chosen hex for the "background-color" attribute as well, but I'm just so used to thinking in HSL.

# 5. Update

The update function is a tall one! It's mostly just doing simple updates to the model, depending on the message and value passed in.

The `let` statement just allows us to use shorter variable names, which makes the return statements easier to read.

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeAccessibilityRating rating _ ->
            case rating of
                "AA" ->
                    { model | rating = SolidColor.Accessibility.AA }

                "AAA" ->
                    { model | rating = SolidColor.Accessibility.AAA }

                _ ->
                    model

        GenerateNewColors parameter value ->
            let
                hue =
                    withDefault 0 (String.toFloat value)

                rotations =
                    model.cubehelixRotations

                gamma =
                    model.cubehelixGamma

                updatedPalette =
                    Cubehelix.generateAdvanced 100
                        { start = SolidColor.fromHSL ( 80, 100, 0 )
                        , rotationDirection = Cubehelix.BGR
                        , rotations = rotations
                        , gamma = gamma
                        }
            in
            case parameter of
                "hue" ->
                    { model
                        | cubehelixStart = ( floor hue, 100, 0 )
                        , palette =
                            Cubehelix.generateAdvanced 100
                                { start = SolidColor.fromHSL ( hue, 100, 0 )
                                , rotationDirection = Cubehelix.BGR
                                , rotations = rotations
                                , gamma = gamma
                                }
                    }

                "rotations" ->
                    { model
                        | cubehelixRotations = withDefault 0 (String.toFloat value)
                        , palette = updatedPalette
                    }

                "gamma" ->
                    { model
                        | cubehelixGamma = withDefault 0 (String.toFloat value)
                        , palette = updatedPalette
                    }

                _ ->
                    model
```

So basically, if message is "blabla", return the previous model as it is, but update the fields after the `|` character.

One new thing that tripped me up was the `String.toFloat` function, which returns a `Maybe Float`. 

If the conversion is successful, we get a `Float`. If invalid data was entered, we set it to 0, using `withDefault`.

# 6. Conclusion

This was a really exciting project to work on!

I think the result is very fun and engaging, and I've taken my first step into web accessibility beyond semantic HTML and basic design principles.

Again, thanks for the help, everyone! See you tomorrow!