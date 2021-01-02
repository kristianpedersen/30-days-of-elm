module Main exposing (main)

import Html exposing (..)
import Json.Decode exposing (..)



-- Data and decoder


type alias Planet =
    { lightMinutes : Float, xyz : List Float }


hardcodedData : String
hardcodedData =
    """
{
    "Jupiter":{
        "lightMinutes":49.561547588282494,
        "xyz":[-15.160997437594864,35.36776769042324,86.01557267383876]
    },
    "Mars":{
        "lightMinutes":7.056627943382205,
        "xyz":[-10.802377084003577,-7.957103044154623,0.0]
        },
    "Mercury":{
        "lightMinutes":11.873735464944051,
        "xyz":[-15.39294493449285,5.8815766045335,-15.430849180096907]
        },
    "Neptune":{
        "lightMinutes":251.12126006612468,
        "xyz":[-200.051138076174,-188.4930229293946,-390.39907178706875]
        },
    "Pluto":{
        "lightMinutes":292.0545551594518,
        "xyz":[-487.1954814422351,-265.82244414880427,-17.713974776837258]
        },
    "Saturn":{
        "lightMinutes":90.34545293522373,
        "xyz":[10.90385529195623,67.16589122515714,157.720111144322]
        },
    "Sun":{
        "lightMinutes":8.178862544580388,
        "xyz":[-3.3688535760154714,10.267169613495522,-11.182551853223776]
        },
    "Uranus":{
        "lightMinutes":159.9896536380283,
        "xyz":[-300.96106486799965,44.176269302014866,0.0]
        },
    "Venus":{
        "lightMinutes":12.801164839345946,
        "xyz":[-12.926388560134972,-6.636737189572844,19.52518546405315]
        }
    }
"""


planetDecoder : String -> Decoder Planet
planetDecoder planetName =
    field planetName
        (map2 Planet
            (field "lightMinutes" float)
            (field "xyz" (list float))
        )



-- View


planetDiv : String -> Planet -> Html msg
planetDiv p { lightMinutes, xyz } =
    div []
        [ h1 [] [ text p ]
        , text ((lightMinutes |> round |> String.fromInt) ++ " light minutes away")
        , br [] []
        , div [] <| (xyz |> List.map (\n -> text ((n |> String.fromFloat) ++ ", ")))
        ]


showPlanetOrError : String -> Html msg
showPlanetOrError planetName =
    case
        decodeString (planetDecoder planetName) hardcodedData
    of
        Ok planet ->
            planetDiv planetName planet

        Err err ->
            pre []
                [ text "Oops: "
                , br [] []
                , text ("    " ++ Debug.toString err)
                ]


main : Html msg
main =
    div [] <|
        List.map (\planet -> showPlanetOrError planet)
            [ "Sun"
            , "Mercury"
            , "Venus"
            , "Mars"
            , "Jupiter"
            , "Saturn"
            , "Uranus"
            , "Neptune"
            , "Pluto"
            ]
