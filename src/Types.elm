module Types exposing (ApiCallState(..), Model, Msg(..), Textbox(..), User)

import Http


type alias Model =
    { apiCallState : ApiCallState
    , users : List User
    , textBoxes :
        { firstNameInput : String
        , lastNameInput : String
        , emailInput : String
        , phoneInput : String
        , birthdayInput : String
        }
    }


type alias User =
    { firstName : String
    , lastName : String
    , email : String
    , phone : String
    , birthday : String
    }


type Textbox
    = FirstName
    | LastName
    | Email
    | Phone
    | Birthday


type ApiCallState
    = Failure
    | Loading
    | Success
    | AwaitingInput


type Msg
    = GotUsers (Result Http.Error (List User))
    | RequestUsers User
    | TextBoxChanged Textbox String
