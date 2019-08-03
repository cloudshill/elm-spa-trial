module Page.Index exposing (Model, Msg(..), init, update, view)

import Browser.Navigation exposing (Key)
import Html exposing (Html, button, div, h1, text)
import Html.Events exposing (onClick)


type alias Model =
    { counter : Int
    , key : Key
    }


type Msg
    = Inc
    | Dec


init : Key -> ( Model, Cmd Msg )
init key =
    ( { counter = 0, key = key }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Inc ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Dec ->
            ( { model | counter = model.counter - 1 }, Cmd.none )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "index"
    , content =
        div []
            [ h1 [] [ text <| String.fromInt model.counter ]
            , button [ onClick Inc ] [ text "inc" ]
            , button [ onClick Dec ] [ text "dec" ]
            ]
    }
