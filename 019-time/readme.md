This is day 19 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

# Table of contents

- [Table of contents](#table-of-contents)
- [1. About today's project](#1-about-todays-project)
- [2. Time in Elm](#2-time-in-elm)
- [3. What is different from the example code?](#3-what-is-different-from-the-example-code)
  - [3.1 View](#31-view)
- [4. Summary](#4-summary)

# 1. About today's project

https://ellie-app.com/bZcnMkJZvrVa1

The main piece of information I want to convey in this project is distance and time.

The main thing we're working with is light minutes, which tells us how far light travels in a certain number of minutes.

Light years sound a bit weird, but we're already using time for distance. The nearest city from my parents' place is one -hour- away.

What I want to display in this project is `users_current_time - lightMinutes`. If you were observing earth from a given solar system body, how far back in time would you see? 

I don't wanna do too much today, so I'll focus on getting a hardcoded proof of concept working first.

# 2. Time in Elm

As a starting point, I just copied and pasted this code: https://guide.elm-lang.org/effects/time.html

In JavaScript, I'm used to the `Date` object, which has some weird quirks:

```javascript
const d = new Date()
// Checking if it's the 24th day of the 12th month
const isXmas = d.getDate() === 24 && d.getMonth() === 11 // lol wtf

const year = d.getYear() 
// Returns 121! You need to use d.getFullYear() to get 2021 :D
```

Elm on the other hand uses Posix time:

> With POSIX time, it does not matter where you live or what time of year it is. It is just the number of seconds elapsed since some arbitrary moment (in 1970). Everywhere you go on Earth, POSIX time is the same.

# 3. What is different from the example code?

Except from the view, I haven't done anything. I just want to subtract X minutes from the time, so there's no need in over-complicating things.

I could have chosen to update the time less frequently. We're only displaying the hours and minutes, so updating it every second means that only one of 60 ticks will result in a view update.

However, I kept everything as is. Things would look really weird if the GUI and the user's computer didn't change the minutes at the same time.

## 3.1 View

```elm
view : Model -> Html Msg
view model =
    let
        lightMinutes =
            75

        currentHour =
            Time.toHour model.zone model.time

        currentMinute =
            Time.toMinute model.zone model.time

        newMinutes =
            (currentHour * 60) + currentMinute - lightMinutes

        h =
            floor (toFloat newMinutes / 60)
                |> String.fromInt
                |> String.padLeft 2 '0'

        m =
            remainderBy 60 newMinutes
                |> String.fromInt
                |> String.padLeft 2 '0'
    in
    h1 [] [ text <| h ++ ":" ++ m ]
```

`currentHour` and `currentMinute` look different from JavaScript, but I think it's pretty clear what they do.

As I'm writing this, the time is 17:50. A time difference of 75 minutes means we should get `16` for the hours and `35` for the minutes.

To get the new time, we can first find out how many minutes have passed today since midnight. 

If we're sticking with 17:50, the total number of minutes would be ((17 * 60) + 50). We then subtract the lightminutes from that number.

* 17 * 60 + 50 = 1070
* We subtract 75 minutes, which is 995.
* `floor 995 / 60` = 16
* `remainderBy 60 995` = 35
* The new time is 16:35

If the number is less than 10, we use `String.padLeft` to add a 0. Make sure to wrap the 0 character in single quotes, or Elm will think it's a character, not a string.

# 4. Summary

I had hoped this would be a simple exercise, and I was right. This will be very useful later on. 

Some funky numbers are displayed the first second, but I'm too tired to fix that now.

See you tomorrow!