module View exposing (view)

import Element as E
import Element.Background as Background
import Element.Border as Border
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
            , pageState model
            , E.row
                [ E.spacing 20
                , E.centerX
                , Background.color <| E.rgb255 97 97 97
                , Border.rounded 15
                , Style.shadow
                , E.padding <| 20
                ]
                [ E.column
                    [ Background.color <| E.rgba 1 0 0 0
                    , E.height E.fill
                    , E.spacing 20
                    ]
                    [ fieldColumn model
                    , getUsersButton model
                    ]
                , E.column
                    [ Background.color <| E.rgba 0 1 0 0
                    , E.height E.fill
                    , E.spacing 20
                    , E.width E.fill
                    ]
                    [ resultCount model
                    , userList model
                    ]
                ]
            ]
