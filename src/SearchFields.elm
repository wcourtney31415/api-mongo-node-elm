module SearchFields exposing (FieldSeed, fieldColumn, handleTextboxChange)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style
    exposing
        ( black
        , colorInput
        , white
        )
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
        , Textbox(..)
        )


type alias FieldSeed =
    ( String, String, String -> Msg )


fieldColumn : Model -> E.Element Msg
fieldColumn model =
    let
        fieldList : Model -> List FieldSeed
        fieldList myModel =
            [ ( "First Name"
              , myModel.textBoxes.firstNameInput
              , TextBoxChanged FirstName
              )
            , ( "Last Name"
              , myModel.textBoxes.lastNameInput
              , TextBoxChanged LastName
              )
            , ( "Email"
              , myModel.textBoxes.emailInput
              , TextBoxChanged Email
              )
            , ( "Phone"
              , myModel.textBoxes.phoneInput
              , TextBoxChanged Phone
              )
            , ( "Birthday"
              , myModel.textBoxes.birthdayInput
              , TextBoxChanged Birthday
              )
            ]

        makeFieldElement : FieldSeed -> E.Element Msg
        makeFieldElement ( labelStr, text, onChange ) =
            Input.text
                [ Border.color black
                , Background.color colorInput
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
    in
    E.column
        [ E.spacing 20
        , Font.color white
        ]
    <|
        List.map makeFieldElement <|
            fieldList model


handleTextboxChange : Model -> Textbox -> String -> ( Model, Cmd msg )
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

        Birthday ->
            updateTextboxRecord
                { textBoxes | birthdayInput = str }
