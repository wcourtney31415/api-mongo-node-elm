module RequestHandler exposing
    ( requestUsers
    , userDecoder
    , userListDecoder
    )

import Http
import Json.Decode as Decode
    exposing
        ( Decoder
        , field
        , map2
        , string
        )
import Json.Encode as Encode
import Types
    exposing
        ( Msg(..)
        , User
        )


requestUsers : User -> Cmd Msg
requestUsers user =
    Http.post
        { url = "/findusers"
        , body = Http.jsonBody (userEncoder user)
        , expect = Http.expectJson GotUsers userListDecoder
        }


userEncoder : User -> Encode.Value
userEncoder user =
    Encode.object
        [ ( "firstName", Encode.string user.firstName )
        , ( "lastName", Encode.string user.lastName )
        ]


userDecoder : Decoder User
userDecoder =
    let
        firstNameDecoder : Decoder String
        firstNameDecoder =
            field "firstName" string

        lastNameDecoder : Decoder String
        lastNameDecoder =
            field "lastName" string
    in
    Decode.map2 User
        firstNameDecoder
        lastNameDecoder


userListDecoder : Decoder (List User)
userListDecoder =
    Decode.list userDecoder
