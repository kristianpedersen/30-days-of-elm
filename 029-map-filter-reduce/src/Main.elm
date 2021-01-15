module Main exposing (..)

-- Try running these in the REPL: https://dev.to/kristianpedersen/30daysofelm-day-26-inspecting-values-with-debug-log-debug-tostring-and-the-repl-3k4k#4-starting-and-using-the-repl


addOneToEach =
    List.map (\number -> number + 1) [ 1, 2, 3 ]


addOneToEach_ =
    [ 1, 2, 3 ] |> List.map (\number -> number + 1)


getIndex =
    [ "JavaScript", "Elm", "Scratch" ]
        |> List.indexedMap
            (\index language ->
                (index |> Debug.toString) ++ ": " ++ language
            )


threeOrLess =
    [ 1, 2, 3, 4, 5 ] |> List.filter (\number -> number <= 3)


sum1 =
    List.sum [ 1, 2, 3, 4, 5 ]


sum2 =
    List.sum (List.range 1 100)


sumFoldl =
    [ 1, 2, 3, 4, 5 ] |> List.foldl (\item total -> total + item) 0


product =
    List.product (List.range 1 5)
