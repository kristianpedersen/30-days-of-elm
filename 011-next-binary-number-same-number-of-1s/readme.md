This is day 11 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Demo: https://ellie-app.com/bVDMsDcTnXMa1

# About today's project
- [About today's project](#about-todays-project)
- [0. Automatic reload with elm-live](#0-automatic-reload-with-elm-live)
- [1. Int -> Next higher number with same 1 bits](#1-int---next-higher-number-with-same-1-bits)
  - [1.1 What are binary numbers?](#11-what-are-binary-numbers)
  - [1.2 Converting from int to binary](#12-converting-from-int-to-binary)
    - [1.2.1 JavaScript prototyping with Quokka](#121-javascript-prototyping-with-quokka)
    - [1.2.2 How many bits is the number?](#122-how-many-bits-is-the-number)
    - [1.2.3 Generate bits](#123-generate-bits)
    - [1.2.4 Generate binary number](#124-generate-binary-number)
  - [1.3 Converting from binary to int](#13-converting-from-binary-to-int)
  - [1.4 Finding corresponding binary numbers](#14-finding-corresponding-binary-numbers)
    - [1.4.1 Same number of 1 bits](#141-same-number-of-1-bits)
    - [1.4.2 Get all numbers with the same or +1 number of bits](#142-get-all-numbers-with-the-same-or-1-number-of-bits)
    - [1.4.3 Get the next binary number with the same number of 1's](#143-get-the-next-binary-number-with-the-same-number-of-1s)
  - [2. Conclusion](#2-conclusion)

Today, I got inspired by a codewars.com kata (simple programming task).

The user should enter a number, and find the next binary number with the same number of 1 bits in it.

* Input: 42
* 42 converted to binary is 101010
* The next binary number with the same number of 1's is 44 (101100)
  
Normally, I would have used a package [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/Binary), but I decided to give myself a challenge and implement the functionality I needed from scratch.

I don't know how to use bitwise operators yet either, so there's lots of refactoring needed today! :D


# 0. Automatic reload with elm-live

I prefer testing my solutions locally, without getting CodeWars' error messages before I'm done.

`elm reactor` doesn't have automatic reloading on file save, which is a bit annoying. 

What I've done previously is create an `index.html`, and have it reference the compiled JavaScript file from Main.elm: https://guide.elm-lang.org/interop/

Then, in two separate terminals in the project root:

1. `nodemon --exec elm make src/Main.elm --output=main.js`
2. `live-server`

Today however, I discovered `elm-live`, which lets you achieve the same result without needing to do create an HTML file and compile Main.elm.

1. Install: `npm i -g elm-live`
2. In project root: `elm-live src/Main.elm`
3. Go to http://localhost:8000/

# 1. Int -> Next higher number with same 1 bits

## 1.1 What are binary numbers?

When reading binary numbers, you read them right-to-left.

Let's say you have a 6 bit number: 101010. Each digit is multiplied by twice as much as the previous one.

```
(32 * 1) 
+ (16 * 0) 
+ (8 * 1) 
+ (4 * 0) 
+ (2 * 1) 
+ (1 * 0)

= 42
```

## 1.2 Converting from int to binary

I probably should have made a custom type that only accepts strings that consist of 0's and 1's. Sounds like something that should be possible.

There's probably a far simpler solution using bitwise operators, but I'll learn those another time.

### 1.2.1 JavaScript prototyping with Quokka

If you know JavaScript, you would benefit from having [Quokka installed in VS Code](https://marketplace.visualstudio.com/items?itemName=WallabyJs.quokka-vscode).

You can just see the values right there in the editor, in real-time. 

For projects like this one today, I prefer prototyping in JavaScript, since doing it in Elm wouldn't provide the same immediate feedback (to my knowledge).

Here's the JavaScript prototype I started from:

```javascript
const n = 42
const numberOfBits = countBits(n) // 6
const bitsArray = generateBits(numberOfBits) // [32, 16, 8, 4, 2, 1]
const { binaryNumber } = generateBinaryNumber(n, bitsArray) // 101010
const cheating = (n).toString(2) // 101010

function countBits(n, count = 0) {
	if (n >= 1) {
		return countBits(n / 2, count + 1)
	}
	return count
}

function generateBits(n) {
	return [...Array(n)].map((_, i) => 2 ** i).reverse()
}

function generateBinaryNumber(number, bitArray) {
	return bitArray.reduce((acc, curr) => {
		if (acc.number >= curr) {
			acc.number -= curr
			acc.binaryNumber += "1"
		} else {
			acc.binaryNumber += "0"
		}
		return acc
	}, { number, binaryNumber: "" })
}
```

### 1.2.2 How many bits is the number?
Given an int, I want to generate a list of bits `[8, 4, 2, 1]`, but first I need to know how many bits that int is.

```elm
countBits : Float -> Int -> Int
countBits number count =
    if number >= 1 then
        countBits (number / 2) (count + 1)

    else
        count
```

When first calling the function, I pass it an int. However, in the if statement, the result from dividing by 2 will be a float.

Also, since Elm doesn't have default parameter values, I have to explicitly pass in the count variable. I guess there's a partial application solution though.

For this reason, I have to call the function in this unelegant way: `countBits (toFloat 42) 0`

### 1.2.3 Generate bits

```elm
generateBits : Int -> List Int
generateBits numberOfBits =
    List.range 0 (numberOfBits - 1)
        |> List.map (\n -> 2 ^ n)
        |> List.reverse
```

* `[0, 1, 2, 3, 4, 5]`
* `[1, 2, 4, 8, 16, 32]`
* `[32, 16, 8, 4, 2, 1]`

With these in place, we can finally create binary numbers.

In JavaScript, we could have just written `(42).toString(2)`, but this is more fun. :D

### 1.2.4 Generate binary number

I think the JS solution would have been nicer with a regular for loop, but `reduce` is a lot of fun, and Elm's `List.foldl` works the same way:

```elm
type alias BinaryNumber =
    { tempNumber : Int, binaryNumber : String }


generateBinaryNumber : Int -> BinaryNumber
generateBinaryNumber number =
    List.foldl
        (\currentBit accumulator ->
            if accumulator.tempNumber >= currentBit then
                { tempNumber = accumulator.tempNumber - currentBit
                , binaryNumber = accumulator.binaryNumber ++ "1"
                }

            else
                { accumulator | binaryNumber = accumulator.binaryNumber ++ "0" }
        )
        { tempNumber = number, binaryNumber = "" }
        (generateBits (countBits (toFloat number) 0))
```

The disadvantage here is that I'm not just returning the `binaryNumber` part of the accumulator. I guess I could just do that? I'll find out some other day.

## 1.3 Converting from binary to int

This one was fun! Using 42 as an example, we can combine two lists  - one with its binary digits and with its bits:

Binary digits: 

`[1, 0, 1, 0, 1, 0]`

Bits: 

`[32, 16, 8, 4, 2, 1]`

These can just be multiplied, and we'll have our int back, but how can we multiply each number in list1 with each number in list2?

Using our previously made functions, we get this:

```elm
binaryToInt : String -> Int
binaryToInt binaryNumber =
    let
        bits =
            generateBits <| String.length binaryNumber

        digits =
            String.toList binaryNumber
                |> List.map String.fromChar
                |> List.map String.toInt
                |> List.map (Maybe.withDefault 0)
    in
    List.map2 (*) bits digits |> List.sum
```

The `digits` variable is a bit tedious. 
* First, we convert from char to string. "1" doesn't count as a string.
* Then we need to convert each digit string to an int, which is fair enough.
* However, `String.toInt` returns a `Maybe Int`, so we need to be 1000% sure that nothing non-inty was passed with `Maybe.withDefault`.

Other than that, I'm stoked about that `List.map2` line. :D

## 1.4 Finding corresponding binary numbers

### 1.4.1 Same number of 1 bits

In order to find the next number with the same number of 1 bits, we need to know how many our initial number has.

Staying with 42, its binary representation is 101010, which contains 3 ones.

```elm
getNumberOf1s : String -> Int
getNumberOf1s binaryNumber =
    binaryNumber
        |> String.toList
        |> List.map (\char -> String.fromChar char)
        |> List.filter (\c -> c == "1")
        |> List.length
```

* `['1', '0', '1', '0', '1', '0']`
* `["1", "0", "1", "0", "1", "0"]`
* `["1", "1", "1"]`
* `3`

### 1.4.2 Get all numbers with the same or +1 number of bits

There's no point generating an arbitrarily long list of numbers.

42 (101010) is 6 bits, so the next number with three occurrences of 1 could be a 6-bit or a 7-bit number.

Looking at `101010`, you can tell it's another 6-bit number, but I'm too tired to think of a simple elegant way to do that check. :D

```elm
getWithNBitsOrNPlusOne : Int -> List String
getWithNBitsOrNPlusOne number =
    let
        min =
            -1 + countBits (toFloat number) 0

        max =
            min + 2
    in
    List.range (2 ^ min) ((2 ^ max) - 1)
        |> List.map generateBinaryNumber
        |> List.map (\bn -> bn.binaryNumber)
```
With 42, what we're saying is 
```elm
List.range 32 127
	|> -- [{tempNumber = ..., binaryNumber = "100000"}, ...]
	|> -- ["100000", "100001", ..., "111111"]

```

`elm-format` wouldn't let me write `(countBits (toFloat number) 0) - 1`.

It would have made more sense to say `max = min + 1`, but then the lowest numbers didn't get any hits, which I didn't like.

### 1.4.3 Get the next binary number with the same number of 1's

```elm
getFirstMatchingBinaryNumber : Int -> String
getFirstMatchingBinaryNumber n =
    getWithNBitsOrNPlusOne n
        |> List.filter
            (\num ->
                (getNumberOf1s num == getNumberOf1s (generateBinaryNumber n).binaryNumber)
                    && (binaryToInt num > n)
            )
        |> List.head
        |> Maybe.withDefault ""
```

So, we're getting the range of binary numbers from before.

Then, we filter (keep) the ones that:

1. Have the same number of 1's
2. The number is greater than n (in our case 42)

With all this in place, we can conclude that the next number that also has three 1's is 101100 (44). 

I'm 99% sure there's a far simpler way to arrive at this conclusion programmatically. :D

## 2. Conclusion

* This program would have been far simpler, and far more maintainable, (and probably more correct too) if I had just used [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/Binary)
* Even so, I still have this feeling that a lot of my code can be improved upon.
* `Maybe` types take some getting used to.
* Using `|>` makes me happy.
* [Quokka](https://marketplace.visualstudio.com/items?itemName=WallabyJs.quokka-vscode) + JavaScript is great for prototyping!