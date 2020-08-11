module Main exposing (main)

import Browser
import RequestHandler exposing (getUser)
import Types
    exposing
        ( Model
        , Msg
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
    { apiCallState = Types.Loading
    , users = []
    , lastNameInput = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getUser )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.RequestUser ->
            ( { model | apiCallState = Types.Loading }
            , getUser
            )

        Types.GotUser result ->
            case result of
                Ok users ->
                    ( { model
                        | apiCallState = Types.Success
                        , users = users
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | apiCallState = Types.Failure }
                    , Cmd.none
                    )

        Types.InputChanged str ->
            ( { model | lastNameInput = str }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
