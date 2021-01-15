This is the last day of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)!

Today is less about code, and more about how this whole project went.

In short, the 30 days have been successful. I'm now at a place where I know enough basics to make something, and be able to ask good questions when I get stuck.

Writing these posts takes a lot of time, so I'm looking forward to putting more energy into some personal projects that I want to to re-make and improve. 

Looking at all the comments and help I've gotten, I can safely say that the Elm community is extremely helpful and beginner-friendly. Hopefully I can thank some of the commenters in person at a conference or meetup in the future! :)

I still think it would be nice to write occasionally to keep the momentum going, and get the benefits in terms of deeper thinking and great feedback. I'll think about how to approach this during the weekend.

- [1. Why Elm?](#1-why-elm)
- [2. Personal top 5 projects from these 30 days](#2-personal-top-5-projects-from-these-30-days)
	- [2.1. Day 5: "Lights Out" game](#21-day-5-lights-out-game)
	- [2.2. Day 6: Accessible background colors](#22-day-6-accessible-background-colors)
	- [2.3. Day 9: Deploying a Python backend + Elm frontend](#23-day-9-deploying-a-python-backend--elm-frontend)
	- [2.4. Day 15 to 19: From struggling with JSON to decoding JSON from Python](#24-day-15-to-19-from-struggling-with-json-to-decoding-json-from-python)
	- [2.5. Day 24: Html Msg vs Html msg](#25-day-24-html-msg-vs-html-msg)
- [3. Things that I like about Elm](#3-things-that-i-like-about-elm)
	- [3.1. If it compiles, it works](#31-if-it-compiles-it-works)
	- [3.2. Types](#32-types)
	- [3.3. elm-format](#33-elm-format)
	- [3.4. Syntax](#34-syntax)
	- [3.5. Immutability](#35-immutability)
- [4. Things I don't like about Elm](#4-things-i-dont-like-about-elm)
	- [4.1. Some parts of the documentation lack examples](#41-some-parts-of-the-documentation-lack-examples)
	- [4.2. Can't mix Floats and Ints](#42-cant-mix-floats-and-ints)
	- [4.3. Some things are harder than expected](#43-some-things-are-harder-than-expected)
- [5. Learning strategy](#5-learning-strategy)
	- [5.1. Things that worked really well](#51-things-that-worked-really-well)
		- [5.1.1. Setting the bar low](#511-setting-the-bar-low)
		- [5.1.2. Writing](#512-writing)
		- [5.1.3. Not following a set structure was mostly really good](#513-not-following-a-set-structure-was-mostly-really-good)
	- [5.2. Things that could have been better](#52-things-that-could-have-been-better)
		- [5.2.1. Not taking enough breaks](#521-not-taking-enough-breaks)
		- [5.2.2. Coding and writing in one day is a lot of work](#522-coding-and-writing-in-one-day-is-a-lot-of-work)
- [6. What's next?](#6-whats-next)

# 1. Why Elm?

I first learned JavaScript in 2016, thanks to [Daniel Shiffman's p5.js videos](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6ZiZxtDDRCi6uhfTH4FilpH) about visualizing mathematics and physics, and making cool animations.

Already back then, I saw some Elm code, but it looked weird to me: `case msg of`, square brackets instead of HTML templates, commas at the *beginning* of each line, no side effects. All that code just to increment a counter? No, thanks.

Then in late 2020, after having learned React for a month or so, I found myself struggling with my 100th runtime exception that day. 

I'm not smart enough to write complex JavaScript without shooting myself in the foot, and I remembered Elm's promise of 0 runtime exceptions, and here I am now.

Sure, it would have made sense to learn TypeScript, and maybe incorporate immutable.js and some other libraries, but this diagram helped convince me:

![Screenshot showing Elm's ecosystem compared to JavaScript](https://dev-to-uploads.s3.amazonaws.com/i/xcciqld4r9t8xi2dy7gf.png)

Screenshot from https://www.youtube.com/watch?v=kEitFAY7Gc8 (slightly outdated)

Somehow that same day, I stumbled upon [@larsparsfromage](https://twitter.com/larsparsfromage)'s #100daysofhaskell challenge, and decided to do a 30 day Elm challenge with detailed write-ups.

# 2. Personal top 5 projects from these 30 days

I'm happy with all of them, as they were all part of the journey.

Here's the full list: https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2

With that said, some were a bit more entertaining or educational than others:

## 2.1. Day 5: "Lights Out" game

This was my first Elm project where I was both happy with my code, and found myself having fun with the end result.

You have a 5x5 grid of checkboxes. When you toggle one, its neighbors also get toggled. The goal is to clear the board.

https://dev.to/kristianpedersen/30daysofelm-day-5-lights-out-game-4b16

## 2.2. Day 6: Accessible background colors

I was happy about how accessible this topic was (shouldn't come as a surprise, I guess).

A slider generates a color palette, which is represented as squares. Each square then gets its text colored white or black text, depending on which accessibility standard you choose.

There's just something about moving a slider and have so many things happen!

https://dev.to/kristianpedersen/30daysofelm-day-6-accessible-background-colors-29ao

## 2.3. Day 9: Deploying a Python backend + Elm frontend

I had previously made a small Python backend, which fetches astronomy data.

Getting this up and running, and have Elm display the data was amazing!

https://dev.to/kristianpedersen/30daysofelm-day-9-astronomy-data-from-python-in-elm-deployment-difficulties-2i47

## 2.4. Day 15 to 19: From struggling with JSON to decoding JSON from Python

Decoding JSON was tough, but by asking for help and not giving up, I got it working!

I also learned some lessons about making things as simple as possible, which I'm very happy about.

* [15: Struggling with JSON](https://dev.to/kristianpedersen/30daysofelm-day-15-struggling-with-json-4hhm)
* [16: Struggling slightly less with JSON](https://dev.to/kristianpedersen/30daysofelm-day-16-struggling-slightly-less-with-json-38g7)
* [17: I decoded some JSON!](https://dev.to/kristianpedersen/30daysofelm-day-17-i-decoded-some-json-4na5)
* [18: Decoding JSON from a Python backend](https://dev.to/kristianpedersen/day-18-decoding-json-from-a-python-backend-4010)

## 2.5. Day 24: Html Msg vs Html msg

Finally decided to get to the bottom of this mystery, and also got a sense of types vs type aliases.

`Html msg`: There no event.
`Html Msg`: There's an event, and it might have some data associated with it.

I still don't like how similar these two look, so I prefer using `Html a` instead of `Html msg`.

https://dev.to/kristianpedersen/30daysofelm-day-24-msg-vs-msg-2n1h

# 3. Things that I like about Elm

I'm sure there are things that I've forgotten or taken from granted, but here are some things that I've really liked.

## 3.1. If it compiles, it works

I've had 0 runtime exceptions, which is obviously one of the biggest benefits. In my last React project, everything compiled fine, I clicked around to test everything, and suddenly got a runtime exception out of nowhere.

In Elm, I still get lots of compile-time errors, but I really don't mind. They make it feel like I'm doing pair programming with someone more experienced, and actually getting help.

That feeling when it finally compiles and you know everything is going to work: 10/10

## 3.2. Types

Coming from JavaScript and some Python, the static typing was weird at first, but they've forced me to think more deeply about what I'm trying to do. Also, types result in better error messages.

Type aliases are very convenient, and types is something I've only recently started to understand the power of.

I really like how the `Msg` type provides a great overview of an application's possible actions, and I can imagine this benefit holds true with other custom types as well.

I'm very excited by the thought of [making impossible states impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8), so I'm looking forward to working more with types.

## 3.3. elm-format

At first, some of the formatting threw me off, but now I mostly like it.

Practially all Elm code uses `elm-format`, which sounds restrictive at first, but it's one less thing to worry about, and reading other people's code is made easier.

Things can get a bit messy when doing anonymous functions with `let` blocks, but in those cases I prefer extracting things into separate functions anyway.

Reading code is quicker with equal signs being followed by a newline, and I now believe that commas do indeed belong at the beginning of the line.

## 3.4. Syntax

At first, the view functions in Elm looked insane. All those empty square bracket pairs nearly made me cry.

Then you learn that attributes go in the first one, and content goes in the other one. Not bad after all!

The pipeline operator `|>` feels nice and familiar, coming from JavaScript's chained function calls.

I like how function definitions have less "noise", along with the fact that all functions return something.

**JavaScript:**

`function double(x) {return x * 2}` 
or 
`const double = x => x * 2`

**Elm:**

`double x = x * 2`

Let's read these out loud:

1. "function double parenthesis x closing parenthesis curly brace return x times two closing curly brace"

2. "const double equals x equals is greater than x times two"

3. "double x equals x times two"

## 3.5. Immutability

In JavaScript, I have to remember to explicitly make copies of things, and make sure I'm [not just doing shallow copies](https://www.freecodecamp.org/news/copying-stuff-in-javascript-how-to-differentiate-between-deep-and-shallow-copies-b6d8c1ef09cd/#:~:text=shallow%20copying.,into%20how%20JavaScript%20stores%20values.), especially of nested objects. 

Having immutability built-in is a relief. Making copies is not a problem, as I'm already used to map, filter and reduce from JavaScript.

I like knowing that nothing external can make my functions do unexpected things.

# 4. Things I don't like about Elm

## 4.1. Some parts of the documentation lack examples

I know that `OnClick` is explained in the Elm Guide, but why not include a basic event example directly in the [`Html.Events` documentation](https://package.elm-lang.org/packages/elm/html/latest/Html-Events)? Switching to another tab feels unnecessary.

(The link to TodoMVC on that page doesn't work any longer, by the way.)

One example would be enough to get beginners going with events more easily:

```elm
module Main exposing (..)

import Browser
import Html exposing (button, div, input, p, text)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


init = { number = 0, userInput = "" }


type Msg
    = Increment
    | ReceivedInput String


update msg model =
    case msg of
        Increment ->
            { model | number = model.number + 1 }

        ReceivedInput input ->
            { model | userInput = input }


view model =
    div []
        [ button [ onClick Increment ] [ text (String.fromInt model.number) ]
        , input [ onInput ReceivedInput ] []
        , p [] [ text ("The model is: " ++ (model |> Debug.toString)) ]
        ]

```

Also, if I want to create a `canvas` element, how do I actually use it? How can I get its context? Is it supported in Elm? This is all I'm getting from the documentation:

> canvas : List (Attribute msg) -> List (Html msg) -> Html msg
Represents a bitmap area for graphics rendering.

Scrolling through [elm/html](https://package.elm-lang.org/packages/elm/html/latest/Html#h1), I would have expected to see examples when clicking on an entry.

Maybe experienced Elm devs prefer type annotations over examples, but I just want to know how to make something.

## 4.2. Can't mix Floats and Ints

Let's say some function returns an `Int`, and you want to add 0.1 to it:

```elm
doesntWork = (floor 1.1) + 0.1

works = (floor 1.1 |> toFloat) + 0.1
```

Error message:

>I need both sides of (+) to be the exact same type. Both Int or both Float.
3|   (floor 1.1) + 0.1
     ^^^^^^^^^^^^^^^^^
But I see an Int on the left and a Float on the right.
Use toFloat on the left (or round on the right) to make both sides match!

[There are reasons for this](https://github.com/elm/compiler/blob/master/hints/implicit-casts.md), but it's still a bit annoying.

## 4.3. Some things are harder than expected

This is just a consequence of how Elm is structured, so I'm not mad about it.

[On day 10](https://dev.to/kristianpedersen/30daysofelm-day-10-mouse-coordinates-1llo), I was puzzled by how much code was needed just to get mouse coordinates.

Then again, Elm is better suited for applications of a certain complexity. If I want to make a very quick prototype, I'll just use [Svelte](https://svelte.dev/).

# 5. Learning strategy

Next up, I want to examine my methodology for learning Elm. What worked, and what could have been done differently?

## 5.1. Things that worked really well

I'm happy to report that many things went well during this challenge! :D

### 5.1.1. Setting the bar low

This was a very successful hypothesis. 30 days of varying productivity is better than a week of divine hustle and blissful inspiration.

If I'm unmotivated or something comes up, I can still succeed by doing the absolute minimum imaginable.

If I'm motivated, I'll keep going because I want to, and end up raising the bar anyway.

Looking back, there were definitely some frustrating days, or days where I really didn't want to do anything.

Almost every time that happened, I told myself that 5 minutes of any Elm code or knowledge was okay, and I usually ended up spending an hour anyway.

Another effect of this was preserving momentum. Some of my most productive or insightful days were preceded by one or more difficult days.

### 5.1.2. Writing
There were two purposes behind the blogging:

1. Documenting what it's like to learn Elm, for someone with my experience. Maybe it could help other beginners?
2. Setting up a situation where I have to think more deeply about concepts and problems. I had several great a-ha moments and blind spot revelations while writing these blog posts.

The third consequence was unintended - amazing help and feedback.

The comments I've gotten on some of my posts have been astoundingly good. I wouldn't have gotten such good help by just asking.

I think people get motivated to help when they see someone really trying, who provides detailed information, thoughts and reflections.

Also, I think many programmers have this instinct of "by the way, you can also do it this much better way". For this reason, beginners shouldn't be shy about sharing their code.

> Cunningham's Law states "the best way to get the right answer on the internet is not to ask a question; it's to post the wrong answer."

- https://meta.wikimedia.org/wiki/Cunningham%27s_Law

### 5.1.3. Not following a set structure was mostly really good

I think some of the project ideas in the 30 day list are really cool, and I wouldn't be surprised if I end up working more on them. These wouldn't have been part of a pre-determined learning roadmap.

Not having to do a ton of stuff on low-motivation days was really beneficial. It meant that if I had a bad day, I wouldn't fall behind, which I think was crucial for motivation.

I do have this feeling that I should now learn how to make more "useful" stuff, along the traditional path. Knowing how `elm-spa` works, making a todo list, doing something with a database, etc.

However, I mostly think many of those things will emerge naturally as I work on increasingly complex projects.

## 5.2. Things that could have been better

Of course I did some things wrong - or as I like to say, I learned something.

### 5.2.1. Not taking enough breaks

At my previous job, I was often the one who said "Hey, let's go outside for 5 minutes and stretch!".

Now that I'm on my own, I'm a lot worse at taking regular breaks. I do go for a 1-2 hour walk every day, and I cook proper meals, but I often end up just grinding through lots of computer time, which often ends up not being that efficient anyway.

Unsurprisingly, I often have a-ha moments after I've been outside, talked with someone, or done something completely unrelated.

### 5.2.2. Coding and writing in one day is a lot of work

The writing has definitely helped a lot, and introduced me to some great people.

However, it does take a lot of time, and I found it a bit stressful. I'm the kind of person who can spend 10-15 minutes on just one sentence.

Sometimes, I would get into a nice flow with the coding, only to realize I needed to start writing soon.

Some 100 day challenges I've seen around just involve a paragraph or two, which sounds a lot more sustainable.

# 6. What's next?

My primary focus is on implementing a few hobby projects in Elm, and improving them. Other than that, some potential areas of interest are:

1. **Accessibility**. What are the different assistive technologies out there? What kinds of tests have to be passed? How do you avoid overloading users' working memory? The web should be for everyone.
2. **Making flexible designs that look good**. I just want to know how to make designs that look modern, are easy to change, and users don't even think about. I'm still stuck at using too many borders and computer colors.
3. **Data visualization**. Elm has some good tools for this, but [Observable](https://observablehq.com/@observablehq/user-manual) seems like a really nice environment for experimentation. For interactive installations, I now know how to [control TouchDesigner from Elm](https://dev.to/kristianpedersen/30daysofelm-day-27-using-websockets-ports-to-control-a-desktop-app-4b00)!
4. **Backend/cloud/IOT**: It would be cool to deploy a web page that displays serial port data from my Arduino, or some other external data. Elixir+Phoenix+LiveView seems really interesting, but I'm open to other options.
5. **Getting a job**. I'm happy to have gotten several interviews the past couple of months (Oslo, Norway), and they've been positive regarding background, projects, personality, willingness to learn, etc.<br>However, I lack experience (and probably certain skills aren't useful enough to employers yet). I'm waiting to hear back from many applications, but any advice is helpful. :)

Right now, I'm taking my first weekend off since mid-december. If you have any questions, comments, feedback or anything, I'm here. 

Thanks for joining me, and see you around!
\- Kristian