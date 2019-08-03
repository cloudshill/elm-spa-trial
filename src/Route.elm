module Route exposing (Route(..), fromUrl, href)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


type Route
    = Index
    | Foo
    | Bar String


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Index top
        , map Foo (s "foo")
        , map Bar (s "bar" </> string)
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> parse parser


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


routeToString : Route -> String
routeToString route =
    let
        places =
            case route of
                Index ->
                    []

                Foo ->
                    [ "foo" ]

                Bar bar ->
                    [ "bar", bar ]
    in
    "#/" ++ String.join "/" places
