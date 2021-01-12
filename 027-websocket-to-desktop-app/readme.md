This is day 27 of my [30 day Elm challenge](https://dev.to/kristianpedersen/30-days-of-elm-intro-2lo2)

Today we're sending data back and forth between JavaScript and TouchDesigner, using web sockets and ports! We'll compile `Main.elm` to `main.js`, and add a few additional lines of JavaScript in `index.html`.

TouchDesigner might be the coolest programming environment out there. It's like having a mix of After Effects, basic 3D software, Python, and have all changes being reflected instantly.

https://derivative.ca/download

Here's what today's project looks like:

![Screenshot of browser and TouchDesigner](https://dev-to-uploads.s3.amazonaws.com/i/2jzmvci7eadoq4ticm99.png)

* The top row is a 1x1 grayscale noise texture (0-1). We then get its red channel `r` and convert it to a number. Any value changes trigger the code inside `chopexec1`.
* The other important part here are the two `webserver` nodes. The bottom one has Python code in it.
* `constant1` receives our Elm app's slider value! `lag1` applies smoothing to it, which is very useful for inputs like mouse movements, or sensor data from an Arduino.

The slider value is one step behind in TD, but it's good enough for me!

**If you want to learn TouchDesigner, I highly recommend going through [Bileam Tschepe's fantastic beginner videos on YouTube](https://www.youtube.com/playlist?list=PLFrhecWXVn5862cxJgysq9PYSjLdfNiHz).**

A lot of the TouchDesigner setup today is taken from this tutorial: https://thenodeinstitute.org/courses/webserver-dat-level-1/lessons/setting-up-the-webserverdat/topic/create-a-webserverdat/

I'm still a TouchDesigner beginner, so if you have any improvement suggestions, I would be very happy to hear those!

- [1. Main.elm](#1-mainelm)
- [2. index.html / Compiling Main.elm with live reload](#2-indexhtml--compiling-mainelm-with-live-reload)
- [3. Brief explanation of TouchDesigner data types (CHOP/DAT/TOP)](#3-brief-explanation-of-touchdesigner-data-types-chopdattop)
- [4. TouchDesigner server](#4-touchdesigner-server)
- [5. Sending data from TouchDesign on value change](#5-sending-data-from-touchdesign-on-value-change)

# 1. Main.elm

Today's Elm program is a simpler version of the [Ports example in the guide](https://guide.elm-lang.org/interop/ports.html).

There's some stuff in the code I wouldn't have remembered by heart, so I might have to revisit it later on. I find it fairly easy to read though, so I'm not worried:

```elm
port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- PORTS


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { sliderValue : String
    , noiseValueFromTD : String
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { sliderValue = "50", noiseValueFromTD = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReceivedNoise String
    | NewSliderValue String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedNoise noiseValue ->
            ( { model | noiseValueFromTD = noiseValue }, Cmd.none )

        NewSliderValue v ->
            ( { model | sliderValue = v }, sendMessage model.sliderValue )


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver ReceivedNoise



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| "From TouchDesigner: " ++ model.noiseValueFromTD ]
        , input [ type_ "range", onInput NewSliderValue, Html.Attributes.min "0", Html.Attributes.max "100" ] []
        , p [] [ text <| "Slider value is " ++ model.sliderValue ]
        ]
```

# 2. index.html / Compiling Main.elm with live reload

Basically, `Main.elm` will be compiled to `main.js`, which is referenced inside `index.html`.

Some of the HTML is copied from the [Ports guide](https://guide.elm-lang.org/interop/ports.html), and some of it is taken from the [NODE Institute tutorial](https://thenodeinstitute.org/courses/webserver-dat-level-1/lessons/setting-up-the-webserverdat/topic/create-a-webserverdat/).

In the project root, I set up two terminals:

1. `nodemon --exec elm make --output=main.js`, which re-compiles the Elm file when I hit `CMD+S`.
2. `live-server` - reload browser on file change

If you don't have `nodemon` or `live-server`, get [Node.js](https://nodejs.org/en/) and run `npm install -g nodemon live-server`.

At first I tried running `elm-live src/Main.elm`, which is usually great for other Elm projects, but it overwrote my `index.html` file.

One important thing I've changed here is the WebSocket URL, which in our case is now `ws://localhost:9980`:

```html
<!DOCTYPE HTML>
<html>

<head>
	<meta charset="UTF-8">
	<title>Elm + Websockets</title>
	<script type="text/javascript" src="main.js"></script>
</head>

<body>
	<div id="myapp"></div>
</body>

<script type="text/javascript">
	const app = Elm.Main.init({
		node: document.getElementById('myapp')
	});

	const socket = new WebSocket('ws://localhost:9980');

	app.ports.sendMessage.subscribe(function sendToTD (message) {
		socket.send(message);
	});

	socket.addEventListener("message", function receiveFromTD (event) {
		app.ports.messageReceiver.send(event.data);
	});
</script>

</html>
```

The `app` constant is just standard boilerplate. `app.ports.sendMessage.subscribe` is quite a mouthful, which is why I named the function `sendToTD`.

Currently, we're just sending one value. I guess if we wanted to be specific, we would have to set up Elm to send something like this: `{ op = "constant1", value = sliderValue }`.

Now we have everything we need in the browser - let's head over to TouchDesigner!

# 3. Brief explanation of TouchDesigner data types (CHOP/DAT/TOP)

TouchDesigner is a node-based programming tool for Windows and MacOS, which feels like a realtime version of After Effects + Python, with some 3D capabilities.

Only boxes of the same data type can be connected, although they can be converted.

There are a couple of other data types in TD, but these are the ones I'll mention today:

* CHOP (Channel Operators): Numbers
* DAT (Data operators): Strings/tables/code/text
* TOP (Texture operators): Image data (computed on the GPU)

These all have separate menus, which are accessed by double-clicking anywhere, and hitting `Tab` to cycle between the different menus.

# 4. TouchDesigner server

Add a `Web Server` DAT, and set its active status to `on`. Hit `p` if its parameters are hidden.

This will set up a web socket server on localhost:9980.

Expand Web Server by pressing the pink arrow on its bottom right, and edit the code by hitting `CTRL+E`. A lot of this code is not needed, so I replaced it with a simplified version of the Node Academy tutorial code:

```python
# This code goes in webserver1_callbacks

def onHTTPRequest(webServerDAT, request, response):
    target_operator = op(request['uri'])

    if target_operator.isDAT:
        response['data'] = target_operator.text
    if 'data' in response:
        response['statusCode'] = 200  # OK
        response['statusReason'] = 'OK'

    return response

# Slider value from Elm comes in here (gets converted from String to Int automatically - yikes! :D)
def onWebSocketReceiveText(webServerDAT, client, data):
    op('constant1').par.value0 = data
    return

def onWebSocketOpen(webServerDAT, client, uri):
    op('table1').appendRow(client) # Adds connected address to our list
    return


def onWebSocketClose(webServerDAT, client):
    op('table1').deleteRow(client)
    return
```

For this code to work, we need a `Constant` CHOP with name "constant1", and a `Table` DAT with name "table1". Both of these names are automatic when you create a node.

We can now receive web socket messages from the browser, but how about sending messages?

# 5. Sending data from TouchDesign on value change

To send continuous data, we can use a `CHOP Execute` DAT. 

Make sure `Value Change` is set to `On`, enter the name of the CHOP you want to toggle data sending (`topto1` in my case), and add this code:

```python
def onValueChange(channel, sampleIndex, val, prev):
    data = op("topto1")[0]
    client = op('table1')[1, 0].val
    op('webserver1').webSocketSendText(client, data)
    return
```

That's pretty much it, as far as I can see. You can actually also get images from TouchDesigner into the browser, but given the data amount, I guess still images are the best choice for this.

Very cool! :D