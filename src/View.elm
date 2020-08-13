module View exposing (view)

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FieldColumn exposing (fieldColumn)
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
        , pageState
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
            , fieldColumn model
            , getUsersButton model
            , pageState model
            , resultCount model
            , userList model
            ]
