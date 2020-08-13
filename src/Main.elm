module Main exposing (main)

import Browser
import RequestHandler exposing (requestUsers)
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
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
    , firstNameInput = ""
    , lastNameInput = ""
    , emailInput = ""
    , phoneInput = ""
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

        FirstNameBoxChanged str ->
            ( { model | firstNameInput = str }
            , Cmd.none
            )

        LastNameBoxChanged str ->
            ( { model | lastNameInput = str }
            , Cmd.none
            )

        EmailBoxChanged str ->
            ( { model | emailInput = str }
            , Cmd.none
            )

        PhoneBoxChanged str ->
            ( { model | phoneInput = str }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
