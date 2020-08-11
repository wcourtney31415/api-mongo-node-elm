module Style exposing
    ( black
    , blue
    , btnGrey
    , green
    , grey
    , purple
    , red
    , shadow
    )

import Element as E
import Element.Border as Border


black : E.Color
black =
    E.rgb 0 0 0


grey : E.Color
grey =
    E.rgb 0.3 0.3 0.3


green : E.Color
green =
    E.rgb255 2 183 2


red : E.Color
red =
    E.rgb 1 0 0


blue : E.Color
blue =
    E.rgb255 39 102 156


btnGrey : E.Color
btnGrey =
    E.rgb255 219 219 219


purple : E.Color
purple =
    E.rgb255 49 163 212


shadow : E.Attribute msg
shadow =
    Border.shadow
        { offset = ( 5, 4 )
        , size = 1
        , blur = 10
        , color = black
        }
