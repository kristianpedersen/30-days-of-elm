This is day 17 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

# About today's project

Code/demo: https://ellie-app.com/bYbhrKjmhJCa1

![Screenshot of text showing planet distances](https://dev-to-uploads.s3.amazonaws.com/i/4sh8sve9hzlte77sb4km.png)

In today's project, I was finally able to decode some (hardcoded) JSON!

[Bukkfrig's comment on yesterday's post](https://dev.to/bukkfrig/comment/19p74) saved the day, so thanks!

I'm happy with today's progress, and have other plans for the evening, so I'll leave the Python backend integration for later.

Some of the code here could be more elegant, but I'll save that for another day.

# 1. Describing the data

An individual planet in my JSON looks like this:

```json
"Jupiter":{
        "lightMinutes":49.561547588282494,
        "xyz":[-15.160997437594864,35.36776769042324,86.01557267383876]
    }
```

As you can see, the data and descriptions match:

```elm
type alias Planet =
    { lightMinutes : Float, xyz : List Float }

planetDecoder : String -> Decoder Planet
planetDecoder planetName =
    field planetName
        (map2 Planet
            (field "lightMinutes" float)
            (field "xyz" (list float))
        )
```

# 2. Presenting the data (or the error)

```elm
planetDiv : String -> Planet -> Html msg
planetDiv p { lightMinutes, xyz } =
    div []
        [ h1 [] [ text p ]
        , text ((lightMinutes |> round |> String.fromInt) ++ " light minutes away")
        , br [] []
        , div [] <| (xyz |> List.map (\n -> text ((n |> String.fromFloat) ++ ", ")))
        ]


showPlanetOrError : String -> Html msg
showPlanetOrError planetName =
    case
        decodeString (planetDecoder planetName) hardcodedData
    of
        Ok planet ->
            planetDiv planetName planet

        Err err ->
            pre []
                [ text "Oops: "
                , br [] []
                , text ("    " ++ Debug.toString err)
                ]
```

`planetDiv` is a pretty basic function that just returns an `Html msg`.

`showPlanetOrError` either shows the `planetDiv`, or logs out the error message.

# 3. Showing all planets

This kind of hardcoded solution takes me back to when I first learned JavaScript. Oh man. :D

```elm
main : Html msg
main =
    div [] <|
        List.map (\planet -> showPlanetOrError planet)
            [ "Sun"
            , "Mercury"
            , "Venus"
            , "Mars"
            , "Jupiter"
            , "Saturn"
            , "Uranus"
            , "Neptune"
            , "Pluto"
            ]
```

# 4. Summary

JSON in Elm is tricky, and I'll probably make a few more mistakes, but the community is really helpful.

I'm really thankful and motivated. Thanks, everyone!