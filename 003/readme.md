# 3/30 Grid of randomly toggled checkboxes + random toggle button

This is day 3 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today I'm making a 10x10 grid of checkboxes, which will be randomly toggled when I click a button.

I made this prototype in React, and it's really fun!

```jsx
import { useState } from "react"
import './App.css'

export default function App() {
  const randomArray = n => [...Array(n)].map(() => Math.random() < 0.5)
  const createGrid = n => randomArray(n).map(() => randomArray(n))

  const [grid, setGrid] = useState(createGrid(10))

  return (
    <>
      <button onClick={() => setGrid(createGrid(10))}>Haha checkboxes go brrr</button>
        {grid.map(row => (
          <div>{row.map(randomBool => <input type="checkbox" checked={randomBool} />)}</div>
        ))}
    </>
  )
}
```

# Elm code walkthrough

## 1. Import

```elm

```

## Model

I tried accessing the random-extra package, but wasn't successful.

## View

Man, the error messages really live up to their good reputation.

```
-- UNFINISHED PARENTHESES  /Users/kristian/Documents/30-days-of-elm/003/src/Main.elm

I was expecting to see a closing parentheses next, but I got stuck here:

52|         , List.map (\n -> p [] [text (String.fromInt n)])
                                  ^
Try adding a ) to see if that helps?

Note: I can get stuck when I run into keywords, operators, parentheses, or
brackets unexpectedly. So there may be some earlier syntax trouble (like extra
parenthesis or missing brackets) that is confusing me.
```

Wrapping the p tag in parentheses worked nicely.

Later on, I tried using Random, guessing it was installed by `elm init`:

```
You are trying to import a `Random` module:

7| import Random
          ^^^^^^
I checked the "dependencies" and "source-directories" listed in your elm.json,
but I cannot find it! Maybe it is a typo for one of these names?

    Array
    Main
    Task
    Dict

Hint: Maybe you want the `Random` module defined in the elm/random package?
Running elm install elm/random should make it available!
```

Just copy and paste from the last line. Why can't all error messages be this convenient?

Next up, I needed to make my view nicer. I got it working after a few error messages, but it's not readable at all:

```elm
div []
        [ button [ onClick CheckboxesGoBrrr ] [ text "haha checkboxes go brrr" ]
        , div [] (List.map (\row -> div [] (List.map (\col -> span [] [ input [ checked col, type_ "checkbox" ] [] ]) row)) model.grid)
        ]
```