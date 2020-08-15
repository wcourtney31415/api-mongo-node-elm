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
        , ( "phoneNumber", Encode.string user.phone )
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

        phoneDecoder : Decoder String
        phoneDecoder =
            field "phoneNumber" string
    in
    Decode.map4 User
        firstNameDecoder
        lastNameDecoder
        emailDecoder
        phoneDecoder


userListDecoder : Decoder (List User)
userListDecoder =
    Decode.list userDecoder
