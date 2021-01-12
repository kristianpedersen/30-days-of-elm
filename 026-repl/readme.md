This is day 26 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today I learned how to test my functions in the REPL, instead of logging them with `Debug.log` or displaying them in the view function with `text (myVariable |> Debug.toString)`.

- [1. Debug.log: Like console.log(), but only in the browser](#1-debuglog-like-consolelog-but-only-in-the-browser)
- [2. text (variableOfAnyType |> Debug.toString)](#2-text-variableofanytype--debugtostring)
- [3. My Main.elm code](#3-my-mainelm-code)
- [4. Starting and using the REPL](#4-starting-and-using-the-repl)
- [5. Screenshot](#5-screenshot)
- [6. Conclusion](#6-conclusion)

My project is just a new directory where I've entered `elm init` and created a `src/Main.elm` file.

The REPL can be launched from the project root if there's an `elm.json` file, by entering `elm repl`. Note how it says `Say :help for help and :exit to exit! More at https://elm-lang.org/0.19.1/repl`.

CTRL+C didn't work on my Mac, but `:exit` did.

# 1. Debug.log: Like console.log(), but only in the browser

This one had me confused at first. In JavaScript, you can just put `console.log()` wherever you want.

In Elm, `Debug.log` has to be within a `let` block. Most code I've seen just refer to it with an underscore `_` since its value isn't important (does it even have a value?):

```elm
rangeEcho =
    List.range 1 5
        |> List.map
            (\n ->
                let
                    _ = Debug.log "The number is: " n
                in
                n
            )
```
The lonely `n` is there because we have to return something.

Interestingly, the numbers come out backwards! I'd love to know why this is.

Keep in mind, this only displays in the browser dev tools, not in the terminal.

# 2. text (variableOfAnyType |> Debug.toString)

The above function can also be displayed in the DOM, like this:

```elm
view = 
    text (rangeEcho |> Debug.toString)
-- [1,2,3,4,5]
```

It's a bit nicer than `Debug.log`, but I've found the REPL to be the far most engaging and flexible experience.

# 3. My Main.elm code

If you're using VS Code with the Elm Tooling extension, it will probably add a line like this to the top:

```elm
module Main exposing (..)
```

With this in place, you can test anything you want from your file, try passing it different parameters, or try combining functions.

Here's the file I was working on: https://ellie-app.com/c4cRdN4y4Pta1

# 4. Starting and using the REPL

1. Open a terminal and enter `elm repl` in your project root. There has to be an `elm.json` file there.
2. Enter `import Main exposing (..)` (or whatever your filename is)
3. Now you can just type function names from your project.
4. You can even modify or create new functions in Main.elm, and the REPL will automatically have access to them without needing to restart!

I gotta say, this is a much nicer way of working than what I've done up until now.

To learn more, here's the REPL documentation: https://github.com/elm/compiler/blob/master/hints/repl.md

# 5. Screenshot

![Screenshot of code and REPL](https://dev-to-uploads.s3.amazonaws.com/i/alegfgiadobddx5yg5dz.png)

First, you can see that `test` results in an error, but works after I've entered `import Main exposing (..)`.

That last line with `grid |> List.filter (\xy -> ...))` was particularly nice. Testing stuff interactively like this feels better than regular logging, although they all have their place, I suppose.

# 6. Conclusion

This was a fun thing to learn! I just wish I could get tab completion for `Main.elm` functions, not just for the ones that are created during the REPL runtime.

Happy logging, and see you tomorrow!