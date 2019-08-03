module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation exposing (Key, load, pushUrl)
import Html exposing (Html)
import Page
import Page.Bar as Bar
import Page.Foo as Foo
import Page.Index as Index
import Page.NotFound as NotFound
import Route exposing (Route, fromUrl)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


type Model
    = Index Index.Model
    | Foo Foo.Model
    | Bar Bar.Model
    | NotFound Key


type Msg
    = GotIndex Index.Msg
    | GotFoo Foo.Msg
    | GotBar
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    changeRouteTo (fromUrl url) key


changeRouteTo : Maybe Route -> Key -> ( Model, Cmd Msg )
changeRouteTo maybeRoute key =
    case maybeRoute of
        Nothing ->
            ( NotFound key, Cmd.none )

        Just Route.Index ->
            updateWith Index GotIndex (Index.init key)

        Just Route.Foo ->
            updateWith Foo GotFoo (Foo.init key)

        Just (Route.Bar bar) ->
            let
                ( subModel, subMsg ) =
                    Bar.init key bar
            in
            ( Bar subModel, subMsg )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotIndex subMsg, Index index ) ->
            updateWith Index GotIndex (Index.update subMsg index)

        ( GotFoo subMsg, Foo foo ) ->
            updateWith Foo GotFoo (Foo.update subMsg foo)

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            let
                                key =
                                    case model of
                                        NotFound k ->
                                            k

                                        Index index ->
                                            index.key

                                        Foo foo ->
                                            foo.key

                                        Bar bar ->
                                            bar.key
                            in
                            ( model, pushUrl key (Url.toString url) )

                Browser.External href ->
                    ( model, load href )

        ( ChangedUrl url, _ ) ->
            let
                key =
                    case model of
                        NotFound k ->
                            k

                        Index index ->
                            index.key

                        Foo foo ->
                            foo.key

                        Bar bar ->
                            bar.key
            in
            changeRouteTo (fromUrl url) key

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg document =
            let
                { title, body } =
                    Page.view page document
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        NotFound _ ->
            let
                { title, content } =
                    NotFound.view
            in
            { title = title, body = [ content ] }

        Index index ->
            viewPage Page.Index GotIndex (Index.view index)

        Foo foo ->
            viewPage Page.Foo GotFoo (Foo.view foo)

        Bar bar ->
            Page.view Page.Bar (Bar.view bar)


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none
