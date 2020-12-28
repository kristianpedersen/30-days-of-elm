This is day 12 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Code/demo: https://ellie-app.com/bVZL2PwfQbra1

![Screenshot of binary number application](https://dev-to-uploads.s3.amazonaws.com/i/q0i1cj2r4m9sw1np9pe6.png)

Unrelated to today's project, I just discovered Bekk's Elm christmas calendar, with 24 very nicely written posts: 
* https://www.elm.christmas/2020
* https://bekk.christmas/

Yesterday, I wrote some binary conversion functions from scratch, which was fun!

Today, I want to recreate yesterday's project using [icidasset/elm-binary](https://package.elm-lang.org/packages/icidasset/elm-binary/latest/)

# 1. Convert from int to binary, and display as a string

`elm-binary` has built-in conversion from int to binary, but it's represented as a list of bits.

Here's how I got it as a regular string instead:

```elm
intToBinary : Int -> String
intToBinary n =
    n -- 42
        |> Binary.fromDecimal -- [1, 0, 1, 0, 1, 0]
        |> Binary.toIntegers -- [1, 0, 1, 0, 1, 0]
        |> List.map String.fromInt -- ["1", "0", "1", "0", "1", "0"]
        |> String.join "" -- "101010"
```

# 2. Figure out how many bits a number has

Today I discovered a much simpler solution than yesterday, as expected.

I entered `2 ^ x = 42` in [WolframAlpha](https://www.wolframalpha.com/input/?i=2+%5E+x+%3D+42), and the solution was right there:

`log(42) / log(2) = 5.392317422778761`. 101010 is 6 bits, so rounding up works!

I stopped doing well in mathematics around the time we were introduced to logarithms, but it's fun to be able to use it in a setting like this.

```elm
numberOfBitsIn : Int -> Int
numberOfBitsIn n =
    ceiling (logBase 2 n)
```

# 3. Generate numbers with same bits or 1 more

One silly thing I did yesterday was generating *all* numbers that have the same bits, even the lower ones.

The goal was to find the next *highest* number, so `n + 1` should be the range's starting point.

Other than that, the basic idea is the same as yesterday:

```elm
generateBits : Int -> List String
generateBits n =
    let
        min =
            n + 1

        max =
            2 ^ (1 + numberOfBitsIn n)
    in
    List.range min max
        |> List.map intToBinary
```

# 4. Getting numbers with matching 1 bits

First, I made this prototype in JavaScript:

```javascript
const n = "101010"
const bin = ["101100", "101101", "101110", "101111", "110000", "110001", "110010", "110011", "110100", "110101", "110110", "110111", "111000", "111001", "111010", "111011", "111100", "111101", "111110", "111111", "1000000", "1000001", "1000010", "1000011", "1000100", "1000101", "1000110", "1000111", "1001000", "1001001", "1001010", "1001011", "1001100", "1001101", "1001110", "1001111", "1010000", "1010001", "1010010", "1010011", "1010100", "1010101", "1010110", "1010111", "1011000", "1011001", "1011010", "1011011", "1011100", "1011101", "1011110", "1011111", "1100000", "1100001", "1100010", "1100011", "1100100", "1100101", "1100110", "1100111", "1101000", "1101001", "1101010", "1101011", "1101100", "1101101", "1101110", "1101111", "1110000", "1110001", "1110010", "1110011", "1110100", "1110101", "1110110", "1110111", "1111000", "1111001", "1111010", "1111011", "1111100", "1111101", "1111110", "1111111", "10000000"]

const matches = bin.reduce((acc, char) => {
	const hasSameNumberOf1s = char
		.split("")
		.filter(n => n === "1")
		.length === 3

	if (hasSameNumberOf1s) {
		acc.push(char)
	}
	
	return acc
}, [])

console.log(bin.length) // 85
console.log(matches.length) // 20
```

Then in Elm, I combined this with `List.head` to get the first element, along with some other small changes, including a utility function for counting 1 bits:

```elm
count1s : String -> Int
count1s binaryNumber =
    binaryNumber
        |> String.toList
        |> List.map String.fromChar
        |> List.filter (\n -> n == "1")
        |> List.length


getNextNumberWithSame1Bits : Int -> String
getNextNumberWithSame1Bits number =
    generateBits number
        |> List.foldl
            (\currentBinaryNumber acc ->
                if count1s currentBinaryNumber == count1s (intToBinary number) then
                    List.append acc [ currentBinaryNumber ]

                else
                    acc
            )
            []
        |> List.head
        |> Maybe.withDefault ""
```

This code shows two things I need help making more elegant:
1. Converting from `Char` to `String`. I just want strings of length 1. :)
2. `List.append acc [ curr ]` looks a bit strange. In JavaScript, I would do `acc.push(curr)` or `[...acc, curr]`
3. Doing `Maybe.withDefault` is a bit tiresome, although it's better than `undefined`.

# 5. The view function

The setup and update function are the same as all other standard `Browser.sandbox` programs, so I won't bother posting them here.

Here's the view function:

```elm
view : Model -> Html Msg
view model =
    div []
        [ input
            [ type_ "number"
            , autofocus True
            , onInput NewNumberEntered
            , value <| String.fromInt model.currentInt
            ]
            []

        -- Int to binary
        , h1 [] [ text "Int to binary" ]
        , text <| String.fromInt model.currentInt ++ ": " ++ intToBinary model.currentInt
        , p [] [ text <| String.fromInt <| numberOfBitsIn model.currentInt ]

        -- Same bits or 1 more
        , div []
            [ h1 [] [ text "Same bits or 1 more:" ]
            , text <|
                (generateBits model.currentInt
                    |> String.join ", "
                )
            ]

        -- Next test
        , h1 [] [ text "Next number is: " ]
        , text <|
            let
                nextBinary =
                    getNextNumberWithSame1Bits model.currentInt

                nextInt =
                    nextBinary
                        |> binaryToInt
                        |> String.fromInt
            in
            nextInt
                ++ " ("
                ++ nextBinary
                ++ ")"
        ]
```

I think it looks a bit messy with all the conversions and joins, but it gets the job done.

# Conclusion

As I suspected, using a binary number package was way nicer than implementing things myself. I'm happier with today's code.

One of the coming days, I'm pretty sure I will visualize these numbers somehow.

When you use the up arrow in the input field, notice how the next number jumps up and down a bit.

See you tomorrow!