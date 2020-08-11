module Types exposing
    ( ApiCallState(..)
    , Model
    , Msg(..)
    , User
    )

import Http


type ApiCallState
    = Failure
    | Loading
    | Success


type alias Model =
    { apiCallState : ApiCallState
    , users : List User
    , lastNameInput : String
    }


type alias User =
    { firstName : String
    , lastName : String
    }


type Msg
    = RequestUser
    | GotUser (Result Http.Error (List User))
    | InputChanged String
