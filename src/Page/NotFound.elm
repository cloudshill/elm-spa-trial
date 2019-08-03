module Page.NotFound exposing (view)

import Html exposing (Html, text)


view : { title : String, content : Html msg }
view =
    { title = "not found"
    , content = text "not found"
    }
