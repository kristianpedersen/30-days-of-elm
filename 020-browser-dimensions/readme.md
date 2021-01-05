This is day 20 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today I wanted to do something visual, but I wanted the SVG to fill up the available space. Instead, this turned out to be a day where we learn about getting information about the browser's width and height.

In JavaScript, I can just ask for `innerWidth` and `innerHeight`. In Elm, it's more difficult.

- [1. Getting the browser's width and height](#1-getting-the-browsers-width-and-height)
- [2. Responding to window resize events](#2-responding-to-window-resize-events)
- [3. The code](#3-the-code)
  - [3.1. Model and Msg](#31-model-and-msg)
  - [3.2. Main and subscription](#32-main-and-subscription)
  - [3.3. Update](#33-update)
  - [3.4. View](#34-view)
- [4. Conclusion](#4-conclusion)

# 1. Getting the browser's width and height

My experience with Elm documentation has been a bit frustrating. The descriptions are often good, and the type annotations help, but there have been a few occasions where just one or two code examples would have helped a lot.

For example, [Browser.Dom.getViewport](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#getViewport) sounds good, but how do I use it? Its type annotation says `Task x Viewport`. I've seen `Task` mentioned before, and `Viewport` is explained very well, but what on earth is an `x`?

Of course, I should have read the documentation more thoroughly, but just having a practical example would have been nice for developers at any level.

The type alias is easy to understand:

```elm
type alias Viewport =
    { scene :
          { width : Float
          , height : Float
          }
    , viewport :
          { x : Float
          , y : Float
          , width : Float
          , height : Float
          }
    }
```

However, when trying to return `Browser.Dom.getViewport.scene` in a function, I get this error:

> This is not a record, so it has no fields to access!
23|     Browser.Dom.getViewport.scene
        ^^^^^^^^^^^^^^^^^^^^^^^
This `getViewport` value is a:
Task.Task x Browser.Dom.Viewport
But I need a record with a scene field!

Well excuse me for reading the type alias and thinking curly braces equal a record. ;)

So I read up on the [Task documentation](https://package.elm-lang.org/packages/elm/core/latest/Task), and revisit the time example, and try `Task.perform GetBrowserDimensions Browser.Dom.getViewport`, with the following code:

```elm
type Msg
    = GetBrowserDimensions


dimensions =
    Task.perform GetBrowserDimensions Browser.Dom.getViewport
```

This resulted in a type of error message I've seen before, but I still struggle a bit with. `Msg` and `msg` - not a good choice of convention. :/

>28|     Task.perform GetBrowserDimensions Browser.Dom.getViewport
                    ^^^^^^^^^^^^^^^^^^^^
This `GetBrowserDimensions` value is a:
    Msg
But `perform` needs the 1st argument to be:
    a -> msg

I asked at the Elm Slack channel, and got help very quickly:


>Samuel Kacer  28 minutes ago
The first argument to Task.perform needs to be a function that will take the result from the Task and wrap it in some kind of message. so for the case of getViewPort, the argument needs to be of type Viewport -> Msg.
the first argument you are providing, `GetBrowserDimensions`, is of type Msg, so I assume it doesn't contain anything and has a definition something like this:
type Msg =
  ...
  | GetBrowserDimensions
but instead needs to be something like
  | GetBrowserDimensions Viewport
that way the constructor for that message variant will have a type of Viewport -> Msg, which would fit for the Task you are wanting to perform

>arkham  27 minutes ago
you can check out this ellie https://ellie-app.com/bZvHnKqpPrCa1

Also, I decided I needed it to respond to window resize events, which was also confusing, since the [onResize documentation](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events#onResize) uses `Cmd Msg` as its type, but apparently I needed to use a `Sub Msg` in my case:

>Kristian Pedersen  2 hours ago

# 2. Responding to window resize events

>Actually, I realized I wanted it to update on window resize. Again, I think I’m almost there, but it’s telling me I need a sub msg, not a cmd msg:
https://ellie-app.com/bZBqjmgPS9pa1
What also confuses me is that going by the documentation, the subscriptions function returns a cmd msg, but in my example, it need to be a sub msg: https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events#onResize


>arkham  1 hour ago
hey @Kristian Pedersen, it’s just the type of the subscription is a Sub Msg instead of a Cmd Msg , so your subscriptions function should be a Sub Msg, here’s a working ellie https://ellie-app.com/bZC6k6dv9wna1

>arkham  1 hour ago
I also converted the Ints to Floats to get the type checker to be happy

>arkham  1 hour ago
and here’s a very simple example of a subscription: https://guide.elm-lang.org/effects/time.html

>arkham  1 hour ago
oh, and to be clear: the documentation is saying that onResize returns a Sub msg https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events#onResize

Thanks for the help and patience, Arkham! You're a legend.

# 3. The code

Once all the confusion and going back and forth had settled, my resulting code mostly looks pretty nice, to be honest.

## 3.1. Model and Msg

```elm
type alias Model =
    { width : Float, height : Float }


initialModel : Model
initialModel =
    { width = 0, height = 0 }


type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
```

The model is straight forward. Although `GotInitialViewport` and `Resize` look different, they both involve dealing with two `Float`s.

I don't really like how this looks. Maybe it would have been cleaner to just do it through [JavaScript interop](https://dev.to/kristianpedersen/30daysofelm-day-8-data-from-js-and-auto-reload-1o4h)?

## 3.2. Main and subscription

```elm
main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err err ->
                    NoOp

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize ( toFloat w, toFloat h ))
```

That's a pretty chunky main function compared to what I've seen before.

When the task `handleResult` is done, it will return one of those two `Cmd Msg`s in the `let` statement.

## 3.3. Update

```elm
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )
```

`Cmd.none` just seems like it could be implicit instead, although I guess Elm favors explicitness a lot more than I'm used to. 

It adds a bit extra overhead to me as a beginner, but I guess it can be nice to see `Cmd.none` at a glance.

Again, I don't like my double approach, where I get the width and height two different ways: through a `vp` variable, and through a `( w, h )` tuple. It just feels wrong.

## 3.4. View

Just displaying some data. A nice ending to a confusing day:
```elm
view : Model -> Html Msg
view model =
    div []
        [ text
            ("The width is "
                ++ (model.width |> String.fromFloat)
                ++ "px, and the height is "
                ++ (model.height |> String.fromFloat)
                ++ "px"
            )
        ]
```

# 4. Conclusion

This is one case where I don't immediately see the benefit in doing it the Elm way, rather than just doing it through JavaScript interop, using `window.eventListener`.

I definitely need to re-read the [Browser.Dom](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom) and [Task](https://package.elm-lang.org/packages/elm/core/latest/Task) documentation.

What I also need is a good night's sleep. I woke up too early, and I'm noticing the negative effects on my thinking and mood. I've been through frustrating learning moments before, so I'll get through this one as well.

See you tomorrow!