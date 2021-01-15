This is day 29 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Yesterday was fun, but I'm really exhausted today. Maybe it's because I'm almost done with the 30 days, and I need a break. 

I sure am glad I didn't commit to 100 days. :D

This is the most unmotivated I've felt since starting this challenge, so today I decided to write about map, filter and reduce. 

Going from for loops to these functions really improved my code and my experience, and I was happy to see them in Elm too.

- [1. In depth documentation](#1-in-depth-documentation)
- [2. Array.map / List.map](#2-arraymap--listmap)
	- [2.1. JavaScript](#21-javascript)
	- [2.2. Elm](#22-elm)
- [3. Array.map / List.indexedMap](#3-arraymap--listindexedmap)
	- [3.1. JavaScript](#31-javascript)
	- [3.2. Elm](#32-elm)
- [4. Array.filter / List.filter](#4-arrayfilter--listfilter)
	- [4.1. JavaScript](#41-javascript)
	- [4.2. Elm](#42-elm)
- [5. Array.reduce / List.foldl](#5-arrayreduce--listfoldl)
	- [5.1. JavaScript](#51-javascript)
	- [5.2. Elm](#52-elm)
- [6. Conclusion](#6-conclusion)

# 1. In depth documentation

I'm only going to explain some simple use cases. Afterwards, make yourself some hot beverage, and read these:

JavaScript array methods: 
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array#instance_methods

Elm list functions:
https://package.elm-lang.org/packages/elm/core/latest/List

# 2. Array.map / List.map

Applies a function to each element in a list.

## 2.1. JavaScript

```javascript
[1, 2, 3].map(number => number + 1) // [2, 3, 4]
```

## 2.2. Elm

In Elm, the list usually comes last.

```elm
List.map (\number -> number + 1) [1, 2, 3] -- [2, 3, 4]
```

However, there's a nicer way to do this.

Using the pipeline `|>`, the result to its left gets passed as the last argument to the following function:

```elm
[1, 2, 3] |> List.map (\number -> number + 1) -- [2, 3, 4]
```

I think this syntax is intuitive, and very nice to look at.

# 3. Array.map / List.indexedMap

This is just how the standard JavaScript map function works.

Elm has two map functions: `List.map` with no index, and `List.indexedMap`.

## 3.1. JavaScript

```javascript
const languages = ["JavaScript", "Elm", "Scratch"]

// Using parentheses to get implicit return on its own line
const withIndex = languages.map((language, index) => (
    `${index}: ${language}`
))

console.log(withIndex) 
// ["0: JavaScript", "1: Elm", "2: Scratch"]
```

## 3.2. Elm

```elm
languages = ["JavaScript", "Elm", "Scratch"]

withIndex = languages
    |> List.indexedMap (\index language -> 
        (index |> Debug.toString) ++ ": " ++ language
    )
```

As you can see, the order of index and element are the other way around in Elm.

Also, Elm doesn't have very nice string interpolation, and you have to explicitly convert other types to a string.

# 4. Array.filter / List.filter

Keeps the items that return true. 

The name "filter" is kind of ambiguous to me, so think of it as `keepIfTrue` instead.

## 4.1. JavaScript

The `=> number <=` part looks weird, so I added a second option that looks nicer to me.

```javascript
[1, 2, 3, 4, 5].filter(number => number <= 3) // [1, 2, 3]

[1, 2, 3, 4, 5].filter(number => (
    number <= 3
))
```


## 4.2. Elm

```elm
[1, 2, 3, 4, 5] |> List.filter (\number -> number <= 3)
```

Note that Elm's filter function doesn't provide an index.

# 5. Array.reduce / List.foldl

Reduces an array into one single variable. 

JavaScript has `reduce` and `reduceRight`, while Elm has `foldl` and `foldr`. Left and right just specify if we're looping from the beginning or the end of the list.

In the beginning, I just thought of `reduce` as the way you get a sum, but now I want to use it for everything. 

It's not a replacement for more readable standard functions, although that can be very fun. Anyway:

## 5.1. JavaScript

We have a variable `total`, which will be updated from inside a loop that's going through an array.

Many people use the term `accumulator`, which sounds more fancy than `total`.

Here's an example *without* `reduce`:

```javascript
let array = [1, 2, 3, 4, 5]
let total = 0 // Could also be a string, array, object, etc.

for (const item of array) {
    total = total + item
}

console.log(total) // 15
```

However, other parts of the code might use the accumulator, so it's safer to let `reduce` handle it:

```javascript
const sumOf1to5 = [1, 2, 3, 4, 5].reduce((total, item) => {
    return total + item
}, 0)

console.log(sumOf1to5) // 15
```

`total` refers to `0`, which is the initial value, and `item` is each separate value in the array.

Also, the really cool people don't use variable names that make sense:

```javascript
const sumOf1to5 = [1, 2, 3, 4, 5].reduce((a, b) => a + b) // 15
```

## 5.2. Elm

Firstly, Elm has its own sum and product functions

```elm
List.sum [1, 2, 3, 4, 5] -- 15

List.sum (List.range 1 100) -- 5050

List.product (List.range 1 5) -- 120
```

`List.foldl` works the same way if you want:

```elm
[1, 2, 3, 4, 5] |> List.foldl (\item total -> total + item) 0
```

Beyond that, you can do a bunch of crazy stuff, but I'm not in the mood for that now.

# 6. Conclusion

I hope this helped, or maybe even steered you away from for loops.

map, filter and reduce are a lot of fun, and they really improved my JavaScript code and experience when I learned them.

See you tomorrow!