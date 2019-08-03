module Page.Bar exposing (Model, init, view)

import Browser.Navigation exposing (Key)
import Html exposing (Html, span, text)


type alias Model =
    { value : String
    , key : Key
    }


init : Key -> String -> ( Model, Cmd msg )
init key value =
    ( { value = value, key = key }, Cmd.none )


view : Model -> { title : String, content : Html msg }
view model =
    { title = "bar"
    , content = span [] [ text <| "path parameter is " ++ model.value ]
    }
