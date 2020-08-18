module SignUp exposing (Model, Msg(..), Textbox(..), init, initialModel, main, subscriptions, update, view)

import Browser
import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Http
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
    , confirmPassword : String
    , showPasswords : Bool
    }


type Textbox
    = Email
    | Password
    | ConfirmPassword


type Button
    = Login
    | ShowHide


type Msg
    = TextBoxChanged Textbox String
    | ButtonClicked Button


initialModel : Model
initialModel =
    { email = ""
    , password = ""
    , confirmPassword = ""
    , showPasswords = False
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

                ConfirmPassword ->
                    ( { model | confirmPassword = str }, Cmd.none )

        ButtonClicked button ->
            case button of
                Login ->
                    ( initialModel, Cmd.none )

                ShowHide ->
                    ( { model | showPasswords = not model.showPasswords }, Cmd.none )


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
                , emailTextbox model
                , passwordTextbox model
                , confirmPasswordTextbox model
                , showHideButton model
                , signUpButton
                ]
            ]


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
        E.text "Sign Up"


signUpButton =
    Input.button
        [ E.centerX
        , Background.color <| E.rgb255 135 135 135
        , Border.rounded 15
        , Font.bold
        , E.padding <| 20
        ]
        { onPress = Just <| ButtonClicked Login
        , label = E.text "Sign Up"
        }


showHideButton model =
    let
        showOrHide =
            if model.showPasswords == False then
                "Show"

            else
                "Hide"
    in
    Input.button
        [ E.centerX
        , Background.color <| E.rgb255 135 135 135
        , Border.rounded 15
        , Font.bold
        , E.padding <| 20
        ]
        { onPress = Just <| ButtonClicked ShowHide
        , label = E.text showOrHide
        }


textboxStyle =
    [ Background.color <| E.rgb255 80 80 80
    , Border.color <| E.rgb255 0 0 0
    ]


emailTextbox model =
    Input.email textboxStyle
        { onChange = TextBoxChanged Email
        , text = model.email
        , placeholder = Nothing
        , label =
            Input.labelAbove
                [ Font.bold
                ]
            <|
                E.text "Email"
        }


passwordTextbox model =
    Input.newPassword textboxStyle
        { onChange = TextBoxChanged Password
        , text = model.password
        , placeholder = Nothing
        , show = model.showPasswords
        , label =
            Input.labelAbove
                [ Font.bold
                ]
            <|
                E.text "Password"
        }


confirmPasswordTextbox model =
    Input.newPassword textboxStyle
        { onChange = TextBoxChanged ConfirmPassword
        , text = model.confirmPassword
        , placeholder = Nothing
        , show = model.showPasswords
        , label =
            Input.labelAbove
                [ Font.bold
                ]
            <|
                E.text "Confirm Password"
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
