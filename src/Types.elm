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
    | AwaitingInput


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
    = GotUsers (Result Http.Error (List User))
    | LastNameBoxChanged String
    | RequestUsers User
