module View exposing (view)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Style as S
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
        )
import VisualComponents
    exposing
        ( getUserButton
        , userList
        )


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
            [ VisualComponents.header
            , Input.text
                []
                { onChange = InputChanged
                , text = model.lastNameInput
                , placeholder = Nothing
                , label = Input.labelAbove [] (E.text "Last Name")
                }
            , getUserButton
            , pageState
            , userList model
            ]
        )
