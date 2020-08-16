module Main exposing (main)

import Browser
import Element as E
import Element.Background as Background
import Element.Border as Border
import Html
import Http
import Json.Decode as Decode
    exposing
        ( Decoder
        , field
        , string
        )
import Json.Encode as Encode
import SearchFields
    exposing
        ( handleTextboxChange
        )
import Style
    exposing
        ( pageBackground
        , shadow
        )
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
        , Textbox(..)
        , User
        )
import VisualComponents
    exposing
        ( header
        , pageState
        , resultSide
        , searchSide
        )


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
        , birthdayInput = ""
        }
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


requestUsers : User -> Cmd Msg
requestUsers user =
    let
        userListDecoder : Decoder (List User)
        userListDecoder =
            let
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

                        birthdayDecoder : Decoder String
                        birthdayDecoder =
                            field "birthdate" string
                    in
                    Decode.map5 User
                        firstNameDecoder
                        lastNameDecoder
                        emailDecoder
                        phoneDecoder
                        birthdayDecoder
            in
            Decode.list userDecoder

        userEncoder : User -> Encode.Value
        userEncoder myUser =
            Encode.object
                [ ( "firstName", Encode.string myUser.firstName )
                , ( "lastName", Encode.string myUser.lastName )
                , ( "email", Encode.string myUser.email )
                , ( "phoneNumber", Encode.string myUser.phone )
                , ( "birthday", Encode.string myUser.birthday )
                ]
    in
    Http.post
        { url = "/findusers"
        , body = Http.jsonBody (userEncoder user)
        , expect = Http.expectJson GotUsers userListDecoder
        }


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


view : Model -> Html.Html Msg
view model =
    E.layout
        [ Background.color
            pageBackground
        ]
    <|
        E.column
            [ E.centerX
            , E.spacing 20
            , E.padding 50
            ]
            [ header
            , pageState model
            , E.row
                [ E.spacing 20
                , E.centerX
                , Background.color <| E.rgb255 97 97 97
                , Border.rounded 15
                , shadow
                , E.padding <| 20
                ]
                [ searchSide model
                , resultSide model
                ]
            ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
