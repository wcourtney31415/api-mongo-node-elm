module Dashboard.Dashboard exposing (Model, Msg(..), Textbox(..), init, initialModel, main, subscriptions, update, view)

import Browser
import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Style
    exposing
        ( pageBackground
        , shadow
        , white
        )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { email : String
    , password : String
    }


type Textbox
    = Email
    | Password


type Button
    = Login


type Msg
    = TextBoxChanged Textbox String
    | ButtonClicked Button


initialModel : Model
initialModel =
    { email = ""
    , password = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextBoxChanged textbox str ->
            case textbox of
                Email ->
                    ( { model | email = str }, Cmd.none )

                Password ->
                    ( { model | password = str }, Cmd.none )

        ButtonClicked button ->
            case button of
                Login ->
                    ( initialModel, Cmd.none )


view : Model -> Html.Html Msg
view model =
    E.layout
        [ Background.color
            pageBackground
        ]
    <|
        E.column
            [ E.centerX
            , E.spacing 20
            , E.padding 50
            ]
            [ E.column
                [ E.spacing 20
                , E.centerX
                , Background.color <| E.rgb255 97 97 97
                , Border.rounded 15
                , shadow
                , E.padding <| 20
                ]
                [ header
                , makeTextbox ( "Dashboard", Email, model.email )
                , makeTextbox ( "Dashboard", Password, model.password )
                , loginButton
                ]
            ]


loginButton : E.Element Msg
loginButton =
    Input.button
        [ E.centerX
        , Background.color <| E.rgb255 135 135 135
        , Border.rounded 15
        , Font.bold
        , E.padding <| 20
        ]
        { onPress = Just <| ButtonClicked Login
        , label = E.text "Dashboard"
        }


type alias TextboxSeed =
    ( String, Textbox, String )


header : E.Element Msg
header =
    E.el
        [ Font.size 40
        , Font.bold
        , E.centerX
        , Font.color white
        , E.paddingEach
            { top = 0
            , bottom = 30
            , right = 0
            , left = 0
            }
        ]
    <|
        E.text "Dashboard"


makeTextbox : TextboxSeed -> E.Element Msg
makeTextbox ( label, msg, text ) =
    Input.text
        [ Background.color <| E.rgb255 80 80 80
        , Border.color <| E.rgb255 0 0 0
        ]
        { onChange = TextBoxChanged msg
        , text = text
        , placeholder = Nothing
        , label =
            Input.labelAbove
                [ Font.bold
                ]
            <|
                E.text label
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
