module FieldColumn exposing (fieldColumn, handleTextboxChange)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style
import Types exposing (Model, Msg(..), Textbox(..))


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
      , model.textBoxes.firstNameInput
      , TextBoxChanged FirstName
      )
    , ( "Last Name"
      , model.textBoxes.lastNameInput
      , TextBoxChanged LastName
      )
    , ( "Email"
      , model.textBoxes.emailInput
      , TextBoxChanged Email
      )
    , ( "Phone"
      , model.textBoxes.phoneInput
      , TextBoxChanged Phone
      )
    ]


handleTextboxChange model textbox str =
    let
        textBoxes =
            model.textBoxes

        updateTextboxRecord =
            let
                makeNewModel myModel txtBoxRecord =
                    ( { myModel | textBoxes = txtBoxRecord }
                    , Cmd.none
                    )
            in
            makeNewModel model
    in
    case textbox of
        FirstName ->
            updateTextboxRecord
                { textBoxes | firstNameInput = str }

        LastName ->
            updateTextboxRecord
                { textBoxes | lastNameInput = str }

        Email ->
            updateTextboxRecord
                { textBoxes | emailInput = str }

        Phone ->
            updateTextboxRecord
                { textBoxes | phoneInput = str }
