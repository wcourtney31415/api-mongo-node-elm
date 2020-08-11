module View exposing (view)

import Element as E
    exposing
        ( rgb
        , rgb255
        )
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

                AwaitingInput ->
                    ( "Awaiting Input...", S.blue )

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
                [ Border.color <| rgb 0 0 0
                , Background.color <| rgb255 58 58 58
                ]
                { onChange = InputChanged
                , text = model.lastNameInput
                , placeholder = Nothing
                , label = Input.labelAbove [] (E.text "Last Name")
                }
            , getUserButton model
            , pageState
            , userList model
            ]
        )
