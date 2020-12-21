Today's project is the [Lights Out game](https://en.wikipedia.org/wiki/Lights_Out_(game))!

Initial plan:

* Model/view: 5x5 list of boolean values, rendered as checkboxes.
* When clicking a checkbox, its left/right/up/down neighbors also get toggled.
* The goal is to uncheck all the checkboxes.

Here's the end result: https://ellie-app.com/bRXymtmp5t7a1

This is going to be a long post, and I'm tired right now, so bear with me. :)

- [Svelte prototype](#svelte-prototype)
- [1. Main.elm walkthrough](#1-mainelm-walkthrough)
- [2. Import / main](#2-import--main)
- [3. Model](#3-model)
- [4. Update](#4-update)
	- [4.1 Toggling self and neighbor checkboxes](#41-toggling-self-and-neighbor-checkboxes)
- [5. View](#5-view)
	- [5.1 Main view function](#51-main-view-function)
	- [5.2 Generate 5x5 checkbox board](#52-generate-5x5-checkbox-board)
- [Conclusion](#conclusion)

# Svelte prototype

Here's the prototype I made in [Svelte](https://svelte.dev/), which served as a very good starting point. 

The Svelte prototype is nearly half the size of my final Elm project, which has less styling. Maybe Elm's safety would lead to less error checking in a more complex project?

I decided to represent the board as a one-dimensional array, just to keep my head straight later on in Elm.

```html
<script>
	let board = [...Array(25)].map((value, index) => {
		const x = index % 5;
		const y = Math.floor(index / 5);
		return {
			x,
			y,
			checked: Math.random() < 0.5,
		};
	});

	function toggleNeighbors(x, y) {
		board = board.map((checkbox) => {
			const xDistance = Math.abs(checkbox.x - x);
			const yDistance = Math.abs(checkbox.y - y);
			const isNeighbor =
				(xDistance === 1 && yDistance === 0) ||
				(xDistance === 0 && yDistance === 1);

			if (isNeighbor) {
				return {
					...checkbox, // Return everything from the checkbox object
					checked: !checkbox.checked, // Overwrite the checked property
				};
			} else {
				return checkbox; // If we don't return anything here, we get undefined -_-
			}
		});
	}

	function easyMode() {
		board = board.map((checkbox) => {
			return {
				...checkbox,
				checked:
					(checkbox.x === 1 && checkbox.y === 2) ||
					(checkbox.x === 2 && checkbox.y === 1) ||
					(checkbox.x === 2 && checkbox.y === 2) ||
					(checkbox.x === 2 && checkbox.y === 3) ||
					(checkbox.x === 3 && checkbox.y === 2),
			};
		});
	}
</script>

<style>
	button {
		display: block;
	}

	input {
		margin: 0;
		transform: scale(2);
	}

	label {
		background-color: #fff;
		border: 1px solid #999;
		border-right: none;
		display: inline-block;
		margin: -2px;
		padding: 1.5rem;
		transition: 0.1s ease-in;
	}

	label:hover {
		background-color: #eee;
	}

	/* The hr also counts as a child element.
	Therefore we select every 6th element + 1 */
	label:nth-child(6n + 1) {
		border-right: 1px solid #999;
	}

	hr {
		margin: 0;
		padding: 0;
		visibility: hidden;
	}
</style>

<button on:click={easyMode}>Easy mode</button>

<div id="board" />
{#each board as input, i}
	<label>
		<input
			type="checkbox"
			bind:checked={input.checked}
			on:change={() => {
				const x = i % 5;
				const y = Math.floor(i / 5);
				toggleNeighbors(x, y);
			}} />
	</label>

	{#if i % 5 === 4}
		<hr />
	{/if}
{/each}

{#if board.every((checkbox) => !checkbox.checked)}
	<p>You win!</p>
{:else}
	<p>{board.filter((checkbox) => checkbox.checked).length}/25</p>
{/if}

```

# 1. Main.elm walkthrough

This was a challenging project with a couple of headaches, mostly related to using the wrong event listener.

I was also unsure of what I should include in my data structure, but using records from the beginning allowed for flexibility.

# 2. Import / main

```elm
module Main exposing (init, main, update, view)

import Browser
import Html exposing (Html, button, div, hr, input, label, p, text)
import Html.Attributes exposing (checked, style, type_)
import Html.Events exposing (onClick)


main : Program () Board Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
```

Nothing here that hasn't been used in my previous projects.

# 3. Model

```elm
type alias Checkbox =
    { x : Int, y : Int, checked : Bool }


type alias Board =
    { checkboxes : List Checkbox }


init : Board
init =
    { checkboxes =
        List.indexedMap
            (\index _ ->
                { x = remainderBy 5 index
                , y = index // 5
                , checked = remainderBy 2 index == 0
                }
            )
            (List.repeat 25 { x = 0, y = 0, checked = True })
```

I was considering having other fields than checkboxes, but decided against it for simplicity's sake.

The separate `Checkbox` type alias came in handy in two of the update-related functions. 

Surprisingly, Elm doesn't have the `%` operator! To check for an even number in JavaScript, you type `n % 2 === 0`, while in Elm, you can choose between `remainderBy` or `modBy` [(see documentation)](https://package.elm-lang.org/packages/elm/core/latest/Basics#remainderBy).

I chose `remainderBy` because that's closest to what I would say in conversation with someone.

`List.indexedMap` takes an index and a value, just like JavaScript's `Array.map`. Things are kind of backwards, which can trip you up at first:

JavaScript:

```javascript
myStuff.map((value, index) => /* Return something */ )
```

Elm:

```elm
List.indexedMap (\index value -> {- Return something -}) myStuff
```

The last line with `List.repeat` doesn't feel right to me. It does the job, but only one of the checkboxes will have an XY position of (0, 0). 

I'm pretty sure I'll look back on this later, and see a more elegant way of doing it.

# 4. Update

Let's begin with just the Msg type, which provides a nice overview of possible user actions. The `PressButton` message comes with the XY position of the clicked checkbox.

I just used a tuple because I saw it in the documentation. Is there a practical difference between tuples and a list of length 2?

`ActivateEasyMode` does what it says.

```elm
type Msg
    = PressButton ( Int, Int )
    | ActivateEasyMode
```

Now this is where things get crazy. `elm-format` and I have made beautiful stairs of code together! :D

I did fix it! But first, the original code in all its glory:

```elm
update : Msg -> Board -> Board
update msg model =
    case msg of
        PressButton xyTuple ->
            toggleNeighborsAndSelf (Tuple.first xyTuple) (Tuple.second xyTuple) model

        ActivateEasyMode ->
            { model
                | checkboxes =
                    List.map
                        (\checkbox ->
                            { checkbox
                                | checked =
                                    (checkbox.x == 1 && checkbox.y == 2)
                                        || (checkbox.x == 2 && checkbox.y == 1)
                                        || (checkbox.x == 2 && checkbox.y == 2)
                                        || (checkbox.x == 2 && checkbox.y == 3)
                                        || (checkbox.x == 3 && checkbox.y == 2)
                            }
                        )
                        model.checkboxes
            }
```

It's fun to look at, but ultimately I prefer anonymous functions to not go beyond one line. Separate named functions are a lot nicer to read:

```elm
checkIfEasy : Checkbox -> Checkbox
checkIfEasy checkbox =
    { checkbox
        | checked =
            (checkbox.x == 1 && checkbox.y == 2)
                || (checkbox.x == 2 && checkbox.y == 1)
                || (checkbox.x == 2 && checkbox.y == 2)
                || (checkbox.x == 2 && checkbox.y == 3)
                || (checkbox.x == 3 && checkbox.y == 2)
    }


update : Msg -> Board -> Board
update msg model =
    case msg of
        PressButton xyTuple ->
            makeAMove (Tuple.first xyTuple) (Tuple.second xyTuple) model

        ActivateEasyMode ->
            { model | checkboxes = List.map checkIfEasy model.checkboxes }
```

## 4.1 Toggling self and neighbor checkboxes

This is where the magic happens. One click gets turned into several:

```elm
toggleSelfAndNeighbors : Int -> Int -> Checkbox -> Checkbox
toggleSelfAndNeighbors x y checkbox =
    let
        xDistance =
            abs (checkbox.x - x)

        yDistance =
            abs (checkbox.y - y)

        isNeighborOrEventTarget =
            (xDistance == 0 && yDistance == 0)
                || (xDistance == 1 && yDistance == 0)
                || (xDistance == 0 && yDistance == 1)
    in
    if isNeighborOrEventTarget then
        { checkbox | checked = not checkbox.checked }

    else
        checkbox


makeAMove : Int -> Int -> Board -> Board
makeAMove x y model =
    { model | checkboxes = List.map (toggleSelfAndNeighbors x y) model.checkboxes }
```

I hadn't tried the `let .. in` construct before. I guess `let` declarations don't return anything, while the `in` part does.

The essence is this function is basically this:
* Loop through all the checkboxes
* If the checkbox's XY position matches the condition:
  * Set it equal to the opposite of what it was.
* Return the new model.

# 5. View

The main view function contains quite a few things, but has been simplified by extracting things into their own functions.

Readability is a very important factor to consider. The code has to be read by someone else (a colleague, open source collaborator, or myself in a couple of months)

Just imagine how messy the `generate5x5CheckboxBoard` function would be inline in the view function! :o

In this case, I think the last p tag's contents would benefit from extraction to a function with a descriptive name, rather than a `let .. in if .. else` statement.

## 5.1 Main view function

```elm
numberOfCheckedItems : Board -> Int
numberOfCheckedItems model =
    List.length (List.filter (\cb -> cb.checked) model.checkboxes)

view : Board -> Html Msg
view model =
    div [ style "padding" "1rem" ]
        [ button
            [ onClick ActivateEasyMode
            , style "padding" "1rem"
            , style "margin-bottom" "1rem"
            ]
            [ text "Easy mode" ]
        , div [] <| generate5x5CheckboxBoard model
        , p []
            [ text
                (let
                    checkedCount =
                        numberOfCheckedItems model
                 in
                 if checkedCount == 0 then
                    "You win!"

                 else
                    String.fromInt checkedCount ++ "/25"
                )
            ]
        ]
```

To be honest, I just saw someone else do the <| thing, but it works. Just put this stuff where the arrow points.

## 5.2 Generate 5x5 checkbox board

To make the 5x5 function more readable, I made two functions: `htmlIf` and `row`.

```elm
htmlIf : Bool -> Html msg -> Html msg
htmlIf condition element =
    if condition then
        element

    else
        text ""


row : Html msg
row =
    hr [ style "visibility" "hidden", style "margin" "0.5rem 0" ] []


generate5x5CheckboxBoard : Board -> List (Html Msg)
generate5x5CheckboxBoard model =
    List.indexedMap
        (\index checkbox ->
            label
                [ style "border" "1px solid #999"
                , style "border-right" "none"
                , style "margin" ".5rem"
                ]
                [ input
                    [ type_ "checkbox"
                    , onClick (PressButton ( checkbox.x, checkbox.y ))
                    , checked checkbox.checked
                    , style "transform" "scale(2)"
                    ]
                    []
                , htmlIf (remainderBy 5 index == 4) row
                ]
        )
        model.checkboxes
```

The biggest challenge I faced today was the event listener. To begin with, I was using an `onCheck` event listener, which I got working on its own, but then I wanted to pass the XY values along with the message.

`onCheck` kept insisting on 1 argument, but I also wanted to pass it my XY values.

I read all kinds of crazy stuff about custom events, combined with subscriptions and JSON decoding, and almost had it working.

Then I found another example with 0 votes on Stack Overflow, using the previous version of Elm, and an onClick event listener: https://stackoverflow.com/questions/46019061/updating-model-with-parameter-in-elm-0-18

I converted it to 0.19, and realized that onClick was what I was looking for all along! https://ellie-app.com/bRXkJSnt6G9a1

Maybe there's a way I could have achieved what I wanted to anyway. I'll make sure to read the documentation after a good night's sleep.

https://package.elm-lang.org/packages/elm/html/latest/Html-Events

# Conclusion

* Separate functions can make code a lot more readable.
* Svelte is a great prototyping tool.
* Working with events and data will require some practive.
* Lights Out is a fun game!

See you tomorrow for a simpler project. :)