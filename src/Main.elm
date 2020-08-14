module Main exposing (main)

import Browser
import FieldColumn exposing (handleTextboxChange)
import RequestHandler exposing (requestUsers)
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
        , Textbox(..)
        )
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


initialModel : Model
initialModel =
    { apiCallState = AwaitingInput
    , users = []
    , textBoxes =
        { firstNameInput = ""
        , lastNameInput = ""
        , emailInput = ""
        , phoneInput = ""
        }
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUsers result ->
            case result of
                Ok users ->
                    ( { model
                        | apiCallState = Success
                        , users = users
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | apiCallState = Failure }
                    , Cmd.none
                    )

        RequestUsers user ->
            ( { model | apiCallState = Loading }
            , requestUsers user
            )

        TextBoxChanged textbox str ->
            handleTextboxChange model textbox str


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
