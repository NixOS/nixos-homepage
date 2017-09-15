module NixOptions exposing (..)

import NixJSON exposing (Gson, gnull, gsonDecoder)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, hardcoded, optional)


type alias Option =
    { declarations : List String
    , default : Gson
    , description : String
    , example : Gson
    , readOnly : Bool
    , datatype : String
    }


type alias NixOptions =
    List ( String, Option )


option_sort_key : ( String, Option ) -> String
option_sort_key ( name, option ) =
    name


option_filter : List String -> ( String, Option ) -> Bool
option_filter terms ( name, option ) =
    List.all
        (\term ->
            term_matches name term
                || term_matches option.description term
        )
        terms


term_matches : String -> String -> Bool
term_matches name term =
    String.contains term (String.toLower name)


filtered : NixOptions -> List String -> NixOptions
filtered options terms =
    List.filter (option_filter terms) options


optionDecoder : Decode.Decoder Option
optionDecoder =
    decode Option
        |> required "declarations" (Decode.list Decode.string)
        |> optional "default" gsonDecoder gnull
        |> required "description" Decode.string
        |> optional "example" gsonDecoder gnull
        |> required "readOnly" Decode.bool
        |> required "type" Decode.string


decodeOptions : Decode.Decoder NixOptions
decodeOptions =
    (Decode.keyValuePairs <| optionDecoder)
