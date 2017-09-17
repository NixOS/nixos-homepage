module NixJSON exposing (Gson, gnull, nixFromGson, gsonDecoder)

import Dict exposing (Dict, empty, foldr, filter)
import Json.Decode as Decode


type Gson
    = GString String
    | GBool Bool
    | GInt Int
    | GFloat Float
    | GList (List Gson)
    | GDict (Dict String Gson)
    | GNull


gnull : Gson
gnull =
    GNull


nixFromGson : Gson -> String
nixFromGson gson =
    case gson of
        GNull ->
            "null"

        GString x ->
            nix_string x

        GBool True ->
            "true"

        GBool False ->
            "false"

        GInt x ->
            toString x

        GFloat x ->
            toString x

        GList list ->
            nix_list list

        GDict dict ->
            nix_dict dict


nix_string : String -> String
nix_string x =
    if String.contains "\n" x then
        String.concat
            (List.concat
                [ [ "''\n" ]
                , [ x ]
                    |> segments_to_lines
                    |> indent
                , [ "''" ]
                ]
            )
    else
        "\"" ++ x ++ "\""


nix_list : List Gson -> String
nix_list list =
    let
        present : List String -> String
        present strings =
            case strings of
                [] ->
                    ""

                [ x ] ->
                    " " ++ x ++ " "

                _ ->
                    "\n" ++ (indent strings |> String.join "\n") ++ "\n"
    in
        "[" ++ (List.map nixFromGson list |> present) ++ "]"


nix_dict : Dict String Gson -> String
nix_dict dict =
    case ( Dict.get "_type" dict, Dict.get "text" dict ) of
        ( Just (GString "literalExample"), Just (GString txt) ) ->
            txt

        ( Just (GString "literalExample"), _ ) ->
            "Error: Literal Example did not contain plain text"

        otherwise ->
            let
                entries =
                    Dict.toList dict
            in
                if List.isEmpty entries then
                    "{ }"
                else
                    String.concat
                        (List.concat
                            [ [ "{\n" ]
                            , indent
                                (List.concatMap
                                    nix_enc_dict
                                    entries
                                )
                            , [ "}" ]
                            ]
                        )


indent : List String -> List String
indent lines =
    List.map (\line -> String.append "  " line) lines


nix_enc_dict : ( String, Gson ) -> List String
nix_enc_dict ( key, value ) =
    [ "\""
    , key
    , "\" = "
    , (nixFromGson value)
    , ";"
    ]
        |> segments_to_lines


segments_to_lines : List String -> List String
segments_to_lines segments =
    segments
        |> String.concat
        |> String.lines
        |> List.map (\x -> String.append x "\n")


gsonDecoder : Decode.Decoder Gson
gsonDecoder =
    Decode.oneOf
        [ Decode.null GNull
        , Decode.string |> Decode.map GString
        , Decode.bool |> Decode.map GBool
        , Decode.int |> Decode.map GInt
        , Decode.float |> Decode.map GFloat
        , Decode.list (Decode.lazy (\_ -> gsonDecoder)) |> Decode.map mkGsonList
        , Decode.keyValuePairs (Decode.lazy (\_ -> gsonDecoder)) |> Decode.map mkGsonObject
        ]


mkGsonList : List Gson -> Gson
mkGsonList data =
    GList (List.map (\x -> x) data)


mkGsonObject : List ( String, Gson ) -> Gson
mkGsonObject fields =
    GDict (Dict.fromList fields)
