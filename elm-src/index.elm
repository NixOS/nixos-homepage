module Main exposing (..)

import NixOptions exposing (..)
import NixJSON exposing (Gson, gnull, gsonDecoder, nixFromGson)
import Paginate exposing (..)
import Html exposing (node, Attribute, Html, a, text, em, table, tr, th, td, tbody, thead, input, ul, li, button, h1, h2, div, pre, p, hr)
import Html.Attributes exposing (placeholder, src, disabled, href, class, autofocus, value, id)
import Html.Events exposing (onInput, onClick)
import Http
import Json.Encode exposing (encode, Value, null)
import Dict exposing (Dict, empty, foldr, filter)
import Navigation
import QueryString
import Debug
import Maybe
import Array
import ExEmElm.Parser
import ExEmElm.Traverse
import Debounce


main =
    Navigation.program ChangeUrl
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { query : String
    , terms : List String
    , options : NixOptions
    , matchingOptions : NixOptions
    , page : Int
    , location : Navigation.Location
    , selected : Maybe String
    , status : PageStatus
    , debounce_state : Debounce.State
    }


type alias UrlState =
    { query : String
    , page : Int
    , selected : Maybe String
    }


clamped : Model -> Model
clamped model =
    { model | page = (clamp 1 (total_pages model.matchingOptions) model.page) }


update_options : Model -> NixOptions -> Model
update_options model unsorted_options =
    let
        options : NixOptions
        options =
            List.sortBy option_sort_key unsorted_options

        matchingOptions =
            filtered options model.terms

        page =
            case model.selected of
                Just option ->
                    case which_page matchingOptions (opt_tuple_matches_name option) of
                        Just p ->
                            p

                        Nothing ->
                            model.page

                Nothing ->
                    model.page
    in
        clamped
            ({ model
                | options = options
                , matchingOptions = matchingOptions
                , page = page
                , status = Loaded
             }
            )


update_query : Model -> String -> Model
update_query model query =
    { model
        | query = query
        , terms = splitQuery query
        , matchingOptions = filtered model.options model.terms
        , page = 1
        , selected = Nothing
    }


update_page : Model -> Int -> Model
update_page model newPage =
    clamped
        { model
            | page = newPage
            , selected = Nothing
        }


select_option : Model -> String -> Model
select_option model opt =
    { model
        | selected = Just opt
    }


