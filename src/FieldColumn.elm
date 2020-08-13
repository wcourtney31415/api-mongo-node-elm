module FieldColumn exposing (FieldRecord, fieldColumn, fieldToTextbox, fields)

import Element as E
    exposing
        ( rgb
        , rgb255
        , text
        )
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Types
    exposing
        ( Model
        , Msg(..)
        )


fieldToTextbox : FieldRecord -> E.Element Msg
fieldToTextbox record =
    Input.text
        [ Border.color <| rgb 0 0 0
        , Background.color <| rgb255 58 58 58
        ]
        record


type alias FieldRecord =
    { onChange : String -> Msg
    , text : String
    , placeholder : Maybe (Input.Placeholder Msg)
    , label : Input.Label Msg
    }


fields : Model -> List FieldRecord
fields model =
    let
        firstName =
            { onChange = FirstNameBoxChanged
            , text = model.firstNameInput
            , placeholder = Nothing
            , label = Input.labelAbove [] (E.text "First Name")
            }

        lastName =
            { onChange = LastNameBoxChanged
            , text = model.lastNameInput
            , placeholder = Nothing
            , label = Input.labelAbove [] (E.text "Last Name")
            }

        email =
            { onChange = EmailBoxChanged
            , text = model.emailInput
            , placeholder = Nothing
            , label = Input.labelAbove [] (E.text "Email")
            }

        phone =
            { onChange = PhoneBoxChanged
            , text = model.phoneInput
            , placeholder = Nothing
            , label = Input.labelAbove [] (E.text "Phone")
            }
    in
    [ firstName
    , lastName
    , email
    , phone
    ]


fieldColumn : Model -> E.Element Msg
fieldColumn model =
    E.column
        [ E.spacing 20
        ]
    <|
        List.map fieldToTextbox (fields model)
