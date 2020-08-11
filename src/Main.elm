module Main exposing (main)

import Browser
import RequestHandler exposing (getUser)
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
    , lastNameInput = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestUser ->
            ( { model | apiCallState = Loading }
            , getUser
            )

        GotUser result ->
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

        InputChanged str ->
            ( { model | lastNameInput = str }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
