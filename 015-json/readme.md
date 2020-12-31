This is day 15 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today I wanted to do some stuff with the JSON from day 9: [Astronomy data from Python in Elm](https://dev.to/kristianpedersen/30daysofelm-day-9-astronomy-data-from-python-in-elm-deployment-difficulties-2i47)

There's no finished code today, and I feel like I'm fumbling around blindly to be honest. 

I've learned a couple of new concepts though, so this isn't a failure at all. :)

Here is today's mess if you're interested: 

# 0. Simple example

Here's a very basic example.

API:

```JSON
{ hiMessage: "hi" }
```

```elm
hi : Decoder String
hi =
  field "hiMessage" string
```

# 1. Describing the data I want

The JSON I want looks like this:

```json
{"Jupiter":{"lightMinutes":49.561547588282494,"xyz":[-15.160997437594864,35.36776769042324,86.01557267383876]},"Mars":{"lightMinutes":7.056627943382205,"xyz":[-10.802377084003577,-7.957103044154623,0.0]},"Mercury":{"lightMinutes":11.873735464944051,"xyz":[-15.39294493449285,5.8815766045335,-15.430849180096907]},"Neptune":{"lightMinutes":251.12126006612468,"xyz":[-200.051138076174,-188.4930229293946,-390.39907178706875]},"Pluto":{"lightMinutes":292.0545551594518,"xyz":[-487.1954814422351,-265.82244414880427,-17.713974776837258]},"Saturn":{"lightMinutes":90.34545293522373,"xyz":[10.90385529195623,67.16589122515714,157.720111144322]},"Sol":{"lightMinutes":8.178862544580388,"xyz":[-3.3688535760154714,10.267169613495522,-11.182551853223776]},"Uranus":{"lightMinutes":159.9896536380283,"xyz":[-300.96106486799965,44.176269302014866,0.0]},"Venus":{"lightMinutes":12.801164839345946,"xyz":[-12.926388560134972,-6.636737189572844,19.52518546405315]}}
```

I could probably re-write the JSON from Python, but I guess it's nice to be able to describe all kinds of JSON.

```elm
type alias Planets =
    List Planet


type alias Planet =
    { planetName : PlanetInfo }


type alias PlanetInfo =
    { lightMinutes : Float
    , xyz : List Float
    }
```

Something like this would be the starting point, but this is as far as I've come today.

I'm not sure if these type aliases will work, I can't get any text to display, and I can't figure out how to debug it, so today's upload is just the repo.

I'll celebrate the new year instead, get a good night's sleep, and hopefully connect the pieces next year. ;)