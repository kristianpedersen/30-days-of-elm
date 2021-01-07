This is day 22 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Code+demo: https://ellie-app.com/c2kXwQbnFbja1

- [1. About today's project](#1-about-todays-project)
- [2. Can number A be divided to get number B?](#2-can-number-a-be-divided-to-get-number-b)
- [3. Get the sum of all numbers from 1 to n](#3-get-the-sum-of-all-numbers-from-1-to-n)
- [4. Get a list of 1 to n (also with partial application example)](#4-get-a-list-of-1-to-n-also-with-partial-application-example)
- [5. Time since midnight in milliseconds](#5-time-since-midnight-in-milliseconds)
- [6. Formatting large numbers](#6-formatting-large-numbers)
- [7. Remove all spaces from a string](#7-remove-all-spaces-from-a-string)
- [8. Conclusion](#8-conclusion)

# 1. About today's project

I like doing small [CodeWars](http://codewars.com/) challenges sometimes, just to practice some basics. 

They're often quite simple, but sometimes the simplicity can be deceiving, and occasionally I find myself not having read the requirements well enough.

My "[next binary number with same number of 1's](https://dev.to/kristianpedersen/30daysofelm-day-11-next-binary-number-with-same-number-of-1-s-34gg)" was a CodeWars challenge. I also wrote about [4 CodeWars challenges](https://dev.to/kristianpedersen/30daysofelm-day-14-four-codewars-katas-3nck) on day 14.

While it's very good to push yourself like I've done lately, it can also be good to get some easy wins, while also picking up a new thing or two.

I hope today's writedown can be a nice resource for other beginners. Some Elm beginners immediately want to decode JSON and get into complex types, while others just want to know how to make an array of numbers from 1 to 100 (that's me).

*Note: I usually skip a few CodeWars challenges, usually because they're poorly written, or they don't interest me.*

# 2. Can number A be divided to get number B?

All we have to do is check if there's a remainder or not.

The remainder of 10 / 2 is 0, while the remainder of 9 / 2 is 1.

```elm
checkIfFactor : Int -> Int -> Bool
checkIfFactor factor base =
    remainderBy base factor == 0

checkIfFactor 10 2 -- True
checkIfFactor 9 2 -- False
        
```

A slightly shorter solution would be this:

```elm
checkForFactor : Int -> Int -> Bool
checkForFactor a b = 
      modBy b a == 0
```

The difference between modBy and remainderBy has to do with negative numbers: https://package.elm-lang.org/packages/elm/core/latest/Basics#modBy

# 3. Get the sum of all numbers from 1 to n

I'm sure I can solve this one easily, but it's still good to practice the very basics, and there might be solutions I haven't thought of.

Here's what I came up with, which is very easy to read:

```elm
summation : Int -> Int
summation n =
    List.range 1 n |> List.sum
```

I saw some other interesting ones. I know which approach I prefer.

```elm
summation : Int -> Int
summation n =
  if modBy 2 n == 0 then
    n // 2 * (n + 1)
  else
    (n - 1) // 2 * (n + 1) + (n  + 1) // 2
```

```elm
summation : Int -> Int
summation n = round (toFloat n / toFloat 2 * toFloat (n + 1))
```

# 4. Get a list of 1 to n (also with partial application example)

The next one seemed even simpler one than the previous, but I decided to try it anyway. I was confident my solution would be the shortest and simplest.

>Count the monkeys!
You take your son to the forest to see the monkeys. You know that there are a certain number there (n), but your son is too young to just appreciate the full number, he has to start counting them from 1.

>As a good parent, you will sit and count with him. Given the number (n), populate an array with all numbers up to and including that number, but excluding zero.

>For example:
monkeyCount(10) // --> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
monkeyCount(1) // --> [1]

And here's my solution. Easy!

```elm
monkeyCount : Int -> List Int
monkeyCount x = List.range 1 x
```

But then to my surprise and delight, I found an even shorter solution! You can use partial application:

```elm
monkeyCount2 : Int -> List Int
monkeyCount2 = List.range 1
```

To understand what's going on, let's look at the type annotation for `List.range`:

> range : Int -> Int -> List Int

So when we store `List.range 1`, we've supplied 1 argument, and another one remains. What we get is a function that looks like this:

> monkeyCount2 : Int -> List Int

I still think my solution is easier to read, but it's a good example of partial application.

Then you have examples that go the other way. No comment:

```elm
monkeyCount : Int -> List Int
monkeyCount = monkeyCountHelper []

monkeyCountHelper : (List Int) -> Int -> List Int
monkeyCountHelper c x = 
  case x of
    0 ->
      c
    _ ->
      monkeyCountHelper (x :: c) (x-1)
```

# 5. Time since midnight in milliseconds

I eventually want to deal with time in my astronomy project. I've already written the most important functions, but it's good to just get this stuff into my head.

Given a number of hours, minutes and seconds, return the number of milliseconds that have passed since midnight.

* Seconds to milliseconds = seconds * 1000
* Minutes to milliseconds = minutes * 1000 * 60
* Hours to milliseconds = hours * 1000 * 60 * 60

Going by this, I decided to submit this solution:

```elm
past : Int -> Int -> Int -> Int
past h m s = 
    (s * 1000) 
  + (m * 1000 * 60) 
  + (h * 1000 * 60 * 60)
```

I could have written 60000 and 3600000, but again, I think that affects readability.

By far the most interesting solution was this one:

```elm
expand : Int -> Int
expand =
  (*) 60

past : Int -> Int -> Int -> Int
past h m s =
  h
    |> expand
    |> (+) m
    |> expand
    |> (+) s
    |> (*) 1000
```

:D

# 6. Formatting large numbers

The resulting number of milliseconds since midnight is a big number. These are hard to read, so it's nice to add some formatting, like this:

```javascript
const n = 1234567890
const formatted = n.toLocaleString("NO") // "1 234 567 890"
```

I found [cuducos/elm-format-number](https://package.elm-lang.org/packages/cuducos/elm-format-number/latest/) and included it in my project.

First I did `elm install cuducos/elm-format-number`, and then these were the imports I used:

```elm
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Decimals(..), usLocale)
```

At first, I was disappointed that it adds `.00` to the end by default, but that's easy to fix:

```elm
-- 49,062,000.00
toFloat (millisecondsSinceMidnight 13 37 42)
    |> format usLocale


-- 49,062,000
toFloat (millisecondsSinceMidnight 13 37 42)
    |> format usLocale
```

# 7. Remove all spaces from a string

In advance, I think this should just be `split " " |> join ""` or something like that.

Here's what these two functions do:

`split " "` will add a new list item for every space it comes across.

`"cat dog human"` becomes `["cat", "dog", "human"]`. The spaces aren't included - they're used as delimiters.

`String.split "***" "a***b***c"` becomes `["a", "b", "c"]`.

`String.join` turns an array of strings into one string, and adds a character (or none) between each item. `String.join "-" ["o", "m", "g"]` becomes `"o-m-g"`. 

Instead of the dash, you can also pass an empty string, like I did:

```elm
noSpace : String -> String
noSpace s =
    s |> String.split " " |> String.join ""
```

After submitting my solution, I saw a more elegant approach:

```elm
noSpace2 : String -> String
noSpace2 s =
    s |> String.replace " " ""
```

JavaScript has this functionality as well, but I keep forgetting about it. :)

```javascript
"a b c".replaceAll(" ", "-") // a-b-c
```

# 8. Conclusion

I really enjoyed practicing some basics, and I was excited to discover a couple of solutions I wouldn't have thought of.

See you tomorrow!