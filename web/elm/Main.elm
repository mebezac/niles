module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html.Events exposing (..)

app : StartApp.App Model
app =
  StartApp.start
  { init = init,
    update = update,
    view = view,
    inputs = [incomingActions]
  }

main : Signal Html
main =
  app.html

port tasks : Signal (Task Never())
port tasks =
  app.tasks

-- MODEL

type alias Model =
  { lastSaid: String
  }

init : (Model, Effects Action)
init =
  ({lastSaid = ""}, Effects.none)

-- UPDATE

type Action
  = NoOp
  | SetLastSaid String

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    SetLastSaid said ->
      ({lastSaid = said}, sendWordsSaid said)
    NoOp ->
      (model, Effects.none)

-- VIEW

view address model =
  div [ class "jumbotron" ]
    [ h2 []
        [ text "This is what you said: "
        , span
          [ id "greeting" ]
          [ text model.lastSaid ]
        ]
      ,h3 []
        [
          text "Or"
          ,Html.form [ ]
            [ input [ placeholder "type text", name "input" ] [] ]
        ]
    ]

-- SIGNALS

port lastSaidChanged : Signal String

port wordsSaid : Signal String
port wordsSaid =
  wordsSaidMailBox.signal

wordsSaidMailBox : Signal.Mailbox String
wordsSaidMailBox =
  Signal.mailbox ""

setLastSaid : Signal Action
setLastSaid =
  Signal.map SetLastSaid lastSaidChanged

incomingActions : Signal Action
incomingActions =
  setLastSaid


-- ACTIONS

sendWordsSaid : String -> Effects Action
sendWordsSaid text =
  Signal.send wordsSaidMailBox.address text
    |> Effects.task
    |> Effects.map (always NoOp)
