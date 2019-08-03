module Page exposing (Page(..), view)

import Browser exposing (Document)
import Bulma.CDN exposing (stylesheet)
import Bulma.Components exposing (navbar, navbarEnd, navbarItemLink, navbarMenu, navbarModifiers)
import Bulma.Elements exposing (content)
import Bulma.Layout exposing (container, footer)
import Bulma.Modifiers exposing (Size(..))
import Bulma.Modifiers.Typography exposing (textCentered)
import Html exposing (Html, a, footer, main_, p, text)
import Html.Attributes exposing (href)
import Route


type Page
    = Index
    | Foo
    | Bar


view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title
    , body =
        [ main_ []
            [ stylesheet
            , viewHeader page
            , content
            , viewFooter
            ]
        ]
    }


viewHeader : Page -> Html msg
viewHeader page =
    let
        menuItemView pageType routeType name =
            navbarItemLink ((==) page pageType)
                [ Route.href routeType ]
                [ text name ]
    in
    navbar navbarModifiers
        []
        [ navbarMenu True
            []
            [ navbarEnd []
                [ menuItemView Index Route.Index "Index"
                , menuItemView Foo Route.Foo "Foo"
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer []
        [ container
            []
            [ content Standard
                [ textCentered ]
                [ p []
                    [ text "footer"
                    ]
                ]
            ]
        ]
