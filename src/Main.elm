module Main exposing (main)

import Browser
import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Http
import Json.Decode as JsonDecoder
    exposing
        ( Decoder
        , field
        , map2
        , string
        )
import Style as S


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type ApiCallState
    = Failure
    | Loading
    | Success


type alias Model =
    { apiCallState : ApiCallState
    , users : List User
    }


type alias User =
    { firstName : String
    , lastName : String
    }


type Msg
    = RequestUser
    | GotUser (Result Http.Error (List User))


initialModel : { apiCallState : ApiCallState, users : List User }
initialModel =
    { apiCallState = Loading
    , users = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getUser )


apiUrl : String
apiUrl =
    "http://localhost/people"


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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        tup =
            case model.apiCallState of
                Success ->
                    ( "Successfully retrieved user(s).", S.green )

                Failure ->
                    ( "Failed to retrieve user(s).", S.red )

                Loading ->
                    ( "Contacting API...", S.blue )

        col =
            Tuple.second tup

        txt =
            Tuple.first tup

        pageState =
            E.el
                [ E.centerX
                , Background.color col
                , E.padding 10
                , Font.bold
                , Border.rounded 5
                , S.shadow
                ]
            <|
                E.text txt
    in
    E.layout [ Background.color S.grey ]
        (E.column
            [ E.centerX
            , E.spacing 20
            , E.padding 50
            ]
            [ header
            , getUserButton
            , pageState
            , userList model
            ]
        )


header : E.Element Msg
header =
    E.el
        [ Font.size 40
        , Font.bold
        , E.centerX
        , Font.color <| E.rgb 1 1 1
        , E.paddingEach
            { top = 0
            , bottom = 30
            , right = 0
            , left = 0
            }
        ]
    <|
        E.text "Front End!"


userList : Model -> E.Element Msg
userList model =
    E.column
        [ E.spacing 10
        ]
        (List.map userToText model.users)


getUserButton : E.Element Msg
getUserButton =
    Input.button
        [ E.centerX
        , Background.color S.btnGrey
        , E.padding 10
        , Border.rounded 5
        , S.shadow
        ]
        { onPress = Just RequestUser
        , label =
            E.el
                [ Font.size 20
                , Font.bold
                ]
            <|
                E.text "Retrieve User"
        }


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


fieldToRow : ( String, String ) -> E.Element msg
fieldToRow ( fieldName, val ) =
    E.row
        [ E.spacing 5 ]
        [ E.el [ Font.bold ] <|
            E.text <|
                fieldName
                    ++ ":"
        , E.text val
        ]


userToText : User -> E.Element msg
userToText user =
    E.el
        [ Background.color S.purple
        , Border.rounded 10
        , E.padding 10
        , S.shadow
        ]
    <|
        E.column [ E.spacing 10 ]
            [ fieldToRow ( "First firstName", user.firstName )
            , fieldToRow ( "Last firstName", user.lastName )
            ]
