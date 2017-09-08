
%include lhs2TeX.fmt

\chapter{El modelo Box de CSS} \label{chp:boxmodel}

%\section{Introducción}

%if showChanges
\color{blue}
%endif

El resultado de fase 2 de la estructura de formato del \pref{chp:eformato} era generar los
|boxes| de renderización. Estos |boxes|, que son ventanas de |WxHaskell|, son utilizados para renderizar 
los elementos de una página Web. En otras palabras, cada elemento que se renderiza en la pantalla
es un |box|.

Las características de un |box| están definidas por el modelo |Box| de la especificación de CSS
(\pref{sec:mbox}). Sus dimensiones son calculados utilizando propiedades de CSS.\\

En éste capítulo se describirá la representación y renderización del modelo |box| de CSS.

%if showChanges
\color{black}
%endif 

\section{Propiedades del |Box| de CSS}

Un |box| de CSS es una caja rectangular con 4 áreas: |content|, |padding|, |border| y |margin|.
Cada área tiene sus propiedades de CSS que determinan sus características.

En esta sección se definirá funciones para obtener los valores de las propiedades de cada
área del |box|.

\subsection{Propiedades del \verb?margin-box?}
Las propiedades de \verb?margin? son: 
\begin{itemize}
    \item \verb?margin-top?. Determina el ancho que ocupa el margen superior de un |box|.
    \item \verb?margin-right?. Determina el ancho que ocupa el margen derecho de un |box|.
    \item \verb?margin-bottom?. Determina el ancho que ocupa el margen inferior de un |box|.
    \item \verb?margin-left?. Determina el ancho que ocupa el margen izquierdo de un |box|.
\end{itemize}

Para obtener el ancho que ocupa cada margen, se ha definido una función que obtenga los márgenes 
y los devuelva en una lista:

\begin{hs}
\small
\begin{code}
getMarginProperties props 
    =  map toInt  [ maybe 0 unPixelUsedValue (props `getM` "margin-top"     )
                  , maybe 0 unPixelUsedValue (props `getM` "margin-right"   )
                  , maybe 0 unPixelUsedValue (props `getM` "margin-bottom"  )
                  , maybe 0 unPixelUsedValue (props `getM` "margin-left"    )
                  ]
\end{code}
\caption{Obtener las propiedades del área de |margin|} \label{lhc:margen}
\end{hs}

\subsection{Propiedades del \verb?padding-box?}
Las propiedades del \verb?padding? son:
\begin{itemize}
    \item \verb?padding-top?. Determina el ancho que ocupa el padding superior de un |box|.
    \item \verb?padding-right?. Determina el ancho que ocupa el padding derecho de un |box|.
    \item \verb?padding-bottom?. Determina el ancho que ocupa el padding inferior de un |box|.
    \item \verb?padding-left?. Determina el ancho que ocupa el padding izquierdo de un |box|.
\end{itemize}

Al igual que en el \pref{lhc:margen}, se ha definido una función que obtenga las dimensiones del área de 
|padding|:

\begin{hs}
\small
\begin{code}
getPaddingProperties props 
    =  map toInt  [ maybe 0 unPixelUsedValue (props `getM` "padding-top"     )
                  , maybe 0 unPixelUsedValue (props `getM` "padding-right"   )
                  , maybe 0 unPixelUsedValue (props `getM` "padding-bottom"  )
                  , maybe 0 unPixelUsedValue (props `getM` "padding-left"    )
                  ]
\end{code}
\caption{Obtener las propiedades del área de |padding|} \label{lhc:padding}
\end{hs}

\subsection{Propiedades del \verb?border-box?} \label{sec:borderBox}
Las propiedades del \verb?border-box?, a diferencia de las anteriores que sólo tenían un ancho, 
están compuestas de: ancho, color y estilo para cada lado del borde.\\

Para el caso del |color| se ha definido una función que obtiene las propiedades de color
para el área del |border|:

