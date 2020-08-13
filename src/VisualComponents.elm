module VisualComponents exposing (fieldToRow, getUsersButton, header, pageState, resultCount, userList, userToElement)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
        , User
        )


getUsersButton : Model -> E.Element Msg
getUsersButton model =
    let
        myLabel =
            E.el
                [ Font.size 20
                , Font.bold
                ]
            <|
                E.text "Retrieve User(s)"

        onClickMsg =
            RequestUsers
                { firstName = model.firstNameInput
                , lastName = model.lastNameInput
                }
    in
    Input.button
        [ E.centerX
        , Background.color Style.colorButton
        , E.padding 10
        , Border.rounded 5
        , Style.shadow
        ]
        { onPress = Just onClickMsg
        , label = myLabel
        }


header : E.Element Msg
header =
    E.el
        [ Font.size 40
        , Font.bold
        , E.centerX

        -- , Font.color <| E.rgb255 14 14 14
        , Font.color Style.white
        , E.paddingEach
            { top = 0
            , bottom = 30
            , right = 0
            , left = 0
            }
        ]
    <|
        E.text "Search Users"


userList : Model -> E.Element Msg
userList model =
    let
        usersAsElements =
            List.map userToElement model.users
    in
    E.column
        [ E.spacing 10
        , E.width E.fill
        ]
    <|
        usersAsElements


userToElement : User -> E.Element msg
userToElement user =
    let
        firstName =
            fieldToRow
                ( "First name", user.firstName )

        lastName =
            fieldToRow
                ( "Last name", user.lastName )
    in
    E.el
        [ Background.color
            Style.userBoxBackground
        , Border.rounded 10
        , E.padding 10
        , Style.shadow
        , E.width E.fill
        ]
    <|
        E.column
            [ E.spacing 10 ]
            [ firstName
            , lastName
            ]


resultCount : Model -> E.Element Msg
resultCount model =
    let
        userCount =
            List.length model.users

        userCountStr =
            String.fromInt userCount

        userCountText =
            "Found " ++ userCountStr ++ " user(s)."
    in
    E.el
        [ E.centerX
        , Background.color <| E.rgba 0 1 0 0
        , Font.color Style.white
        , Font.bold
        ]
    <|
        E.text userCountText


fieldToRow : ( String, String ) -> E.Element msg
fieldToRow ( fieldName, val ) =
    let
        textA =
            fieldName ++ ":"

        partA =
            E.el [ Font.bold ] <| E.text textA

        partB =
            E.text val
    in
    E.row
        [ E.spacing 5 ]
        [ partA, partB ]


pageState : Model -> E.Element Msg
pageState model =
    let
        ( callState, callStateColor ) =
            case model.apiCallState of
                Success ->
                    ( "Success.", Style.colorSuccess )

                Failure ->
                    ( "Failed to retrieve user(s).", Style.colorFailure )

                Loading ->
                    ( "Contacting API...", Style.colorContacting )

                AwaitingInput ->
                    ( "Awaiting Input...", Style.colorIdle )
    in
    E.el
        [ E.centerX
        , Background.color callStateColor
        , E.padding 10
        , Font.bold
        , Border.rounded 5
        , Style.shadow
        ]
    <|
        E.text callState
