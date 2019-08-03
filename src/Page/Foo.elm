module Page.Foo exposing (Model, Msg(..), init, update, view)

import Browser.Navigation exposing (Key)
import Html exposing (Html, div, input, text)
import Html.Events exposing (onInput)


type alias Model =
    { value : Maybe String
    , key : Key
    }


type Msg
    = InputValue String


init : Key -> ( Model, Cmd Msg )
init key =
    ( { value = Nothing, key = key }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputValue value ->
            ( { model
                | value =
                    if String.isEmpty value then
                        Nothing

                    else
                        Just value
              }
            , Cmd.none
            )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "foo"
    , content =
        div []
            [ div [] [ text <| Maybe.withDefault "no input!" model.value ]
            , input [ onInput InputValue ] []
            ]
    }