\begin{hs}
\small
\begin{code}
getBorderColorProperties props 
    =  [ maybe (0,0,0) unKeyComputedColor (props `getM` "border-top-color"     )
       , maybe (0,0,0) unKeyComputedColor (props `getM` "border-right-color"   )
       , maybe (0,0,0) unKeyComputedColor (props `getM` "border-bottom-color"  )
       , maybe (0,0,0) unKeyComputedColor (props `getM` "border-left-color"    )
       ]
\end{code}
\caption{Obtener las propiedades de color para el área del |border|}
\end{hs}

Para el caso del |estilo|, también se ha definido otra función que obtiene las propiedades
de estilo para el área del |border|:

\begin{hs}
\small
\begin{code}
getBorderStyleProperties props 
    =  [ maybe "none" unKeyComputedValue (props `getM` "border-top-style"     )
       , maybe "none" unKeyComputedValue (props `getM` "border-right-style"   )
       , maybe "none" unKeyComputedValue (props `getM` "border-bottom-style"  )
       , maybe "none" unKeyComputedValue (props `getM` "border-left-style"    )
       ]
\end{code}
\caption{Obtener las propiedades de estilo para el área del |border|}
\end{hs}

Finalmente, se ha definido una función para obtener el ancho del área de un |border|:

\begin{hs}
\small
\begin{code}
getBorderProperties props 
    =  let  bst  = getBorderStyleProperties props
            bwd  = map toInt  [ maybe 0 unPixelUsedValue (props `getM` "border-top-width"     )
                              , maybe 0 unPixelUsedValue (props `getM` "border-right-width"   )
                              , maybe 0 unPixelUsedValue (props `getM` "border-bottom-width"  )
                              , maybe 0 unPixelUsedValue (props `getM` "border-left-width"    )
                              ]
       in zipWith (\str wd -> if str=="none" then 0 else wd) bst bwd
\end{code}
\caption{Obtener las propiedades de ancho para el área del |border|}
\end{hs}

El ancho de un borde depende en cierto modo del estilo, por ejemplo: si el estilo del borde es |"none"|,
entonces sin importar el ancho del borde, el ancho siempre sera |0|.

\subsection{Propiedades del \verb?content-box?}
Las propiedades del \verb?content-box? son: |width| y |height|.\\

Estas propiedades no se definen para cada lado. De manera que para obtener su valor, simplemente 
se busca el nombre en la lista de propiedades de CSS y se obtiene el valor en |pixels|, por ejemplo:

\begin{hs}
\small
\begin{code}
valor = unPixelUsedValue (props `get` "width")
\end{code}
\end{hs}


\section{Representación del Modelo |Box| de CSS}

Para representar el modelo |box| de CSS se utiliza una ventana rectangular de \wxhaskell. 
Específicamente se utiliza un |ScrolledWindow|.

Para representar las áreas de un |box| se realiza cálculos para encontrar las dimensiones 
de cada área.\\

El |box| que se genera para su renderización debe tener básicamente: un contenido (si es texto), 
una posición, sus dimensiones, la lista de propiedades y la lista de atributos. También se necesita
saber el tipo de |box| (|replaced|) y el |TypeContinuation| del |box|.\\

Para crear un |box| se ha definido una función que se encargue de crear el |scrolledWindow| 
y aplicar algunas propiedades. El \pref{lhc:box} muestra la función que se encarga de crear el |box|:

\begin{hs}
\small
\begin{code}
box cnt wn (x,y) (w,h) continuation props attrs amireplaced
    =  do  pnl <- scrolledWindow wn  [ size := sz w h
                                     , on paint := onBoxPaint  cnt 
                                                               continuation 
                                                               props 
                                                               attrs 
                                                               amireplaced
                                     ]
           windowMove pnl (pt x y)
           return pnl
\end{code}
\caption{Función para crear un |box|} \label{lhc:box}
\end{hs}

Con la definición del \pref{lhc:box} se puede representar los |boxes| que generan un |WindowText| y un |WindowContainer|:

\begin{hs}
\small
\begin{code}
boxText       = box
boxContainer  = box ""
\end{code}
\end{hs}

