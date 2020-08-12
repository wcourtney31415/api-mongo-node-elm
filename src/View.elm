module View exposing (view)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Style
import Types
    exposing
        ( ApiCallState(..)
        , Model
        , Msg(..)
        )
import VisualComponents
    exposing
        ( getUsersButton
        , header
        , lastNameTextbox
        , resultCount
        , userList
        )


view : Model -> Html Msg
view model =
    E.layout
        [ Background.color
            Style.pageBackground
        ]
    <|
        E.column
            [ E.centerX
            , E.spacing 20
            , E.padding 50
            ]
            [ header
            , lastNameTextbox model
            , getUsersButton model
            , pageState model
            , resultCount model
            , userList model
            ]


pageState : Model -> E.Element Msg
pageState model =
    let
        ( callState, callStateColor ) =
            case model.apiCallState of
                Success ->
                    ( "Success.", Style.colorSuccess )

                Failure ->
                    ( "Failed to retrieve user(s).", Style.colorFailure )

                Loading ->
                    ( "Contacting API...", Style.colorContacting )

                AwaitingInput ->
                    ( "Awaiting Input...", Style.colorIdle )
    in
    E.el
        [ E.centerX
        , Background.color callStateColor
        , E.padding 10
        , Font.bold
        , Border.rounded 5
        , Style.shadow
        ]
    <|
        E.text callState
