module Main exposing (main)

import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Json.Decode exposing (..)


person : String
person =
    """ 
    {
        "person": {
            "name": "Kristian",
            "age": 31
        }
    }
"""


howToGetName : Decoder String
howToGetName =
    field "person" (field "name" string)


howToGetAge : Decoder Int
howToGetAge =
    field "person" (field "age" int)


howToGetPerson : Decoder Person
howToGetPerson =
    map2 Person
        (field "name" string)
        (field "age" int)


type alias Person =
    { name : String
    , age : Int
    }


getInfo : String -> Decoder a -> String
getInfo sourceJSON decoder =
    case decodeString decoder sourceJSON of
        Ok result ->
            result |> Debug.toString

        Err e ->
            e |> Debug.toString


main : Html msg
main =
    div []
        [ text (getInfo person howToGetName)
        , text (getInfo person howToGetAge)
        , text (getInfo person howToGetPerson)
        ]