deselect_option : Model -> Model
deselect_option model =
    { model
        | selected = Nothing
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        state =
            url_state_from_location location
    in
        ( Model state.query (splitQuery state.query) [] [] state.page location state.selected Loading Debounce.init
        , getOptions
        )


splitQuery : String -> List String
splitQuery query =
    String.words (String.toLower query)



-- UPDATE


url_state_from_location : Navigation.Location -> UrlState
url_state_from_location location =
    let
        qs =
            QueryString.parse location.search
    in
        UrlState
            (Maybe.withDefault "" (QueryString.one QueryString.string "query" qs))
            (Maybe.withDefault 1 (QueryString.one QueryString.int "page" qs))
            (QueryString.one QueryString.string "selected" qs)


updateFromUrl : Navigation.Location -> Model -> Model
updateFromUrl location model =
    let
        state =
            url_state_from_location location
    in
        case state.selected of
            Just opt ->
                select_option model opt

            Nothing ->
                (update_page (update_query model state.query) state.page)


updateUrl : Model -> Cmd Msg
updateUrl model =
    let
        querystring =
            case model.selected of
                Nothing ->
                    String.append
                        (String.append "?query=" (Http.encodeUri model.query))
                        (if model.page > 1 then
                            (String.append "&page=" (Http.encodeUri (toString model.page)))
                         else
                            ""
                        )

                Just opt ->
                    (String.append "?selected=" (Http.encodeUri opt))
    in
        Navigation.newUrl querystring


type Msg
    = ChangeQuery String
    | ChangePage Int
    | ChangeUrl Navigation.Location
    | FetchedOptions (Result Http.Error NixOptions)
    | SelectOption String
    | DeselectOption
    | Bounce (Debounce.Msg Msg)
    | SyncQueryToUrl


type PageStatus
    = Loading
    | Loaded
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedOptions (Ok options) ->
            let
                newModel =
                    update_options model options
            in
                ( newModel, updateUrl newModel )

        FetchedOptions (Err e) ->
            ( { model | status = Error (toString e) }, Cmd.none )

        SelectOption option_name ->
            let
                newModel =
                    select_option model option_name
            in
                ( newModel, updateUrl newModel )

        DeselectOption ->
            let
                newModel =
                    deselect_option model
            in
                ( newModel, updateUrl newModel )

        ChangeUrl location ->
            let
                newModel =
                    updateFromUrl location model
            in
                ( newModel, Cmd.none )

        ChangePage newPage ->
            let
                newModel =
                    update_page model newPage
            in
                ( newModel, updateUrl newModel )

        Bounce bouncer ->
            (Debounce.update debounce_cfg bouncer model)

        ChangeQuery newQuery ->
            let
                newModel =
                    update_query model newQuery
            in
                ( newModel, debounce <| SyncQueryToUrl )

        SyncQueryToUrl ->
            ( model, updateUrl model )



-- VIEW


tt : List (Attribute msg) -> List (Html msg) -> Html msg
tt x y =
    node "tt" x y


declaration_link : String -> Html Msg
declaration_link path =
    a [ href (String.append "https://github.com/NixOS/nixpkgs/tree/release-17.03/" path) ]
        [ (tt [] [ text path ]) ]


null_is_not_given : (Gson -> Html Msg) -> Gson -> Html Msg
null_is_not_given fn x =
    if x == gnull then
        (em [] [ text "Not given" ])
    else
        fn x


nix : Gson -> Html Msg
nix content =
    pre [] [ text (nixFromGson content) ]


description_to_text : String -> String
description_to_text input =
    let
        text =
            String.concat
                [ "<xml xmlns:xlink=\"http://www.w3.org/1999/xlink\"><para>"
                , input
                , "</para></xml>"
                ]
    in
        case ExEmElm.Parser.parse text of
            Ok doc ->
                ExEmElm.Traverse.innerText (ExEmElm.Parser.root doc)

            otherwise ->
                ":)"


describe_option : Option -> Html Msg
describe_option option =
    div [ class "search-details" ]
        [ table []
            [ tbody []
                [ tr []
                    [ th [] [ text "Description:" ]
                    , td [] []
                    , td [ class "description docbook" ] [ text (description_to_text option.description) ]
                    ]
                , tr []
                    [ th [] [ text "Default Value:" ]
                    , td [] []
                    , td [ class "default" ] [ null_is_not_given nix option.default ]
                    ]
                , tr []
                    [ th [] [ text "Example value:" ]
                    , td [] []
                    , td [ class "example" ] [ null_is_not_given nix option.example ]
                    ]
                , tr []
                    [ th [] [ text "Declared In:" ]
                    , td [] []
                    , td [ class "declared-in" ] (List.map declaration_link option.declarations)
                    ]
                ]
            ]
        ]


optionToTd : Maybe String -> ( String, Option ) -> List (Html Msg)
optionToTd selected ( name, option ) =
    let
        isSelected =
            (case selected of
                Nothing ->
                    False

                Just selopt ->
                    selopt == name
            )
    in
        (List.concat
            [ [ (tr []
                    [ td
                        [ onClick
                            (if isSelected then
                                (DeselectOption)
                             else
                                (SelectOption name)
                            )
                        ]
                        [ tt [] [ text name ] ]
                    ]
                )
              ]
            , (if not isSelected then
                []
               else
                [ tr []
                    [ td [ class "details" ] [ describe_option option ]
                    ]
                ]
              )
            ]
        )


opt_tuple_matches_name : String -> ( String, Option ) -> Bool
opt_tuple_matches_name term ( name, option ) =
    term == name


changePageIf : Bool -> Int -> String -> Html Msg
changePageIf cond page txt =
    button
        (if cond then
            [ onClick (ChangePage page) ]
         else
            [ disabled True ]
        )
        [ text txt ]


view : Model -> Html Msg
view model =
    if List.isEmpty model.options then
        div [] [ h1 [] [ text (toString model.status) ] ]
    else
        viewOptions model


debounce =
    Debounce.debounceCmd debounce_cfg


debounce_cfg : Debounce.Config Model Msg
debounce_cfg =
    Debounce.config
        -- getState   : Model -> Debounce.State
        .debounce_state
        -- setState   : Debounce.State -> Model -> Debounce.State
        (\model s -> { model | debounce_state = s })
        -- msgWrapper : Msg a -> Msg
        Bounce
        200



-- timeout ms : Float


viewOptions : Model -> Html Msg
viewOptions model =
    div []
        [ p []
            [ input [ id "search", class "search-query span3", autofocus True, value model.query, onInput ChangeQuery ] []
            ]
        , hr [] []
        , p [ id "how-many" ]
            [ em []
                [ text
                    (if List.isEmpty model.matchingOptions then
                        "Showing no results"
                     else
                        (String.concat
                            [ "Showing results "
                            , (toString (((model.page - 1) * 15) + 1))
                            , "-"
                            , (toString (min (List.length model.matchingOptions) ((model.page) * 15)))
                            , " of "
                            , (toString (List.length model.matchingOptions))
                            , "."
                            ]
                        )
                    )
                ]
            ]
        , table [ class "options table table-hover" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Option name" ]
                    ]
                ]
            , tbody []
                (List.concat (List.map (optionToTd model.selected) (fetch_page model.page model.matchingOptions)))
            ]
        , ul [ class "pager" ]
            [ li []
                [ (changePageIf (not (model.page <= 1)) 1 "« First")
                ]
            , li []
                [ (changePageIf (model.page > 1) (model.page - 1) "‹ Previous")
                ]
            , li []
                [ (changePageIf (model.page < (total_pages model.matchingOptions)) (model.page + 1) "Next ›")
                ]
            , li []
                [ (changePageIf (model.page < (total_pages model.matchingOptions)) (total_pages model.matchingOptions) "Last »")
                ]
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getOptions : Cmd Msg
getOptions =
    Http.send FetchedOptions (Http.get "./options.json" decodeOptions)
