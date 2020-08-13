module FieldColumn exposing (fieldColumn, makeFieldElement)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style
import Types
    exposing
        ( Model
        , Msg(..)
        )


makeFieldElement : (String -> Msg) -> String -> String -> E.Element Msg
makeFieldElement onChange text labelStr =
    Input.text
        [ Border.color Style.black
        , Background.color Style.colorInput
        ]
        { onChange = onChange
        , text = text
        , placeholder = Nothing
        , label =
            Input.labelAbove
                [ Font.bold
                ]
            <|
                E.text labelStr
        }


fieldColumn : Model -> E.Element Msg
fieldColumn model =
    let
        firstName =
            makeFieldElement
                FirstNameBoxChanged
                model.firstNameInput
                "First Name"

        lastName =
            makeFieldElement
                LastNameBoxChanged
                model.lastNameInput
                "Last Name"

        email =
            makeFieldElement
                EmailBoxChanged
                model.emailInput
                "Email"

        phone =
            makeFieldElement
                PhoneBoxChanged
                model.phoneInput
                "Phone"
    in
    E.column
        [ E.spacing 20
        , Font.color Style.white
        ]
        [ firstName
        , lastName
        , email
        , phone
        ]
