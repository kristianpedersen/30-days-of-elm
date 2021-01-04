This is day 19 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

# Table of contents

# 1. About today's project

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

        newHours =
            currentHour - floor (lightMinutes / 60) |> String.fromInt

        newMinutes =
            remainderBy 60 (floor lightMinutes) |> String.fromInt
    in
    h1 [] [ text <| newHours ++ ":" ++ newMinutes ]
```

`currentHour` and `currentMinute` look different from JavaScript, but I think it's pretty clear what they do.

As I'm writing this, the time is 17:50. A time difference of 75 minutes means we should get `16` for the hours and `35` for the minutes.

To convert minutes to hours, we do `minutes / 60` and floor it.

To get the minutes, we can just take `remainderBy 60 75` (`75 % 60` in JavaScript) and get 15.

The reason I'm flooring the lightMinutes in `newMinutes` is because Elm's `remainderBy` function only accepts `Int`s. 

It's precise enough for this case, and otherwise I could have gotten the decimal part by doing `lightMinutes - (floor lightMinutes)`.

The full example code can be found here: []

# 4. Summary

I had hoped this would be a simple exercise, and I was right. This will be very useful later on. See you tomorrow!