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
        , ( "email", Encode.string user.email )
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

        emailDecoder : Decoder String
        emailDecoder =
            field "email" string
    in
    Decode.map3 User
        firstNameDecoder
        lastNameDecoder
        emailDecoder


userListDecoder : Decoder (List User)
userListDecoder =
    Decode.list userDecoder
