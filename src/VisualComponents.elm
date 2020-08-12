module VisualComponents exposing
    ( fieldToRow
    , getUserButton
    , header
    , userList
    , userToText
    )

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style as S
import Types
    exposing
        ( Model
        , Msg(..)
        , User
        )



-- getUserButton : Model -> E.Element Msg


getUserButton : Model -> E.Element Msg
getUserButton model =
    Input.button
        [ E.centerX
        , Background.color S.btnGrey
        , E.padding 10
        , Border.rounded 5
        , S.shadow
        ]
        { onPress = Just <| RequestWithPost { firstName = "", lastName = model.lastNameInput }
        , label =
            E.el
                [ Font.size 20
                , Font.bold
                ]
            <|
                E.text "Retrieve User"
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
    E.column
        [ E.spacing 10
        ]
        (List.map userToText model.users)


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
