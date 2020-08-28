module Style exposing (black, colorButton, colorContacting, colorFailure, colorIdle, colorInput, colorSuccess, pageBackground, shadow, userBoxBackground, white)

import Element as E
import Element.Border as Border


black : E.Color
black =
    E.rgb 0 0 0


white : E.Color
white =
    E.rgb 1 1 1


colorInput : E.Color
colorInput =
    E.rgb255 77 77 77


pageBackground : E.Color
pageBackground =
    E.rgb 0.3 0.3 0.3


colorSuccess : E.Color
colorSuccess =
    E.rgb255 2 183 2


colorFailure : E.Color
colorFailure =
    E.rgb 1 0 0


colorContacting : E.Color
colorContacting =
    E.rgb255 39 102 156


colorIdle : E.Color
colorIdle =
    E.rgb255 39 102 156


colorButton : E.Color
colorButton =
    E.rgb255 219 219 219


userBoxBackground : E.Color
userBoxBackground =
    E.rgb255 49 163 212


shadow : E.Attribute msg
shadow =
    Border.shadow
        { offset = ( 5, 4 )
        , size = 1
        , blur = 10
        , color = black
        }