La única diferencia entre un |boxText| y |boxContainer| esta en el contenido del |boxContainer| (es un |String| vacío).

\section{Renderización de un Box}

En el \pref{lhc:box} se ha mostrado la función que crea el |scrolledWindow|.
Al momento de crear el |scrolledWindow| se configura las dimensiones de la ventana
con las dimensiones que se recibe como argumento, se utilizó la propiedad |size| de 
|WxHaskell| para configurar la dimensión de la ventana.\\

También se configura la posición de la ventana con la función |windowMove| de |WxHaskell|.\\

Finalmente, se configura la función de renderización del |box| utilizando la función \newline |onBoxPaint|
y el evento `on paint' de |WxHaskell|.
En las siguientes sub-secciones, se describirá en más detalle la función 
\newline 
|onBoxPaint|.

\subsection{La función de pintado de un |box|} \label{sec:pintadoBox}

A continuación se describirá paso a paso la función |onBoxPaint|.\\

Para empezar, la función |onBoxPaint| recibe: una cadena que es el contenido, el 
\newline
|TypeContinuation|
del |box|, la lista de propiedades de CSS, la lista de atributos y el tipo del elemento (|replaced|).
También recibe el |device context|, que se utiliza para pintar y dibujar en el |box| y finalmente 
recibe un rectángulo que representa la dimensión de la ventana:

\begin{hs}
\small
\begin{code}
onBoxPaint cnt tp props attrs replaced dc rt@(Rect x y w h) 
    = do ...
\end{code}
\end{hs}


\subsubsection{Configurando las fuentes}
Primeramente se debe configurar las fuentes de texto para renderizar el contenido:

\begin{hs}
\small
\begin{code}
    let myFont = buildFont props
    dcSetFontStyle dc myFont
\end{code}
\end{hs}

El \pref{lhc:buildFont} muestra la definición de la función |buildFont| que construye el estilo de la fuente 
utilizando la lista de propiedades de CSS.

\begin{hs}
\small
\begin{code}
buildFont props 
    = let  fsze  
             = toInt    $ (\vp -> vp/1.6) 
                        $ unPixelUsedValue (props `get` "font-size")
           fwgt  
             = toFontWeight $ computedValue (props `get` "font-weight")
           fstl  
             = toFontStyle  $ computedValue (props `get` "font-style")
           (family, face) 
             = getFont_Family_Face (computedValue (props `get` "font-family"))
      in fontDefault  { _fontSize    = fsze
                      , _fontWeight  = fwgt
                      , _fontShape   = fstl
                      , _fontFamily  = family
                      , _fontFace    = face
                      }
\end{code}
\caption{Construir la fuente del texto} \label{lhc:buildFont}
\end{hs}

Las funciones |toFontWeight|, |toFontStyle| y |getFont_Family_Face| (definidas en el \pref{lhc:fontstyle}) 
convierten valores de CSS a los correspondientes valores utilizables por \wxhaskell.

\begin{hs}
\small
\begin{code}
toFontWeight w =  case w of     KeyValue "bold"  -> WeightBold
                                otherwise        -> WeightNormal

toFontStyle s =  case s of  KeyValue "italic"   -> ShapeItalic
                            KeyValue "oblique"  -> ShapeSlant
                            otherwise           -> ShapeNormal

getFont_Family_Face fn 
    =  case fn of
            ListValue list  ->  case head list of
                                    StringValue str        -> (FontDefault,str)
                                    KeyValue "serif"       -> (FontRoman,"")
                                    KeyValue "sans-serif"  -> (FontSwiss,"")
                                    KeyValue "cursive"     -> (FontScript,"")
                                    KeyValue "fantasy"     -> (FontDecorative,"")
                                    KeyValue "monospace"   -> (FontModern,"")
                                    otherwise              -> (FontDefault,"")
            otherwise       ->  (FontDefault,"")
\end{code}
\caption{Funciones de conversión para renderizar las propiedades de la fuente de un texto} \label{lhc:fontstyle}
\end{hs}


\subsubsection{Obteniendo las propiedades del \textit{box}}

Para obtener las propiedades del |box| se utiliza las funciones definidas en las secciones anteriores:

\begin{hs}
\small
\begin{code}
    let [mt,mr,mb,ml]       = checkWithTypeElement tp $ getMarginProperties    props
    let [bt,br,bb,bl]       = checkWithTypeElement tp $ getBorderProperties    props
    let [ppt,ppr,ppb,ppl]   = checkWithTypeElement tp $ getPaddingProperties   props

    let [bct,bcr,bcb,bcl]   = map toColor $ getBorderColorProperties props
    let [bst,bsr,bsb,bsl]   = getBorderStyleProperties props
\end{code}
\caption{Obtener los valores de las propiedades de un box}
\end{hs}

La función |checkWithTypeElement| (definida en el \pref{lhc:check}) modifica cada lado de las dimensiones de 
acuerdo al |TypeContinuation| del |box|:

\begin{hs}
\small
\begin{code}
checkWithTypeElement tp lst@(wt:wr:wb:wl:[])
    =  case tp of
            Full    -> lst               -- se considera todas la dimensiones
            Init    -> [wt,0 ,wb,wl]     -- no se considera el lado derecho
            Medium  -> [wt,0 ,wb,0 ]     -- no se considera ninguno de los lados
            End     -> [wt,wr,wb,0 ]     -- no se considera el lado izquierdo
\end{code}
\caption{Verificar el |TypeContinuation| de un box} \label{lhc:check}
\end{hs}

También se utiliza funciones para convertir colores y estilos a valores utilizables
por \wxhaskell. El \pref{lhc:otros} muestra las funciones correspondientes.

\begin{hs}
\small
\begin{code}
toColor (r,g,b) = rgb r g b
toPenStyle s 
    =  case s of
            "hidden"   -> PenTransparent
            "dotted"   -> PenDash DashDot
            "dashed"   -> PenDash DashLong
            otherwise  -> PenSolid
\end{code}
\caption{Otras funciones de conversión para la renderización} \label{lhc:otros}
\end{hs}

\subsubsection{Calculando las dimensiones de las áreas}

Es posible obtener las esquinas de cada área haciendo operaciones de suma y resta sobre los
lados de cada área.


\begin{figure}[H]
    \begin{center}
        \scalebox{0.3}{\includegraphics{077-figura-figura020.jpg}}
    \end{center}
    \caption{Los lados de un box} \label{img:boxdim}
\end{figure}

Con ayuda de la \pref{img:boxdim}, se puede calcular los siguientes puntos:

\begin{hs}
\small
\begin{code}
    let (bx1,bx2)  = (ml,w-mr-1)
    let (by1,by2)  = (mt,h-mb-1)
    let ptContent  = pt (ml+bl+ppl) (mt+bt+ppt)
\end{code}
\end{hs}

\subsubsection{Pintando el background} \label{sec:paintBackground}

El |background| (|estilo de fondo del box|) se pinta sobre todo el \verb?content-box?, \verb?padding-box?
y \verb?border-box?.
El \pref{lhc:bcolor} describe la forma de obtener el valor de la propiedad \verb?background-color?. 

\begin{hs}
\small
\begin{code}
    let bkgBrush =  case props `getM` "background-color" of
                        Just p   ->  case computedValue p of
                                        KeyValue "transparent"  -> brushTransparent
                                        KeyColor value          -> brushSolid (toColor value)
                        Nothing  -> error "unexpected value at background-color property"
\end{code}
\caption{Obtener el valor de la propiedad \textit{background-color}} \label{lhc:bcolor}
\end{hs}

Finalmente, para pintar con la propiedad \textit{background-color}, se debe calcular la
dimensión del rectángulo donde se debe pintar:

\begin{hs}
\small
\begin{code}
    let bkgRect = rect (pt bx1 by1) (sz (bx2 - bx1 + 1) (by2 - by1 + 1))
    drawRect dc bkgRect [brush := bkgBrush, pen := penTransparent]
\end{code}
\end{hs}

\textbf{Nota.-} El WxHaskell para Gnu/Linux no tiene soporte para el estilo transparente de una ventana, esto limita
la renderización de ventanas transparentes, especialmente el área del margen de un |box|.

\subsubsection{Dibujando los bordes}

Para dibujar los bordes se ha definido la función |paintLine| en el \pref{lhc:pline}. Esta función
dibuja un borde de un ancho específico y en una dirección dada, recibe el |device context|, 
el punto inicial y final de línea, el ancho de la línea, el tipo de línea (horizontal o vertical) 
y la dirección con la que se dibujará la línea (de arriba a abajo o de abajo a arriba).

Si el ancho de la línea es |0|, no se dibuja nada:

\begin{hs}
\small
\begin{code}
paintLine  _   _        _        0      _     _    _     
    = return ()
paintLine  dc  (x1,y1)  (x2,y2)  width  kind  dir  style 
    =  do  line dc (pt x1 y1) (pt x2 y2) style
           if kind
             then do  let (y3,y4) =  if dir
                                     then (y1+1,y2+1) 
                                     else (y1-1,y2-1)
                      paintLine dc (x1,y3) (x2,y4) (width - 1) kind dir style
             else do  let (x3,x4) =  if dir 
                                     then (x1+1,x2+1)
                                     else (x1-1,x2-1)
                      paintLine dc (x3,y1) (x4,y2) (width - 1) kind dir style
\end{code}
\caption{Función para dibujar el borde un box} \label{lhc:pline}
\end{hs}

Utilizando la función |paintLine|, se dibuja los bordes de cada lado del |box|:

\begin{hs}
\small
\begin{code}
    paintLine dc (bx1,by1) (bx2,by1) bt True  True   [ penWidth     := 1
                                                     , penColor     := bct
                                                     , penKind      := toPenStyle bst
                                                     ]
    paintLine dc (bx2,by1) (bx2,by2) br False False  [ penWidth     := 1
                                                     , penColor     := bcr
                                                     , penKind      := toPenStyle bsr
                                                     ]
    paintLine dc (bx2,by2) (bx1,by2) bb True  False  [ penWidth     := 1
                                                     , penColor     := bcb
                                                     , penKind      := toPenStyle bsb
                                                     ]
    paintLine dc (bx1,by2) (bx1,by1) bl False True  [ penWidth      := 1
                                                    , penColor      := bcl
                                                    , penKind       := toPenStyle bsl
                                                    ]
\end{code}
\end{hs}

\subsubsection{Dibujando el contenido}

Finalmente, para dibujar el contenido de un |box| se debe considerar el tipo del |box|.\\

Si el |box| es |replaced|, se procede a dibujar la imagen (el único elemento |replaced| que se reconoce
es el nodo etiqueta |img|), caso contrario, se dibuja el contenido del |box|.\\

Para dibujar una imagen, se obtiene el |path| de la imagen, se calcula sus dimensiones y se 
escala de acuerdo a las dimensiones.\\

Cuando la ventana no  es |replaced|, se verifica el tipo del elemento de acuerdo a la propiedad |display|.
Si el tipo es |block|, no se dibuja nada porque el contenido se encuentra en los hijos, pero si es |inline|,
se dibuja el contenido del |box| con el color de texto correspondiente a la propiedad |color| de CSS.

\begin{hs}
\small
\begin{code}
if replaced
    then do  path <- getImagePath (getAttribute "src" attrs)
             let szimg = sz  (w-mr-br-ppr-1-ml-bl-ppl) 
                             (h-mb-bb-ppb-1-mt-bt-ppt)
             img1 <- imageCreateFromFile path
             img2 <- imageScale img1 szimg
             drawImage dc img2 ptContent []
             return ()
    else  case usedValue (props `get` "display") of
              KeyValue "block"  
                  -> return ()
              KeyValue "inline" 
                  -> do  let txtColor = toColor $ maybe  (0,0,0) 
                                                         unKeyComputedColor 
                                                         (props `getM` "color")
                         drawText dc cnt ptContent [color := txtColor]
\end{code}
\end{hs}

