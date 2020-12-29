This is day 13 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Code/demo: https://ellie-app.com/bWyj9j52r9ca1

# Background

Yesterday's project was about finding the next number with the same number of 1 bits as the current number `n`.

42 (101010) -> 44 (101100)
43 (101011) -> 45 (101101)
44 (101100) -> 49 (110001)
45 (101101) -> 46 (101110)
...

As you can see, the results jump up and down a bit, and I wanted to visualize it within a given range.

I've seen [terezka/line-charts](https://github.com/terezka/line-charts) referenced a few times, so I just went with that one.

Today is a lazy day, which can be nice sometimes. Below is the new part of the code, with hardcoded numbers, while the rest is described in [yesterday's project](https://dev.to/kristianpedersen/30daysofelm-day-12-elm-binary-4ijc):

```elm
getNextNumbersFromRange : List Point
getNextNumbersFromRange =
    List.range 0 100
        |> List.map
            (\index ->
                { x = index |> toFloat
                , y =
					-- This is the part that shows the data
                    getNextNumberWithSame1Bits index
                        |> binaryToInt
                        |> toFloat
                }
            )


type alias Point =
    { x : Float, y : Float }


chart : Html msg
chart =
    LineChart.view2
        .x
        .y
        -- First line
        getNextNumbersFromRange
        -- Second line
        (List.range
            0
            100
            |> List.foldl
                (\val acc ->
					-- Only add index to the accumulator if the number is divisible by 10
                    if modBy 10 val == 0 then
                        val :: acc

                    else
                        acc
                )
                []
            |> List.map toFloat
            |> List.map
                (\v ->
                    { x = v
                    , y = v
                    }
                )
        )


view : Model -> Html Msg
view model =
    div [] [ chart ]
```

