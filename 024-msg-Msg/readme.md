This is day 24 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

My original intention was to work further on yesterday's UI, but I kept getting weird errors about `Msg` and `msg` and weird type annotations.

Today's project is just me finally trying to get my head around `Msg` and `msg`.

# Table of contents

- [Table of contents](#table-of-contents)
- [1. `msg` vs `Msg` (you can choose your own names, too)](#1-msg-vs-msg-you-can-choose-your-own-names-too)
  - [1.1. `Msg` vs `Msg Float`, `Msg String`, etc.](#11-msg-vs-msg-float-msg-string-etc)
  - [1.2. `Float -> Msg`](#12-float---msg)
  - [1.3. `msg` is just a placeholder](#13-msg-is-just-a-placeholder)
- [2. Summary](#2-summary)

# 1. `msg` vs `Msg` (you can choose your own names, too)

I've seen `msg` and `Msg` all over the place, and I've always thought this ambiguous convention was really confusing and annoying as a beginner. 

You can of course name these whatever you want. I took [elm-lang.org's clock example](https://elm-lang.org/examples/clock) and mofified it, by changing `Msg` to `MsgForYouMyDude` and `Svg msg` to `Svg abc`. In the update function, I changed `msg model` to `massage supermodel`: https://ellie-app.com/c3r3mdDh3YRa1

However, I see these exact names everywhere, so I think it's probably a good idea to just learn them, so what's going on?

Rupert's example made me get a feel for it: https://discourse.elm-lang.org/t/html-msg-vs-html-msg/2758/2

```elm
view : Html msg
view = div [] []
```

vs. 

```elm
type Msg = Click

view : Html Msg
view = div [ onClick Click ] []
```

The first one (`msg`) has no event. It could if it wanted to, but it's too busy vaping, watching documentaries about ancient civilizations and UFOs, and listening to 432 Hz music.

The last one (`Msg`) deals with an important message that I've defined, which will get sent to the `update` function.

## 1.1. `Msg` vs `Msg Float`, `Msg String`, etc.

The simplest one to understand for me is `Msg`. The one with the capital letter is the one you make yourself. This describes different messages that can be picked up by your update function.

```elm
type Msg
    = NewBoardSize Float
    | NewAnimationSpeed Float
```

Now how do we get the `Float` value?

My current understanding is that this is how you deal with continuous events in Elm:

* **Continuous events, like input**: Get MyMessage (uppercase) and a value of a certain type. Input events return a string (`event.target.value` in JavaScript terms).
* **Momentary events, like click:** Something happened. No value required.

You can however have extra values along with your click events as well, Joel told me.

## 1.2. `Float -> Msg`

I hadn't seen this before that I could remember, but I was getting an error about how my slider was receiving an `Msg` instead of a `Float -> Msg`.

Normally, I think this would have been caught by Elm's type inference, but my slider attribute type annotation was causing problems.

joelq was kind enough to help me out on Slack:

* Before: https://ellie-app.com/c3mJCmb9Mqta1
* After: https://ellie-app.com/c3nw4rHyftKa1

To be fair, I could have found it right there in the [elm-ui slider documentation](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element-Input#slider). :)

The only two changes were as follows:
1. `SliderAttribute`'s message field was changed from `message : Msg` to `message: Float -> Msg`
2. The createSlider function was changed from `createSlider : Model -> SliderAttributes -> Element msg` to `createSlider : Model -> SliderAttributes -> Element Msg`

The compiler highlights the last error pretty well, but even after reading up on this subject and getting help, my brain just sees `Msg` and `msg` and thinks they're the same thing.

## 1.3. `msg` is just a placeholder

My conclusion is that `msg` can basically just be anything. So why isn't the convention just `a`, `value`, `yourTypeHere` or something similar? I don't know.

Again, here's from Joel in the thread I linked to above:

> While the lowercase msg variable name has good intentions of communicating “the type that would go here fills the role of a message (definition 1)”, my experience is that many people read it as “the type that would go here is going to be a Msg (definition 2)”.

> Personally, I’ve started using Html a in my own code rather than Html msg to avoid this confusion

https://discourse.elm-lang.org/t/html-msg-vs-html-msg/2758/4

# 2. Summary

I realize `Msg` and `msg` have pretty much become standards in Elm, and you *will* see them in most Elm code, so I don't know if it's a good idea to change at this stage.

As a beginner, it would have been helpful to have a separate `Msg` vs. `msg` section in the guide. 

By the way, you also have things like this:

```elm
update : Msg -> Model -> Model
update msg model = ...
```

Here, `msg` is a reference to `Msg`, but it's just a local variable name, so it could have been a reference to any type. It's not a `msg` like `Html msg`, but I guess it would refer to the `Msg` in `Html Msg`?

See you tomorrow! :D