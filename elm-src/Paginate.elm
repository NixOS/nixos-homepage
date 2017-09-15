module Paginate exposing (..)

import List.Extra


which_page : List a -> (a -> Bool) -> Maybe Int
which_page options matcher =
    let
        pos =
            List.Extra.findIndex matcher options
    in
        case pos of
            Just position ->
                Just (ceiling ((toFloat position) / 15.0))

            Nothing ->
                Nothing


fetch_page : Int -> List a -> List a
fetch_page page content =
    List.drop ((page - 1) * 15) (List.take (page * 15) content)


total_pages : List a -> Int
total_pages content =
    ceiling ((toFloat (List.length content)) / 15)
