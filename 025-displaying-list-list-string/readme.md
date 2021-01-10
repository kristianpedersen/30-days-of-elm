This is day 25 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today we'll create a very basic chess board view from a 8x8 `List`.

This is the final result:


```
A8B8C8D8E8F8G8H8
A7B7C7D7E7F7G7H7
A6B6C6D6E6F6G6H6
A5B5C5D5E5F5G5H5
A4B4C4D4E4F4G4H4
A3B3C3D3E3F3G3H3
A2B2C2D2E2F2G2H2
A1B1C1D1E1F1G1H1
```
Demo/code: https://ellie-app.com/c3QTnvkpn7ha1

- [1. Creating a single row](#1-creating-a-single-row)
- [2. Creating a grid (list of rows)](#2-creating-a-grid-list-of-rows)
- [3. Creating a grid with chess position names (A1, A2, .. H8)](#3-creating-a-grid-with-chess-position-names-a1-a2--h8)
- [4. Refactoring: Named functions look nicer than long anonymous ones](#4-refactoring-named-functions-look-nicer-than-long-anonymous-ones)
- [5. Creating the view](#5-creating-the-view)

# 1. Creating a single row

This is easy in Elm:

```elm
List.range 1 8 -- [1, 2, 3, 4, 5, 6, 7 , 8]
```

If you want the list to contain something else, you can use `List.map`:

```elm
List.range 1 8 
    |> List.map (\item -> "lol") -- ["lol", "lol", "lol", "lol", "lol", "lol", "lol", "lol", ]
```

# 2. Creating a grid (list of rows)

Instead of having a list of numbers, we can imagine each number being replaced with a `List`:

```elm
verySimpleGrid : List (List Int)
verySimpleGrid =
    List.range 1 8 -- [1, 2, 3, 4, 5, 6, 7, 8]
        |> List.map (\number -> List.range 1 8)
        -- Each individual number in the previous list is replaced with [1, 2, 3, 4, 5, 6, 7, 8]
        -- [[1, 2, 3, 4, 5, 6, 7, 8], [1, 2, 3, 4, 5, 6, 7, 8], etc]
```

# 3. Creating a grid with chess position names (A1, A2, .. H8)

This was my initial approach:

```elm
letters : String
letters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


grid : List (List String)
grid =
    List.range 1 8
        |> List.map (\row -> List.range 1 8)
        |> List.indexedMap
            (\y row ->
                List.map
                    (\x ->
                        String.slice (x - 1) (x + 0) letters ++ String.fromInt (y + 1)
                    )
                    row
            )
        |> List.reverse
```

`letters` is one of my favorite hardcoded things I've done. Very nice!

The first two lines of the grid function are the same as before.

`List.indexedMap` works the same way as JavaScript's regular `Array.map`, except it's index first, and then element.

1. First, we're getting the Y index and its row (`List String`).
2. Then, using `List.map` on `row`, we get each X value.
3. The X coordinates should go from A to H. This is done with String.slice, which cuts from index1 up to (not including) index2.
4. The Y coordinates work as usual, except chess board have 1-based indexing.
5. The rows are reversed, so that A1 isn't at the top of the board.

# 4. Refactoring: Named functions look nicer than long anonymous ones

Looking at the code above, all that indentation is awkward to read, and none of the functions passed to `List.map` or `List.indexedMap` are reusable. 

I get shivers from anonymous functions that span more than one line. I'm feeling lazy today, but I'm doing this just so I can sleep well at night.

```elm
letters : String
letters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


singleCell : Int -> Int -> String
singleCell x y =
    String.slice (x - 1) (x + 0) letters ++ String.fromInt (y + 1)


chessRow : Int -> List Int -> List String
chessRow y row =
    row |> List.map (\x -> singleCell x y)


grid : List (List String)
grid =
    List.range 1 8
        |> List.map (\row -> List.range 1 8)
        |> List.indexedMap chessRow
        |> List.reverse
```

I think that is so much nicer to read, I'm actually a bit impressed at how much of a difference that makes.

# 5. Creating the view

All that's left is getting the grid displayed in the browser. I guess I could have done nested `List.map`s, but again, I think separate functions look nicer.

First, we need to put each row into one div. 

Then those divs all get put into one main div.

```elm
rowDiv : List String -> Html a
rowDiv row =
    div [] (row |> List.map (\boardPosition -> text boardPosition))


main : Html a
main =
    div [] (grid |> List.map rowDiv)
```

Looking good. See you tomorrow!