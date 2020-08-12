module VisualComponents exposing
    ( getUsersButton
    , header
    , lastNameTextbox
    , resultCount
    , userList
    )

import Element as E
    exposing
        ( rgb
        , rgb255
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style
import Types
    exposing
        ( Model
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
                { firstName = ""
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
        , Font.color <| E.rgb255 14 14 14
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
    let
        usersAsElements =
            List.map userToElement model.users
    in
    E.column
        [ E.spacing 10
        ]
    <|
        usersAsElements


userToElement : User -> E.Element msg
userToElement user =
    let
        firstName =
            fieldToRow
                ( "First firstName", user.firstName )

        lastName =
            fieldToRow
                ( "Last firstName", user.lastName )
    in
    E.el
        [ Background.color
            Style.userBoxBackground
        , Border.rounded 10
        , E.padding 10
        , Style.shadow
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


lastNameTextbox : Model -> E.Element Msg
lastNameTextbox model =
    Input.text
        [ Border.color <| rgb 0 0 0
        , Background.color <| rgb255 58 58 58
        ]
        { onChange = LastNameBoxChanged
        , text = model.lastNameInput
        , placeholder = Nothing
        , label = Input.labelAbove [] (E.text "Last Name")
        }
