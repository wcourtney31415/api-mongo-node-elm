module FieldColumn exposing (fieldColumn)

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


type alias FieldSeed =
    ( String, String, String -> Msg )


makeFieldElement : FieldSeed -> E.Element Msg
makeFieldElement ( labelStr, text, onChange ) =
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
    E.column
        [ E.spacing 20
        , Font.color Style.white
        ]
    <|
        List.map makeFieldElement <|
            fieldList model


fieldList : Model -> List FieldSeed
fieldList model =
    [ ( "First Name"
      , model.firstNameInput
      , FirstNameBoxChanged
      )
    , ( "Last Name"
      , model.lastNameInput
      , LastNameBoxChanged
      )
    , ( "Email"
      , model.emailInput
      , EmailBoxChanged
      )
    , ( "Phone"
      , model.phoneInput
      , PhoneBoxChanged
      )
    ]
