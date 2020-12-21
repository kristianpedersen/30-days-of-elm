module Main exposing (init, main, update, view)

import Browser
import Html exposing (Html, button, div, hr, input, label, p, text)
import Html.Attributes exposing (checked, style, type_)
import Html.Events exposing (onClick)


main : Program () Board Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Checkbox =
    { x : Int, y : Int, checked : Bool }


type alias Board =
    { checkboxes : List Checkbox }


init : Board
init =
    { checkboxes =
        List.indexedMap
            (\index _ ->
                { x = remainderBy 5 index
                , y = index // 5
                , checked = remainderBy 2 index == 0
                }
            )
            (List.repeat 25 { x = 0, y = 0, checked = True })
    }


type Msg
    = PressButton ( Int, Int )
    | ActivateEasyMode


toggleSelfAndNeighbors : Int -> Int -> Checkbox -> Checkbox
toggleSelfAndNeighbors x y checkbox =
    let
        xDistance =
            abs (checkbox.x - x)

        yDistance =
            abs (checkbox.y - y)

        isNeighborOrEventTarget =
            (xDistance == 0 && yDistance == 0)
                || (xDistance == 1 && yDistance == 0)
                || (xDistance == 0 && yDistance == 1)
    in
    if isNeighborOrEventTarget then
        { checkbox | checked = not checkbox.checked }

    else
        checkbox


makeAMove : Int -> Int -> Board -> Board
makeAMove x y model =
    { model | checkboxes = List.map (toggleSelfAndNeighbors x y) model.checkboxes }


checkIfEasy : Checkbox -> Checkbox
checkIfEasy checkbox =
    { checkbox
        | checked =
            (checkbox.x == 1 && checkbox.y == 2)
                || (checkbox.x == 2 && checkbox.y == 1)
                || (checkbox.x == 2 && checkbox.y == 2)
                || (checkbox.x == 2 && checkbox.y == 3)
                || (checkbox.x == 3 && checkbox.y == 2)
    }


update : Msg -> Board -> Board
update msg model =
    case msg of
        PressButton xyTuple ->
            makeAMove (Tuple.first xyTuple) (Tuple.second xyTuple) model

        ActivateEasyMode ->
            { model | checkboxes = List.map checkIfEasy model.checkboxes }


htmlIf : Bool -> Html msg -> Html msg
htmlIf condition element =
    if condition then
        element

    else
        text ""


row : Html msg
row =
    hr [ style "visibility" "hidden", style "margin" "0.5rem 0" ] []


generate5x5CheckboxBoard : Board -> List (Html Msg)
generate5x5CheckboxBoard model =
    List.indexedMap
        (\index checkbox ->
            label
                [ style "border" "1px solid #999"
                , style "border-right" "none"
                , style "margin" ".5rem"
                ]
                [ input
                    [ type_ "checkbox"
                    , onClick (PressButton ( checkbox.x, checkbox.y ))
                    , checked checkbox.checked
                    , style "transform" "scale(2)"
                    ]
                    []
                , htmlIf (remainderBy 5 index == 4) row
                ]
        )
        model.checkboxes


numberOfCheckedItems : Board -> Int
numberOfCheckedItems model =
    List.length (List.filter (\cb -> cb.checked) model.checkboxes)


view : Board -> Html Msg
view model =
    div [ style "padding" "1rem" ]
        [ button
            [ onClick ActivateEasyMode
            , style "padding" "1rem"
            , style "margin-bottom" "1rem"
            ]
            [ text "Easy mode" ]
        , div [] <| generate5x5CheckboxBoard model
        , p []
            [ text
                (let
                    checkedCount =
                        numberOfCheckedItems model
                 in
                 if checkedCount == 0 then
                    "You win!"

                 else
                    String.fromInt checkedCount ++ "/25"
                )
            ]
        ]
