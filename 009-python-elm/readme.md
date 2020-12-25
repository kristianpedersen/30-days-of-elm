This is day 9 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

# About today's project

Goal: Deploy a project with a Python backend and Elm frontend.

Demo: https://elmspacekp.herokuapp.com/ (Might take a few seconds if the Heroku dyno is asleep)

Raw data: https://elmspacekp.herokuapp.com/info

Note: The 25th isn't a very big deal in Norway. We celebrated yesterday! :)

# Background

A while back, I made a Python program that uses `astropy` to get the planets' exact distances from Earth at the current time. 

The Sun for example is 8 light minutes away, which means that we're actually seeing what it looked like 8 minutes ago. Most of the planets are further away than that! :D

I improved my old code slightly, so today has been more of a Python/Heroku day, really.

Today, the goal is to just get the Python data into Elm.

# 0. Deployment is confusing

Man, this was harder than expected.

Once I finally did get it up and working on Heroku, I tried doing it again just to be sure, and couldn't get the Python part working on the 2nd URL.

I would love to have a nice step-by-step list to let you know how I did finally did it, but that will have to come at a later time.

I don't know if I'm confused by Heroku or Python, but it's such a weird feeling to have something working fine on my machine, and failing just because I run it somewhere else.

Is this what Docker solves?

# 1. The Python program

## 1.1 Simple example

This is an extended version of an example from the `astropy` documentation:

```python
from astropy import units as u
from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body

t = Time("2014-09-22 23:22")
loc = EarthLocation.of_site('greenwich')

with solar_system_ephemeris.set('builtin'):
    jup = get_body('jupiter', t, loc)

    print(jup.distance)
    print(jup.distance.to(u.lightyear))
    print(jup.distance.to(u.lightyear) * (1 * u.year).to(u.min))
    print(jup.distance.to(u.lightyear).value * (1 * u.year).to(u.min).value)
```

Earlier today, `jup.distance` gave me km, but now it gave me AU 

(1 AU = average distance between Earth and Sun)

`jup.distance.to(u.lightyear)` returns `9.398733376888508e-05 lyr`, which means `9.398 * 0.000001`. To get rid of the unit (`lyr`), we add `.value`.

On to today's main program:

## 1.2 Imports and setup

A lot of this is taken directly from the documentation: https://docs.astropy.org/en/stable/coordinates/solarsystem.html

```python
from datetime import timedelta
from astropy import units as u
from astropy.coordinates import get_body, get_sun
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.time import Time

from flask import Flask, send_from_directory
app = Flask(__name__)

import math

planets = [
    "Mercury",
    "Venus",
    "Mars",
    "Jupiter",
    "Saturn",
    "Uranus",
    "Neptune",
    "Pluto",
]

current_time = Time(Time.now())
location = EarthLocation.of_site('greenwich')
```

`astropy` takes care of astronomy tasks and unit conversions. It's a wonderful package!

`flask` will do two things:
* Serve `index.html` at the root level (localhost:5000)
* Serve the API at another URL (localhost:5000/get-info:mars for example)

I know [Pluto isn't a planet](https://solarsystem.nasa.gov/planets/dwarf-planets/pluto/overview/), but I still included it anyway. 

At my previous job, I did a lot of planetarium shows for both kids and adults, and the kids in particular would almost always ask about Pluto.

Greenwich is just one of many other available observatories you can use. It doesn't make any difference in my case, but it would be cool to list a user's closest observatory.

## 1.3 Serve Elm client

```python
@app.route('/')
def show_client():
    return send_from_directory("client", "index.html")
```

My Elm client is `index.html` copied from https://guide.elm-lang.org/interop/

`main.js` is compiled this way: `elm make src/Main.elm --output=main.js`.

## 1.4 Get planet data

This is the most fun part. By visiting a URL, I can get back a bunch of planet info from my Python program!

First a couple of utility functions, and then the `get_planet_info` function:

```python
def convert_km_to_light_minutes(distance):
    return (distance.to(u.lightyear).value * (1 * u.year).to(u.min)).value


def get_xyz(p):
    # Formula from: https://math.stackexchange.com/a/1273714

    (ra_hours, ra_minutes, ra_seconds) = p.ra.hms
    dec_degrees = p.dec.deg
    (_, dec_minutes, dec_seconds) = p.dec.hms

    A = (ra_hours * 15) + (ra_minutes * 0.25) + (ra_seconds * 0.004166)
    B = (abs(dec_degrees) + (dec_minutes / 60) +
         (dec_seconds / 3600)) * (1 if dec_degrees < 0 else 0)
    C = p.distance.to(u.lightyear).value

    X = (C * math.cos(B)) * math.cos(A)
    Y = (C * math.cos(B)) * math.sin(A)
    Z = C * math.sin(B)

    return (X * 1_000_000, Y * 1_000_000, Z * 1_000_000)

@app.route('/info')
def get_planet_info():
    planet_info = {}
    with solar_system_ephemeris.set('de432s'):
        for planet in planets:
            p = get_body(planet, current_time, location)

            planet_info[planet] = {
                "lightMinutes": convert_km_to_light_minutes(p.distance),
                "xyz": get_xyz(p)
            }

            sun = get_sun(current_time)
            planet_info["Sol"] = {
                "lightMinutes": convert_km_to_light_minutes(sun.distance),
                "xyz": get_xyz(sun)
            }

    return planet_info


if __name__ == "__main__":
    app.run(host='0.0.0.0')
```

That `app.run` line at the end looked different when I started, but all the Heroku googling just had me change it along the way.

I might use the XYZ coordinates later. :)

`get_planet_info` returns data as JSON, which looks like this:

```JSON
{
	"Jupiter": {
		"lightMinutes": 49.53385297772392,
		"xyz": [
			-10.429181070285958,
			35.02342564750956,
			86.79910536500718
		]
	},
	// ... all the other planets
}
```

My plan for another day is to use this information to:

1. Let you know at if you observe Jupiter at 11:49, you will actually see what it looked like at 11:00.
2. I want to show the planets' angles in relation to the sun. I hope the `xyz` numbers will be good enough.

# 2. Elm client

The project root directory is for the Python program.

My Elm program is in its own sub-folder called `client`.

Today's Elm program is really boring, to be honest. If it weren't for the button, you could just switch the URL from this example to "http://localhost:5000/info" :D

https://guide.elm-lang.org/effects/http.html

```elm
module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (Html, button, div, pre, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Cmd.none
    )



-- UPDATE


type Msg
    = GotText (Result Http.Error String)
    | ButtonClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

        ButtonClicked ->
            ( Loading
            , Http.get
                { url = "https://elmspacekp.herokuapp.com/info"
                , expect = Http.expectString GotText
                }
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            text "oi"

        Loading ->
            button [ onClick ButtonClicked, style "padding" "1rem" ] [ text "Load data from Python backend" ]

        Success fullText ->
            pre [] [ text fullText ]
```

I'm really tired from all the confusion today, so please excuse me while I go to bed. :D