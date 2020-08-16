module VisualComponents exposing (getUsersButton, header, pageState, resultCount, resultSide, searchSide, userList)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import SearchFields exposing (fieldColumn)
import Style
    exposing
        ( colorButton
        , colorContacting
        , colorFailure
        , colorIdle
        , colorSuccess
        , shadow
        , userBoxBackground
        , white
        )
import Types exposing (ApiCallState(..), Model, Msg(..), User)


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
                { firstName = model.textBoxes.firstNameInput
                , lastName = model.textBoxes.lastNameInput
                , email = model.textBoxes.emailInput
                , phone = model.textBoxes.phoneInput
                , birthday = model.textBoxes.birthdayInput
                }
    in
    Input.button
        [ E.centerX
        , Background.color colorButton
        , E.padding 10
        , Border.rounded 5
        , shadow
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
        , Font.color white
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
        userToElement : User -> E.Element msg
        userToElement user =
            let
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

                firstName =
                    fieldToRow
                        ( "First name", user.firstName )

                lastName =
                    fieldToRow
                        ( "Last name", user.lastName )
            in
            E.el
                [ Background.color
                    userBoxBackground
                , Border.rounded 10
                , E.padding 10
                , shadow
                , E.width E.fill
                ]
            <|
                E.column
                    [ E.spacing 10 ]
                    [ firstName
                    , lastName
                    ]

        usersAsElements =
            List.map userToElement model.users
    in
    E.column
        [ E.spacing 10
        , E.width E.fill
        ]
    <|
        usersAsElements


resultCount : Model -> E.Element Msg
resultCount model =
    let
        userCount =
            List.length model.users

        userCountStr =
            String.fromInt userCount

        plural =
            if userCount == 1 then
                " user."

            else
                " users."

        userCountText =
            "Found " ++ userCountStr ++ plural
    in
    E.el
        [ E.centerX
        , Background.color <| E.rgba 0 1 0 0
        , Font.color white
        , Font.bold
        ]
    <|
        E.text userCountText


pageState : Model -> E.Element Msg
pageState model =
    let
        ( callState, callStateColor ) =
            case model.apiCallState of
                Success ->
                    ( "Success.", colorSuccess )

                Failure ->
                    ( "Failed to retrieve user(s).", colorFailure )

                Loading ->
                    ( "Contacting API...", colorContacting )

                AwaitingInput ->
                    ( "Awaiting Input...", colorIdle )
    in
    E.el
        [ E.centerX
        , Background.color callStateColor
        , E.padding 10
        , Font.bold
        , Border.rounded 5
        , shadow
        ]
    <|
        E.text callState


resultSide : Model -> E.Element Msg
resultSide model =
    E.column
        [ Background.color <| E.rgba 0 1 0 0
        , E.height E.fill
        , E.spacing 20
        , E.width E.fill
        ]
        [ resultCount model
        , userList model
        ]


searchSide : Model -> E.Element Msg
searchSide model =
    E.column
        [ Background.color <| E.rgba 1 0 0 0
        , E.height E.fill
        , E.spacing 20
        ]
        [ fieldColumn model
        , getUsersButton model
        ]
