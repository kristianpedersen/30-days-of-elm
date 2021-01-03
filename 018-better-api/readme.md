This is day 18 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

# About today's project

With some excellent help along the way, I've finally decoded some JSON from my Python backend in Elm, and deployed it:

Demo: 

Repo: 

Writing down and sharing my learning experience has been a great decision. Just look at the level of encouragement and helpfulness I got on [yesterday's post](https://dev.to/kristianpedersen/30daysofelm-day-17-i-decoded-some-json-4na5).

Just like before, Bukkfrig's comments and code really help make sense of things. Thank you so much!

# Ideas

Now I can finally start thinking about what to do with this data. Some ideas:
* A wall of digital clocks, showing at which time a planet's light was emitted. In other words, how far back in time are you seeing when observing the planet? Here's a good starting point for that: https://guide.elm-lang.org/effects/time.html

* A simplified view of the planets' orbits to see how they align. I think just having circular orbits with equal distances would be the best approach for visualization purposes.

* Input that allows you to set a date, and see how the planets were aligned on a given date.

Of course, there's an endless amount of ideas out there, but I've learned to keep it as simple as possible.

# 1. Connecting the front-end and back-end

When the Python server is started, it provides two URLs:
1. `localhost:5000` -> Serve `index.html`
2. `localhost:5000/info` -> JSON API

Beforehand, I compile `Main.elm` into `main.js`, which is referenced by `index.html`.

You can read more about all the Python code, and the deployment process in [my post from day 9](https://dev.to/kristianpedersen/30daysofelm-day-9-astronomy-data-from-python-in-elm-deployment-difficulties-2i47).

The code hasn't changed much, but I did improve the data structure it returns.

The previous API used the planet name as the key. I never liked this approach, but I kept it because:
1. I couldn't figure out how to use lists or dictionaries in my Python function's return code. The answer was `return json.dumps(planet_info)`
2. I figured it would be a good exercise, since I'll probably need to deal with poorly formatted data in the future.

After reading Bukkfrig's comments yesterday, I switched to a more generic structure, which is a lot nicer to work with:

Before:

```json
{
    "Mercury": {
        "lightMinutes": 1.2,
        "xyz": [3.4, 5.6, 7.8]
    },
    ...
}
```

After:

```json
{[
    {
        "name": "Mercury", 
        "lightMinutes": 1.2, 
        "xyz": [3.4, 5.6, 7.8]
    }, 
    ...
]}
```

# 2. Code

## 2.1 Imports, main and subscriptions

Again, the first line gets added automatically by `elm-format`.

Exposing everything is probably bad practice, but I'm giving myself beginner's permission.

```elm
module Main exposing (Model(..), Msg(..), Planet, init, main, planetDecoder, planetRequest, subscriptions, update, view, viewPlanet, viewPlanets)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, float, list, map3, string)
```

We've seen the `main` function before. I'm wondering why we even need to specify subscriptions, since they're not being used anywhere as far as I can tell:

```elm
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
```

## 2.2 Model

```elm
type Model
    = Failure String
    | FirstClick
    | Loading
    | Success (List Planet)


init : () -> ( Model, Cmd Msg )
init _ =
    ( FirstClick, Cmd.none )
```

Most times, the model has just been a record of a few strings or numbers.

Now it describes 4 different states of our front-end.

A `Failure` with bring with it an error message, the two next ones have no data associated with them, and a `Success` includes a list of planets.

`init` looks a bit weird, but I just copied it from [the official guide](https://guide.elm-lang.org/effects/json.html).

As you'll see later, the `FirstClick` message tells the `view` function to show a button.

## 2.3 Requests and planetDecoder

```elm
fetchPlanets : Cmd Msg
fetchPlanets =
    Http.get
        { url = "info"
        , expect = Http.expectJson PlanetRequest (Json.Decode.list planetDecoder)
        }


type alias Planet =
    { name : String
    , lightMinutes : Float
    , xyz : List Float
    }


planetDecoder : Decoder Planet
planetDecoder =
    map3 Planet
        (field "name" string)
        (field "lightMinutes" float)
        (field "xyz" (Json.Decode.list float))
```

The `Http.get` part is kind of tricky. To be honest, I just copied and pasted it, but here's my understanding of it:

1. `Http.get` needs a record with a URL and an [Expect msg](https://package.elm-lang.org/packages/elm/http/latest/Http#Expect).
2. The URL is simple enough. In this case it's relative, so it will work both locally, and when deployed.
3. The `Expect msg` is more complex. Let's look at it from Elm's perspective, and imagine we're working at the JSON restaurant:
   1. `Http.ExpectJson`: There's an incoming JSON order.
   2. `PlanetRequest`: The order should be marked with the name "PlanetRequest".
   3. `Json.Decode.list PlanetDecoder`: To make this order, we need a few planet decoders ready.

As the type signature shows, `fetchPlanets` is a `Cmd Msg`, which the Elm runtime knows how to perform.

The type alias describes what an Elm planet is, and the decoder describes what a JSON planet is.

## 2.4 Update

```elm
type Msg
    = GetPlanets
    | PlanetRequest (Result Http.Error (List Planet))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetPlanets ->
            ( Loading, fetchPlanets )

        PlanetRequest result ->
            case result of
                Ok planetData ->
                    ( Success planetData, Cmd.none )

                Err errorMessage ->
                    ( Failure (errorMessage |> Debug.toString), Cmd.none )
```

The update functions messages tell us what it can receive:

1. `GetPlanets`: A simple message that sends a `Loading` message, and fetches the planets from the Python API.
2. `PlanetRequest result`: This is whatever is returned from the `fetchPlanets` function.

The result is either `Ok` or `Err`, and both of these messages have an associated variable with them: https://package.elm-lang.org/packages/elm/core/latest/Result

I guess one can say that the `Success` and `Failure` messages now become part of the model, which we can see in the view function.

## 2.5 View

This could all be represented in a single view function, but I'm going by Bukkfrig's example, and splitting it up a bit.

I enjoy reading code like this. It's easier to know what I'm looking at, and it provides a flexible setup.

The three function here describe:
1. How to show one planet
2. How to show all the planets from the model
3. The view function itself, which reads nicely as a high-level overview

```elm
viewPlanets : Model -> Html Msg
viewPlanets model =
    case model of
        FirstClick ->
            button [ onClick GetPlanets ] [ text "Get planets" ]

        Loading ->
            text "beep boop lol"

        Success planetData ->
            div []
                [ button [ onClick GetPlanets, style "display" "block" ] [ text "Refresh" ]
                , div [] <| List.map viewPlanet planetData
                ]

        Failure errorMessage ->
            div []
                [ button [ onClick GetPlanets ] [ text "Try Again!" ]
                , p [] [ text ("Error message: " ++ errorMessage) ]
                ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "It's planet time" ]
        , viewPlanets model
        ]
```

### 2.5.1 Show one planet

Initially, I had it written this way:

```elm
viewPlanet : Planet -> Html Msg
viewPlanet { name, lightMinutes } =
    div []
        [ h1 [] [ text name ]
        , p [] [ text ((lightMinutes |> String.fromFloat) ++ " light minutes away") ]
        ]
```

However, instead of `{ name, lightMinutes, xyz }`, we could have written just `planet`. 

Inside `viewPlanet` we would then need to write `planet.name` and `planet.lightMinutes`:

```elm
viewPlanet : Planet -> Html Msg
viewPlanet planet =
    div []
        [ h1 [] [ text planet.name ]
        , p [] [ text ((planet.lightMinutes |> String.fromFloat) ++ " light minutes away") ]
        ]
```

I think the last one is easier to read, since I know where `name` and `lightMinutes` come from immediately. When scanning the body of the code, I can quickly see what's coming from the `Planet` argument.

The first example is fine, since the type annotation lets me know what these things are coming from, but I think the last example is better.

## 2.5.2 Show all planets (or error)

This function doesn't only show planets, so I think it should be renamed. Maybe `viewModel` or `viewCurrentState`?

```elm
viewPlanets : Model -> Html Msg
viewPlanets model =
    case model of
        FirstClick ->
            button [ onClick GetPlanets ] [ text "Get planets" ]

        Loading ->
            text "beep boop lol"

        Success planetData ->
            div []
                [ button [ onClick GetPlanets, style "display" "block" ] [ text "Refresh" ]
                , div [] <| List.map viewPlanet planetData
                ]

        Failure errorMessage ->
            div []
                [ button [ onClick GetPlanets ] [ text "Try Again!" ]
                , p [] [ text ("Error message: " ++ errorMessage) ]
                ]
```

I really like how easy this is to read. If this is the first click, show a button. If it's loading, show a nice little message, etc.

Inside the `Success planetdata` branch, we apply `viewPlanet` to each item in the `planetData` list, and fill up the `div`'s body. Nomnom.

As for the `Failure` branch, I'm very surprised that the [official JSON guide](https://guide.elm-lang.org/effects/json.html) doesn't show how to display error messages like I've done. It's very helpful.

### 2.5.3 View

```elm
view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "It's planet time" ]
        , viewPlanets model
        ]
```

Nice and simple. Here we can fill in other stuff, move `viewPlanets` up or down, or reuse it.

# 3. Things others say about JSON in Elm

There's a lot of talk about JSON in Elm, and I can see why.

Just looking at my code, I think it's nice to see a proper description of the data.

`undefined` and `NaN` seem like more and more of a distant memory.

## 3.1 JSON in Elm is different

It's weird how something I didn't think much of in JavaScript can be a headache in Elm. The other Elm concepts have so far been a bit easier, in my experience.

However, with some perserverance and willingness to ask for help, it will click eventually.

## 3.2 JSON decoders in Elm are an important concept

The second thing I've heard people say are things like these:

> I have heard a bunch of stories of folks finding bugs in their server code as they switched from JS to Elm. The decoders people write end up working as a validation phase, catching weird stuff in JSON values. So when NoRedInk switched from React to Elm, it revealed a couple bugs in their Ruby code!

https://guide.elm-lang.org/effects/json.html

> Writing decoders that can fail, might seem a bit scary. But failing decoders have helped me discover bugs in the backend code, which I never noticed in the JavaScript apps using those endpoints, specifically because the decoders I wrote failed whenever the data from the server didn't line up with my expectations

https://functional.christmas/2019/8

> I think for me, understanding JSON decoding is what got me to finally understand Elm and Haskell.

https://dev.to/wolfadex/comment/1a07g

> It's one of those things that gives your app a rock solid foundation and prevents stupid runtime exceptions. It's part of what could make you considerably happier than the average JS/TS developer in the long run 😄

https://dev.to/kodefant/comment/1a03m

# 4. Conclusion

This has been the most challenging part of learning Elm so far, but I made it through. Looking at the resulting code, it's not too bad, but it's quite different from JavaScript.

The help I've gotten along the way has been phenomenal, which I think is partly because I shared my thought process and code, rather than just asking "How do JSON decoders work?".

I'm also glad I didn't just give up. This was helped by the fact that any Elm code or knowledge counts in my daily challenge.

If I just do something for 10 minutes and write about it, that counts. This forgiving approach has been very good when I've had bad or busy days, and has proven to be effective and sustainable.

Tomorrow I think I'll do something more relaxing, but who knows? :) Thanks for reading, and see you tomorrow!