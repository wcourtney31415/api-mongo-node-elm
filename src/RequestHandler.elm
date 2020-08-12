module RequestHandler exposing
    ( apiUrl
    , getUser
    , myRequest
    , userDecoder
    , userListDecoder
    )

import Http
import Json.Decode as JsonDecoder
    exposing
        ( Decoder
        , field
        , map2
        , string
        )
import Json.Encode as JE
import Types
    exposing
        ( Msg(..)
        , User
        )


apiUrl : String
apiUrl =
    "http://localhost:80/postShowPeople"



-- from here


requestEncoder : User -> JE.Value
requestEncoder user =
    JE.object
        [ ( "firstName", JE.string user.firstName )
        , ( "lastName", JE.string user.lastName )
        ]


myRequest : User -> Cmd Msg
myRequest user =
    Http.post
        { url = "http://localhost:80/postShowPeople"
        , body = Http.jsonBody (requestEncoder user)
        , expect = Http.expectJson GotUser userListDecoder
        }



-- myRequest : User -> Cmd Msg
-- myRequest user =
--     Http.request
--         { method = "POST"
--         , headers = [ Http.header "Content-Type" "application/x-www-form-urlencoded" ]
--         , url = "http://localhost:80/postShowPeople"
--         , body = Http.jsonBody (requestEncoder user)
--         , expect = Http.expectJson GotUser userListDecoder
--         , timeout = Nothing
--         , tracker = Nothing
--         }
-- to here


getUser : Cmd Msg
getUser =
    Http.get
        { url = apiUrl
        , expect = Http.expectJson GotUser userListDecoder
        }


firstNameDecoder : Decoder String
firstNameDecoder =
    field "firstName" string


lastNameDecoder : Decoder String
lastNameDecoder =
    field "lastName" string


userDecoder : Decoder User
userDecoder =
    JsonDecoder.map2 User
        firstNameDecoder
        lastNameDecoder


userListDecoder : Decoder (List User)
userListDecoder =
    JsonDecoder.list userDecoder
