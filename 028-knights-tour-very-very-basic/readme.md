This is day 28 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

To be honest, I'm glad these 30 days are almost over. Writing is nice, but I'm the kind of person who can easily spend 15 minutes re-writing one sentence. 

Currently, I'm at a stage where I would rather spend time on projects than writing about learning Elm. I take this frustration as a sign that I've improved. :)

I have a handful of personal projects that I'm eager to re-make and improve, but I still think it would be nice to write occasionally to keep the momentum going. A couple of sentences a day? Weekly write-ups? Project write-ups? All of it? What has worked for you?

Anyway, today we're generating a chess board, and dipping our toes in the [Knight's Tour problem](https://en.wikipedia.org/wiki/Knight%27s_tour).

Demo/code: https://ellie-app.com/c59zGwgPN3Ha1

**Table of contents**

- [1. Creating a basic chessboard, and calculating a few moves](#1-creating-a-basic-chessboard-and-calculating-a-few-moves)
- [2. Create a chess board](#2-create-a-chess-board)
- [3. index -> (Int, Int) and index -> letter ++ number](#3-index---int-int-and-index---letter--number)
- [4. Get valid destinations](#4-get-valid-destinations)
- [5. Get the destinations' destionations](#5-get-the-destinations-destionations)
- [6. Things that need fixing](#6-things-that-need-fixing)

# 1. Creating a basic chessboard, and calculating a few moves

Eventually, I really want to improve my old React project for solving the Knight's Tour problem, and maybe even compare my home-made algorithm with existing ones.

It's fun to use and I like some of the ideas, but it doesn't look good: https://kristianpedersen.github.io/knights-tour-react/

Today I've just set up some basics:

1. Create a chess board
2. Set up two possible representation of the positions on the board: 
   1. A record with coordinates and various info
   2. A human-readable form: "A1".."H8"
3. For a given position, get the valid destinations on the board.
4. Later, I will sort those destinations by *their* number of possible destinations, and move to the one with the fewest destinations. This is known as [Warnsdorff's rule](https://en.wikipedia.org/wiki/Knight%27s_tour#Warnsdorff's_rule).

# 2. Create a chess board

```elm
squareWithCoordinates : Int -> Int -> BoardPosition
squareWithCoordinates boardSize index =
    { x = modBy boardSize index
    , y = index // boardSize
    , visited = False
    , destinations = 0
    }


createBoard : Int -> List BoardPosition
createBoard boardSize =
    List.range 0 ((boardSize ^ 2) - 1)
        |> List.map (squareWithCoordinates boardSize)


chessBoard : List BoardPosition
chessBoard =
    createBoard 8
```

This way of generating X and Y coordinates seems simpler than dealing with a two-dimensional list.

`visited` and `destinations` don't do anything yet. I think I might need them, although maybe it's easier to just build up a new chessboard, move by move?

`createBoard` relies on partial application. We're not directly passing in `index`, but the pipeline `|>` adds the `List.range` result as the last argument to `List.map`. These two functions do the same thing:

```elm
createBoard1 boardSize =
    List.range 0 ((boardSize ^ 2) - 1)
        |> List.map (squareWithCoordinates boardSize)

createBoard2 boardSize =
    List.range 0 ((boardSize ^ 2) - 1)
        |> List.map (\index -> squareWithCoordinates boardSize index)
```

Some might prefer the explicitness of `createBoard2`. Partial application is very useful and very cool, but I can see how it might demand some extra mental capacity when read by others or my future forgetful self.

# 3. index -> (Int, Int) and index -> letter ++ number

When showing the squares, they should say "A1" up to "H8".

```elm
squareView : Int -> Int -> NamedPosition
squareView boardSize index =
    let
        sliceStart =
            modBy boardSize index

        sliceEnd =
            sliceStart + 1
    in
    { x = String.slice sliceStart sliceEnd "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    , y = (index // boardSize) + 1
    }
```

I know the board only goes up to 8, but later I want to be able to select other board sizes.

To get the X index of the alphabet string, we use `modBy`, which takes `index / boardSize` and returns the remainder.

The `//` just means integer division, which works just like `Math.floor(index / boardSize)` if you're coming from JavaScript.

# 4. Get valid destinations

This one is easier. From a given position, return the pieces that have an XY distance of (1, 2) or (2, 1).

Later on, this will also only include squares that have not been visited.

`elm-format` looks crazy sometimes when there are no parentheses! :D

Before:

```elm
getValidDestinations : List BoardPosition -> BoardPosition -> List BoardPosition
getValidDestinations board current =
    board
        |> List.filter
            (\other ->
                abs other.x
                    - current.x
                    == 2
                    && abs other.y
                    - current.y
                    == 1
                    || abs other.x
                    - current.x
                    == 1
                    && abs other.y
                    - current.y
                    == 2
            )
```

Still looks kind of messy:

```elm
getValidDestinations : List BoardPosition -> BoardPosition -> List BoardPosition
getValidDestinations board current =
    board
        |> List.filter
            (\other ->
                (abs (other.x - current.x) == 2 && abs (other.y - current.y) == 1)
                    || (abs (other.x - current.x) == 1 && abs (other.y - current.y) == 2)
            )
```

Finally:

```elm
getValidDestinations : List BoardPosition -> BoardPosition -> List BoardPosition
getValidDestinations board current =
    board
        |> List.filter
            (\other ->
                let
                    ( xDistance, yDistance ) =
                        ( abs <| other.x - current.x
                        , abs <| other.y - current.y
                        )
                in
                (xDistance == 2 && yDistance == 1) || (xDistance == 1 && yDistance == 2)
            )
```

I prefer this one by far. The `in` part explains what we're filtering (keeping).

# 5. Get the destinations' destionations

Now that we've gotten a list of valid destinations, let's get *their* valid destinations.

We're just going with a hardcoded starting position of (0, 0). The unused record attributes have been removed for readability.

```elm
makeMove : Position -> List Position
makeMove position =
    getValidDestinations chessBoard position


nextDestinations : Position -> List (List Position)
nextDestinations position =
    makeMove position |> List.map (getValidDestinations chessBoard)
```

Here's some REPL output from testing:

```
> makeMove {x=4,y=4} |> List.length
8 : Int

> nextDestinations {x=4,y=4} |> List.map List.length
[8,8,8,6,8,6,6,6]
    : List Int
```

# 6. Things that need fixing

If I log out `nextDestinations {x=4,y=4}`, I will get (4,4) as one of the valid destinations, which won't work.

Some places in the code, I'm passing the board (8x8 grid) as a parameter, and other places I'm referring to a function that just returns the initial version.

I'll need to think about this, but maybe my model could consist of two boards? One with the unvisited squares, and another one with the visited ones?

Then of course, there's the part where we've done a few moves, this particular sequence wasn't successful, and we need to rewind. In my JavaScript implementation, each square had an array of its valid moves, so I might need to implement that here too.