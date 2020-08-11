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
    "http://localhost:80/getShowPeople"



-- from here


requestEncoder : String -> JE.Value
requestEncoder str =
    JE.object [ ( "lastName", JE.string str ) ]


myRequest : String -> Cmd Msg
myRequest str =
    Http.post
        { url = "http://localhost:80/postShowPeople"
        , body = Http.jsonBody <| requestEncoder str
        , expect = Http.expectJson GotUser userListDecoder
        }



-- to here


getUser : Cmd Msg
getUser =
    Http.get
        { url = apiUrl
        , expect = Http.expectJson GotUser userListDecoder
        }


userDecoder : Decoder User
userDecoder =
    JsonDecoder.map2 User
        (field "firstName" string)
        (field "lastName" string)


userListDecoder : Decoder (List User)
userListDecoder =
    JsonDecoder.list userDecoder
