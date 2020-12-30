This is day 14 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Code/demo: https://ellie-app.com/bWVYn3n7zXFa1

# Background

Today I wanted to solve a couple of katas (puzzles/problems) at https://www.codewars.com/

I did the two first ones on day 11. The third one was the one about finding the next binary number with the same number of 1 bits, which ended up being the focus for [days 11, 12 and 13](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2).

The next two were done today, prototyped with JavaScript + [Quokka in VS Code](https://marketplace.visualstudio.com/items?itemName=WallabyJs.quokka-vscode).

Just like with the Elm compiler, it feels great when the CodeWars katas finally compile, and it's fun to see how other people solved the same problem.

- [Background](#background)
- [1. Square every digit](#1-square-every-digit)
- [2. Repeat each character index+1 times](#2-repeat-each-character-index1-times)
- [3. Balanced number](#3-balanced-number)
	- [3.1 JavaScript solution](#31-javascript-solution)
	- [3.2 Elm solution](#32-elm-solution)
- [4. Circle of numbers](#4-circle-of-numbers)
	- [4.1 JavaScript solution](#41-javascript-solution)
	- [4.2 Elm solution](#42-elm-solution)
	- [4.3 One-liner](#43-one-liner)
- [5. Summary](#5-summary)

# 1. Square every digit

```elm
squareEveryDigit : Int -> Int
squareEveryDigit num =
    num
        |> String.fromInt
        -- 1234 -> "1234"
        |> String.split ""
        -- "1234" -> ["1", "2", "3", "4"]
        |> List.map (\s -> String.toInt s |> Maybe.withDefault 0)
        -- ["1", "2", "3", "4"] -> [1, 2, 3, 4]
        |> List.map (\n -> n * n)
        -- [1, 2, 3, 4] -> [1, 4, 9, 16]
        |> List.map String.fromInt
        -- ["1", "4", "9", "16"]
        |> String.join ""
        -- "14916"
        |> String.toInt
        -- 14916
        |> Maybe.withDefault 0
        -- toInt returns a Maybe Int. In case the conversion doesn't work, we set 0 as the default.
```

# 2. Repeat each character index+1 times

Given a string with no spaces, repeat each character index+1 times, with a dash between.

"Abc" -> "A-Bb-Ccc"
"Kristian" -> "K-Rr-Iii-Ssss-Ttttt-Iiiiii-Aaaaaaa-Nnnnnnnn"

```elm
upperIfIndex0 : Int -> String -> String
upperIfIndex0 index character =
    if index == 0 then
        String.toUpper character

    else
        character


repeatIndexPlus1Times : Int -> String -> String
repeatIndexPlus1Times index character =
    List.repeat (index + 1) character
        |> List.indexedMap upperIfIndex0
        |> String.join ""


accum : String -> String
accum s =
    s
        |> String.toLower
        |> String.split ""
        |> List.indexedMap repeatIndexPlus1Times
        |> String.join "-"
```

The index variables come from `List.indexedMap`. 

The two first functions could have been inline, but that would turn it into an indented anonymous mess. Also the index2 and character2 variable names don't look nice.

```elm
accum : String -> String
accum s =
    s
        |> String.toLower
        |> String.split ""
        |> List.indexedMap
            (\index character ->
                List.repeat (index + 1) character
                    |> List.indexedMap
                        (\index2 character2 ->
                            if index == 0 then
                                String.toUpper character

                            else
                                character
                        )
                    |> String.join ""
            )
        |> String.join "-"
```

# 3. Balanced number

This one is part 1 in a series of number katas. There wasn't an Elm version available, so I'm submitting it as JavaScript, and then re-creating it in Elm.

a = The sum of all digits to the *left* of the middle digit(s) 
b = The sum of all digits to the *right* of the middle digit(s)

959 -> True (9 == 9)
123321 -> True (1+2 == 2+1)
123320 -> False (1+2 != 2+0)

In other words: 
1. split the digits into two lists that *don't* include the middle digit(s).
2. The sums of the left and right lists should be equal.

The tests accept any 1- or 2-digit numbers as balanced, because there is no middle number.

## 3.1 JavaScript solution
I'm really happy with this one, actually. 

These are the index numbers I would need to get left and right arrays.

`Array.slice(start, end)` slice from `start`, and up to but not including `end`.

If no `end` is provided, it just slices until the end of the array.

```javascript
const a = [1, 2, 3, 4]
const b = [1, 2, 3, 4, 5]

console.log(a.slice(0, 1), a.slice(3)) // [1] [4]
console.log(b.slice(0, 2), b.slice(3)) // [1, 2] [4, 5]
```

And here is my JavaScript solution that I will re-create in Elm:

```javascript
function balancedNum(n) {
	const digits = String(n).split("").map(Number)

	if (digits.length <= 2) {
		return "Balanced"
	} else if (digits.length === 3) {
		return digits[0] === digits[2] ? "Balanced" : "Not Balanced"
	}

	const oneIfEven = (1 - digits.length % 2)
	const middleIndex1 = Math.floor(digits.length / 2) - oneIfEven
	const middleIndex2 = Math.ceil(digits.length / 2) + oneIfEven

	const left = digits.slice(0, middleIndex1)
	const right = digits.slice(middleIndex2)

	const sum = a => a.reduce((a, b) => a + b)

	return sum(left) === sum(right) ? "Balanced" : "Not Balanced"
}
```

## 3.2 Elm solution

```elm
isBalanced : Int -> String
isBalanced n =
    -- Split digits into array
    let
        digits =
            n
                |> String.fromInt
                |> String.split ""
                |> List.map String.toInt
                |> List.map (Maybe.withDefault 0)
                |> Array.fromList

        oneIfEven =
            1 - modBy 2 (Array.length digits)

        digitsLength =
            toFloat (Array.length digits)

        -- Determine where to slice into left and right arrays
        middleIndex1 =
            (digitsLength / 2 |> floor) - oneIfEven

        middleIndex2 =
            (digitsLength / 2 |> ceiling) + oneIfEven

        left =
            Array.slice 0 middleIndex1 digits

        right =
            Array.slice middleIndex2 (Array.length digits) digits

        -- Summing and comparing left and right
        resultForDigitsIs3 =
            if Array.get 0 digits == Array.get 2 digits then
                "balanced"

            else
                "not balanced"

        leftSum =
            Array.toList left |> List.sum

        rightSum =
            Array.toList right |> List.sum

        result =
            if digitsLength <= 2 then
                "balanced"

            else if digitsLength == 3 then
                resultForDigitsIs3

            else if leftSum == rightSum then
                "balanced"

            else
                "not balanced"
    in
    String.fromInt n ++ " is " ++ result
```

I'm using arrays instead of lists because I need specific index values.

Maybe Elm lists don't have indices due to performance reasons?

As for the division, it definitely feels weird having to convert from `Int` to `Float`, but as I understand, it's a performance/reliability issue: https://github.com/elm/compiler/blob/master/hints/implicit-casts.md

# 4. Circle of numbers

Given a circle of size n, return the number that's opposite to x.

`circleOfNumbers 10 2` should return `7`:

![Image of circle with numbers](https://codefightsuserpics.s3.amazonaws.com/tasks/circleOfNumbers/img/example.png)

Before looking at other people's solutions, I know mine isn't going to be ideal, as it relies on float point math.

Just try entering `0.1 + 0.2` in your browser console to see what I'm talking about. :)

## 4.1 JavaScript solution

Here's the basic idea:

* Generate an array of n angles
* `const thisAngle = angles[x]` returns number 2's angle
* `const otherAngle = (angles[x] + 180) % 360` return the opposite angle
* `angles.indexOf(otherAngle)` gives us the index of the opposite angle, which in our case is `7`. 

```javascript
const precision = 8

function circleOfNumbers(n, x) {
	const distance = 360 / n
	const angles = [...Array(n)].map((_, i) => i * distance)
		.map(n => Number(n.toFixed(precision)))
	const thisAngle = angles[x]
	const opposite = Number(
		((thisAngle + 180) % 360)
			.toFixed(precision)
	)

	return angles.indexOf(opposite)
}
```

## 4.2 Elm solution

All the conversions and `Maybe.withDefault`s get a bit tedious, but I got it working.

There's no `indexOf` function out of the box, but that can be replicated by having a list of `{ index : Int, angle : Float }`.

I'm using [myrho/elm-round](https://package.elm-lang.org/packages/myrho/elm-round/latest/) to replicate JavaScript's `.toPrecision(n)` function.

```elm
circleOfNumbers : Int -> Int -> Int
circleOfNumbers howManyNumbers numberToCheck =
    let
        distance =
            360 / toFloat howManyNumbers

        angles =
            List.range 0 (howManyNumbers - 1)
                |> List.map
                    (\index ->
                        { index = index
                        , angle = Round.round 5 (toFloat index * distance)
                        }
                    )

        thisAngle =
            angles
                |> List.filter (\angle -> angle.index == numberToCheck)
                |> List.map (\record -> record.angle)
                |> List.head
                |> Maybe.withDefault ""
                |> String.toFloat
                |> Maybe.withDefault 0

        otherAngleFloat =
            thisAngle + 180

        otherAngleOverflowString =
            Round.round 5 <| otherAngleFloat - 360

        otherAngleAsString =
            Round.round 5 <| thisAngle + 180

        otherIndex =
            angles
                |> List.filter
                    (\this ->
                        if otherAngleFloat < 360 then
                            this.angle == otherAngleAsString

                        else
                            this.angle == otherAngleOverflowString
                    )
                |> List.map (\record -> record.index)
                |> List.head
                |> Maybe.withDefault 0
    in
    otherIndex
```

## 4.3 One-liner

This is what I love about CodeWars. You come up with this hacky over-complicated solution, you get it to pass the tests, submit it, and then you're met with this:

```javascript
const circleOfNumbers = (n, x) => (x + n / 2) % n;
```

It's so beautiful! :D

Going by my current knowledge, this can't be replicated quite as succinctly in Elm, since the mod and remainder functions only work with ints.

This can probably be simplified further, but regardless, it's way better to look at than my previous solution:

```elm
circleOfNumbers2 : Float -> Float -> Float
circleOfNumbers2 n numberToFind =
    let
        num =
            numberToFind + n / 2

        result =
            if num > n then
                num - n

            else
                num
    in
    result
```

# 5. Summary

* CodeWars is fun!
* I miss implicit casts from `Int` to `Float`.

See you tomorrow!