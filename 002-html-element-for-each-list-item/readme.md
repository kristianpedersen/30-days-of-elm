# 2/30 Return HTML for each list item

Code + demo: https://ellie-app.com/bS7Gr4mBws5a1

This is day 2 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

In today's project, I want to display a p tag for each item in an array. No for loops!

Here's what I want to do, written in React:

```javascript
function App() {
	const people = ["You", "Me", "They"]

	return (
		people.map(person => <p>{person}</p>)
	)
}
```
In advance, I assume `.map()` is what people would use in Elm as well. 

`.map()` applies a function to each item in an array, and returns a new array with transformed items. The old array is left intact.

# Code walkthrough

This project wasn't too bad, actually. I got stuck one place, but the Elm Slack community quickly helped me understand.

I also found this article useful: [Generating HTML from a list in Elm, by Brad Cypert](https://www.bradcypert.com/generating-html-from-a-list-in-elm/)

## 1. Imports

```elm
module Main exposing (initialState, main)

import Browser
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (..)
```

Nothing fancy here. I'll explain the "text" element later.

The first line was added automatically by elm-format. How do I know what to expose? Do I even need `Main.elm` to be a module, or is that more useful if I'm working with multiple files?

## 2. Main function

```elm
main : Program () Model a
main =
    Browser.sandbox { init = initialState, update = update, view = view }
```

I still find the type annotation a bit cryptic, but I'll re-read [bukkfrig's comment on yesterday's post](https://dev.to/bukkfrig/comment/19b0m) a couple of times. 

Basically, it's a bit like Java's `public static void main(String[] args)`. To begin with, it just seems like cryptic boilerplate, but the terms make sense eventually.

## 3. Model

Today's model is very simple. I chose to have it in a record (similar to JavaScript object), because I think it's a good habit that will allow for flexibility as my model grows.

```elm
type alias Model =
    { listOfPeople : List String }


initialState : Model
initialState =
    { listOfPeople = [ "You", "Me", "They" ] }
```

I could have simplified this slightly, like this:

```elm
initialState : { listOfPeople : List String }
initialState =
    { listOfPeople = [ "You", "Me", "They" ] }
```

However, having the `Model` type alias will be nice if I decide to add new fields to it. 

In that case, I don't have to add the new field to all other references to the model.

## 4. Update function that doesn't update anything

```elm
update : a -> Model -> Model
update msg model =
    model
```

My update function just returns the model it receives.

I haven't defined any Msg type, so I just went with VS Code's `a` suggestion. I guess it's like TypeScript's `any`?

For a tiny static project like this, I would be better off just doing it in plain HTML+JS. :)


## 5. View

```elm
view : Model -> Html msg
view model =
    div [] (List.map (\person -> div [] [ text person ]) model.listOfPeople)
```

The map function works the same as the one in JavaScript, except the list comes last.

* JavaScript: `myList.map(myFunction)`
* Elm: `List.map myFunction myList`

I've wrapped `map` in parentheses. Otherwise, Elm perceives each whitespace to indicate a new argument to `List.map`.

The first div argument is the attributes, which is empty. This is where we would add classes, event listeners and other things.

### 5.1 View errors, helped by Slack and type annotations

To begin with, I wrote the application without type annotations, thinking it would make things simpler. My view function looked like this, and didn't work:

```elm
view model =
    div [] (List.map (\person -> div [] [ person ]) model.listOfPeople)
```

The error message left me a bit confused. How on earth did I get an `Html msg1`?

```
The 1st argument to `sandbox` is not what I expect:

10|     Browser.sandbox { init = initialState, update = update, view = view }
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This argument is a record of type:

    { init : Model
    , update : msg1 -> Model -> Model
    , view : { listOfPeople : List (Html msg) } -> Html msg
    }

But `sandbox` needs the 1st argument to be:

    { init : Model, update : msg1 -> Model -> Model, view : Model -> Html msg1 }
```

Slack user wolfadex suggested I add type annotations to get better error messages.

New code:

```elm
view : Model -> Html msg
view model =
    div [] (List.map (\person -> div [] [ person ]) model.listOfPeople)
```
New error message:
```
The 2nd argument to `map` is not what I expect:

29|     div [] (List.map (\person -> div [] [ person ]) model.listOfPeople)
                                                        ^^^^^^^^^^^^^^^^^^
The value at .listOfPeople is a:

    List String

But `map` needs the 2nd argument to be:

    List (Html msg)

Hint: I always figure out the argument types from left to right. If an argument
is acceptable, I assume it is “correct” and move on. So the problem may actually
be in one of the previous arguments!

```

The part that helped me was this: "`map` needs the 2nd argument to be `List (Html msg)`".

Compare these two examples:

```elm
-- 1. My initial approach
-- Person is a string, but div expects an Html msg
div [] [ person ]

-- 2. Working example
-- The text function converts the string "person" to an Html msg.
div [] [ text person ]
``` 

* [div documentation](https://package.elm-lang.org/packages/elm/html/1.0.0/Html#div)
* [text documentation](https://package.elm-lang.org/packages/elm/html/1.0.0/Html#text)

I was happy to see the great response on yesterday's post, and I'm already looking forward to tomorrow's project!