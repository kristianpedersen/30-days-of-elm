This is day 16 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Thanks to Wolfgang Schuster @wolfadex, for [helping me out yesterday](https://dev.to/wolfadex/comment/19o6c)!

Also, thanks to Sephi at the [Elm Slack](https://elmlang.herokuapp.com/) for helping me out today!

# Table of contents

- [Table of contents](#table-of-contents)
- [1. Simplifying Main.elm](#1-simplifying-mainelm)
- [2. Hardcoded JSON with one field](#2-hardcoded-json-with-one-field)
- [3. Decoding a person object with fields of different types (name, age)](#3-decoding-a-person-object-with-fields-of-different-types-name-age)
- [4. Summary](#4-summary)

# 1. Simplifying Main.elm

I couldn't figure out how to deal with JSON yesterday, so I thought it would be a good idea to step back a bit.

Yesterday, I simply copied my project from day 9, [Astronomy data from Python in Elm](https://dev.to/kristianpedersen/30daysofelm-day-9-astronomy-data-from-python-in-elm-deployment-difficulties-2i47).

This is a project I want to work more on, but its `Main.elm` is nearly 100 lines of code, with subscriptions, cmd msgs, and other stuff needed to communicate with an external API. 

Nothing crazy, but it's enough to get in my way when learning a new concept.

Here's a very minimal starting point that I think will serve me better today:

```elm
module Main exposing (main)

import Html exposing (div, text)


main =
    div [] [ text "hi" ]
```

The first line gets added automatically by `elm-format`. The standard model-update-view architecture with `Browser.sandbox` is great, but I don't need it when learning the very basics of decoding JSON.

# 2. Hardcoded JSON with one field

Here's a very basic (and silly) example of decoding a JSON object with one field.

```elm
module Main exposing (main)

import Dict exposing (Dict)
import Html exposing (div, text)
import Json.Decode exposing (..)


name =
    """ {"name": "Kristian"} """


getName =
    field "name" string


main =
    div []
        [ text
            (case decodeString getName name of
                Ok result ->
                    result

                Err e ->
                    e |> Debug.toString
            )
        ]
```

The triple quotes are neat - they're usually used for multi-line strings, but by using them here, I don't have to put backslashes before every `"` character.

There are two parts to decoding a JSON object. First, you describe what Elm should get, and then another function does it.

The main bit of code here is `decodeString getName name`.

Its full name is [JSON.Decode.decodeString](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#decodeString), and it's what you want for converting anything to a string, I guess. :)

I think this approach without an external API would be a nicer introduction to JSON decoding, as several people have told me that they also struggled a bit to understand it to begin with.

# 3. Decoding a person object with fields of different types (name, age)

```elm
person : String
person =
""" 
    {
        "person": {
            "name": "Kristian",
            "age": 31
        }
    }
"""
```
This is more complex, but it's also pretty easy to work with.

First, we describe the fields to Elm before doing anything:

```elm
howToGetName : Decoder String
howToGetName =
    field "person" (field "name" string)


howToGetAge : Decoder Int
howToGetAge =
    field "person" (field "age" int)


howToGetPerson : Decoder Person
howToGetPerson =
    map2 Person
        (field "name" string)
        (field "age" int)


type alias Person =
    { name : String
    , age : Int
    }
```
When I wrote this, I just pasted the `map2` line from the [JSON guide](https://guide.elm-lang.org/effects/json.html). It doesn't reference the "person" field, so it doesn't work.

> `Failure "Expecting an OBJECT with a field named 'name'" <internals>`

`map2` is not the same as `List.map`, but the way! Its real name is `Json.Decode.map2`.

Let's compare their type signatures:

> map : (a -> b) -> List a -> List b

> map2 : (a -> b -> value) -> Decoder a -> Decoder b -> Decoder value

I guess `map2` takes two values `a` and `b` and returns a value. Then it returns two decoders and turns them into one, or maybe I'm wrong.

Anyway, here's how they're handled. I went for a pretty generic solution, with a `Debug.toString` that (I think) will convert anything to a string, even strings.

```elm
getInfo : String -> Decoder a -> String
getInfo sourceJSON decoder =
    case decodeString decoder sourceJSON of
        Ok result ->
            result |> Debug.toString

        Err e ->
            e |> Debug.toString


main : Html msg
main =
    div []
        [ text (getInfo person howToGetName)
        , text (getInfo person howToGetAge)
        , text (getInfo person howToGetPerson)
        ]

```

When I do get the last line working, there's one thing I would like to improve. `getInfo` converts the entire result to a string, but I might want to deal with the individual fields.

```elm
getPersonInfo : String -> Decoder Person -> String
getPersonInfo sourceJSON decoder =
    case decodeString decoder sourceJSON of
        Ok { name, age } ->
            name ++ ", " ++ (age |> String.fromInt)

        Err e ->
            e |> Debug.toString


main : Html msg
main =
    div []
        [ text (getInfo person howToGetName)
        , text (getInfo person howToGetAge)
        , text (getPersonInfo person howToGetPerson)
        ]
```

Instead of saying `Ok result`, I'm destructuring `result` as `Ok { name, age }`. It does compile, so I think I'm on to something.

# 4. Summary

That's all for today. I feel like I've taken some good steps towards being able to decode [my astronomy JSON](https://dev.to/kristianpedersen/30daysofelm-day-9-astronomy-data-from-python-in-elm-deployment-difficulties-2i47), and do some fun things with it.

I'm very happy I decided to start from the simplest possible code, rather than dealing with an external API and all the extra code that forces me to keep track of.

See you tomorrow!