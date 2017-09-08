
%include uuagc.fmt
%format :.: = "\mathbin{\circ}"

\chapter{Descripción de la Implementación de las Propiedades CSS} \label{chp:propiedadesCSS}

Las propiedades de CSS son importantes porque guían la renderización de un documento.
En este capítulo se describirá algunos detalles de la implementación de las propiedades
de CSS a las que se dá soporte en el proyecto.

\section{Programando las propiedades de CSS}
En este proyecto, se ha desarrollado un pequeño lenguaje de dominio específico dentro de Haskell
(\textit{Embeded Domain Specific Language, EDSL}) para describir el comportamiento de las
propiedades de CSS.\\

El EDSL permite describir el comportamiento de las propiedades de CSS a través del tipo
de dato |Property|. Para describir, se utiliza la función |mkProp|, que crea un |Property|
sólo con la información necesaria.

La función |mkProp| (\pref{sec:lprops}) recibe 6 parámetros: nombre de la propiedad (de tipo |String|),
información de herencia (de tipo |Bool|), valor inicial o por defecto (de tipo |Valor|), parser
para los valores de la propiedad (de tipo |Parser Valor|), función para procesar el |computedValue|
y función para procesar el |usedValue| de una propiedad.

3 de los parámetros de la función |mkProp|, son sencillos de declarar, pero no así el parser para los valores
y las 2 funciones para |computedValue| y |usedValue|.

\subsection{Parser para los valores de una Propiedad}

Para describir el parser para los valores de una propiedad se debe utilizar la librería \uuplib, que permite
describir el parser para una gramática directamente en Haskell.

Una de las ventajas de esta forma, es que se puede utilizar toda la capacidad de la librería para describir el
parser. Por ejemplo, se podría utilizar los combinadores especiales de permutaciones para describir las
propiedades |shorthand| de CSS.

\subsection{Función para el \textit{computedValue}}

También se debe especificar una función para procesar el |computedValue| de una propiedad.
Esta función debe tener el tipo |FuncionComputed| (descrita en el \pref{lhc:fcomputed} de la \pref{sec:computed})
que indica los parámetros que recibe y el valor que debe retornar.

Para la implementación de la función se puede utilizar la información de los parámetros que se recibe, 
como también toda la funcionalidad de Haskell.
A continuación se describe los parámetros que recibe la función:

\begin{itemize}
    \item El primer parámetro describe si el elemento es el nodo |Root|. El valor es indicado con el tipo |Bool|.

    \item El segundo parámetro contiene la lista de propiedades (de tipo |Map|) del nodo padre del elemento
          en el que se encuentra al procesar esta propiedad.

          Se puede confiar que todos los valores de propiedad para este parámetro, tienen procesado hasta el |computedValue|.
          Es decir, que los valores para todas las propiedades de este parámetro tienen asignado los valores para |specifiedValue|
          y |computedValue|, pero no tiene asignado el |usedValue|, ni |actualValue|.\\

          Junto con este parámetro, se puede utilizar todas las funciones de la librería |Map| de Haskell (su documentación
          esta disponible en el \pref{apd:map}). Además, también se puede utilizar la funciones definidas en la \pref{sec:funprops}.

    \item El tercer parámetro contiene la lista de propiedades (de tipo |Map|) del elemento donde se procesa esta propiedad.
          
          La restricción para este parámetro, es que sólo se tiene disponible el |specifiedValue| para todas las propiedades de la
          lista.
          Al igual que para el segundo parámetro, también se puede utilizar las funciones de |Map|.

    \item El cuarto parámetro indica si la propiedad es |replaced|, además indica si se trata de un elemento de texto
          (Nothing) o de uno con etiqueta (Just).

    \item El quinto parámetro indica si se trata de un \textit{pseudo-elemento}, porque existen algunas propiedades
          que sólo se aplican a \textit{pseudo-elementos}.

    \item El sexto parámetro indica el nombre la propiedad.

    \item El séptimo parámetro indica el |PropertyValue| de la propiedad.
\end{itemize}

Con todos los parámetros descritos, se puede implementar el comportamiento para procesar el |computedValue| de una propiedad.
Cuando el |computedValue| es el mismo que el |specifiedValue|, se puede utilizar la función |computed_asSpecified|.

\subsection{Función para el \textit{usedValue}}

Al igual que para el |computedValue|, también se debe especificar una función para procesar el |usedValue| de una propiedad.
Esta función debe tener el tipo |FunctionUsed| (descrita en el \pref{lhc:fused} de la \pref{sec:used}).

La función para el |usedValue| recibe casi los mismo parámetros que la función para el |computedValue|,
a continuación sólo se describe los parámetros que no se describieron en la anterior sub-sección.

\begin{itemize}
    \item El segundo parámetro corresponde a las dimensiones del contenedor inicial (\textit{Initial Container Box, icb}).
          Normalmente, estas dimensiones son necesarias cuando se encuentra un elemento que es |Root|.

    \item El quinto parámetro corresponde a la lista de atributos del elemento, que esta contenida en una estructura |Map|,
          lo que significa que se puede utilizar cualquiera de las funciones descritas en el \pref{apd:map}.

    \item El sexto parámetro indica el tipo del elemento (|replaced|) a través de un tipo |Bool|.
\end{itemize}


\section{Descripción de la implementación}

Describir una propiedad utilizando el EDSL de la anterior sección, sólo garantiza el comportamiento básico.
Para que una propiedad sea implementada por completo, se necesita implementar su forma de renderización;
aunque algunas propiedades no necesitan ser renderizadas, porque ayudan en la renderización de otras propiedades,
en la mayoría de los casos se necesita modificar algunas partes del proyecto.\\

En esta sección se mostrará los detalles más importantes de la implementación de las propiedades de CSS.

\subsection{Propiedad display}
Se tiene soporte para los siguientes valores de la propiedad |display|:
\textit{inline, block, list-item, none, inherit}.\\

El |computedValue| de la propiedad |display| es el mismo que el |specifiedValue|,
a menos que se encuentre en el nodo |Root|. 

Si se encuentra en el nodo |Root|, se utiliza la siguiente tabla de conversión:

\begin{verbatim}
    Specified Value   Computed Value
    "inline"       -> "block"
    "run-in"       -> "block"
    "inline-block" -> "block"
    en otro caso   -> el valor especificado
\end{verbatim}

El |usedValue| es el mismo que el |computedValue|.

\subsection{Propiedades para el formato horizontal}

Las propiedades para el formato horizontal son 7: \textit{margin-left}, \textit{border-width-left}, \textit{padding-left}, \textit{width},
\textit{padding-right}, \textit{border-width-right} y \textit{margin-right}.

\begin{figure}[H]
\begin{center}
    \scalebox{0.42}{\includegraphics{076-figura-figura019.jpg}}
\end{center}
\caption{7 Propiedades para el formato horizontal} \label{img:hprops}
\end{figure}

De manera general, cada una de estas propiedades puede ser especificado con una dimensión: valor |length| o porcentaje. 
Existen ciertas excepciones: el \textit{border-width} sólo puede ser |length|, el \textit{margin-left}, \textit{margin-right} y \textit{width}
también pueden ser especificados con un valor |auto|.\\

La funciones para obtener el |computedValue| de cada propiedad convierten el valor |length| a un valor |length| en |pixels|, pero 
si el valor del |specifiedValue| es |auto| o porcentaje, se copia directamente el valor del |specifiedValue| al |computedValue|
para que las funciones del |usedValue| la procesen.\\

Las funciones para obtener el |usedValue| calculan el ancho en |pixels| que cada propiedad ocupará. De manera general, si el valor del 
|computedValue| está en |pixels|, básicamente se copia el valor al |usedValue|, pero sí está en porcentajes, entonces se
convierte a valores en |pixels|. Existe un comportamiento diferente para las 3 propiedades que pueden ser |auto|, esto es: 
\textit{margin-left}, \textit{margin-right} y \textit{width}.\\

Cuando el valor de alguna de las 3 propiedades es |auto|, significa que el Navegador Web se encarga de asignar un valor en |pixels| para
esa propiedad.

La especificación de CSS \cite[cap.~10]{css21} indica que existe una ecuación para asignar un valor cuando alguna de las propiedades
es |auto|:

\begin{desc}
\small
\begin{verbatim}
'margin-left' + 'border-left-width' + 'padding-left' + 'width' + 'padding-right' +
'border-right-width' + 'margin-right' = width of containing block
\end{verbatim}
\caption{Ecuación para el formato horizontal} \label{desc:ec1}
\end{desc}

La \pref{desc:ec1} muestra la ecuación para encontrar el valor cuando alguna de las propiedades es |auto|.\\

Cuando sólo una de la propiedades es |auto| se puede utilizar la ecuación, para encontrar el valor para la propiedad que tiene |auto|, 
pero cuando dos o más propiedades tienen un valor de |auto|, o incluso cuando ninguno tiene un valor de |auto| no es posible utilizar 
la ecuación. Para resolver ese tipo de problemas la especificación de CSS ha definido las acciones a realizar para aplicar 
la ecuación de la \pref{desc:ec1}. En la \pref{desc:ec2} se muestra la tabla la cual guía la implementación.

\begin{desc}
\small
\input{056-ejemplo-ejemplo034}
\caption{Valores |auto| para el formato horizontal} \label{desc:ec2}
\end{desc}


\subsection{Propiedades para el formato vertical}

Al igual que para el formato horizontal, se tiene 7 propiedades para el formato vertical: 
\textit{margin-top}, \textit{border-width-top}, \textit{padding-top}, \textit{height},
\textit{padding-bottom}, \textit{border-width-bottom} y \textit{margin-bottom}.\\

Así como en el formato horizontal, cada una de estas propiedades puede ser especificado con una dimensión: valor |length| o porcentaje. 
Existen ciertas excepciones: el \textit{border-width} sólo puede ser |length|, el \textit{margin-top}, \textit{margin-bottom} y \textit{height}
también pueden ser especificados con un valor |auto|.\\

Las funciones para encontrar el |computedValue| para estas propiedades convierten los valores del |specifiedValue| a valores |pixel|, con 
la excepción de los valores |auto| y porcentaje, que son copiados directamente al |computedValue|.\\

Para el caso del |usedValue|, si el valor del |computedValue| está en |pixels|, se copia directamente al |usedValue|, pero sí está
en porcentajes, se convierte a valores en |pixels|. Cuando el valor de alguna de las 3 propiedades (\textit{margin-top}, 
\textit{margin-bottom} y \textit{height}) es |auto|, se tiene un comportamiento que es diferente al formato horizontal.\\

La especificación de CSS \cite[cap~10]{css21} dice que cuando el valor de \textit{margin-top}, \textit{margin-bottom} es |auto|, 
el valor para el |usedValue| se convierte directamente a |0|. Pero cuando el valor de la propiedad \textit{height} es |auto|,
se lo deja como |auto|, porque su altura será determinado por el contenido del contenedor.

\subsection{Propiedades para especificar el borde de un box}

Las propiedades de |border| especifican el ancho, color y estilo para cada borde de cada lado de un |box|. En las anteriores secciones 
de formato horizontal y vertical se describieron las propiedades para el ancho del borde (\textit{border-width}). Ahora 
se describirá las propiedades del borde para el color y estilo.\\

La \pref{sec:borderBox} describe en detalle como se renderizan estas propiedades.

\subsubsection{Propiedad border-color}

Se tiene cuatro propiedades que especifican el color para cada lado: \textit{border-color-top}, \textit{border-color-right}, 
\textit{border-color-bottom} y \textit{border-color-left}.\\

Cada una de estas propiedades puede ser especificada con un |color| o |inherit|. En la \pref{sec:basicCSS} se describe el |parser|
para reconocer un color.

\subsubsection{Propiedad border-style}

Se tiene cuatro propiedades que especifican el estilo para cada lado: \textit{border-style-top}, \textit{border-style-right}, 
\textit{border-style-bottom} y \textit{border-style-left}.\\

El estilo de cada borde puede ser especificado con los valores: |hidden|, |dotted|, |dashed|, |solid|, |none| o |inherit|.


\subsection{Propiedades para las fuentes de texto}

Las propiedades para especificar las fuentes de texto son: \textit{font-weight}, \textit{font-style}, \textit{font-family} 
y \textit{font-size}.
Estas propiedades son utilizadas al momento de renderizar el texto de un |box|, la \pref{sec:pintadoBox} describe en detalle
esta parte.\\

En la \pref{sec:lineline} se describe la propiedad \textit{font-size}, a continuación se describirá algunos detalles de las
otras propiedades para las fuentes de texto.

\subsubsection{Propiedad font-weight}
Se tiene soporte para los siguientes valores de la propiedad \textit{font-weight}: |normal|, |bold|, |inherit|.

\subsubsection{Propiedad font-style}
Se tiene soporte para los siguientes valores de la propiedad \textit{font-style}: |normal|, |italic|, |oblique|, |inherit|.

\subsubsection{Propiedad font-family}
Se tiene soporte para los siguientes valores de la propiedad \textit{font-family}: fuente |string|, |serif|, 
\textit{sans-serif}, |cursive|, |fantasy|, |monospace|, |inherit|.

La fuente |string| especifica una fuente de texto concreta, pero las demás (|serif|, \textit{sans-serif}, |cursive|, 
|fantasy|, |monospace|) especifican una fuente de texto genérica.\\

\textbf{Nota.-} Una característica de la propiedad \textit{font-family} es la capacidad de especificar una lista de fuentes de texto de manera
que si una fuente no está disponible, se puede utilizar alguna de las restantes, e incluso llegar a utilizar una por defecto.

La librería |WxHaskell| no permite saber si una fuente de texto está disponible, esto porque existe un error en el mapeo de funciones a 
la librería |WxWidget|. Entonces, no es posible implementar toda la funcionalidad de la propiedad \textit{font-family}.




\subsection{Posicionamiento estático y relativo}

La propiedad |position| de CSS permite especificar el tipo de posicionamiento que se utilizara al renderizar la página Web.
Se tiene soporte sólo para posicionamiento estático y relativo, es decir: |static|, |relative| e |inherit|.\\

Cuando el posicionamiento es estático, el Navegador Web se encarga de asignar las posiciones, pero cuando es relativo, 
el Navegador Web asigna posiciones las cuales pueden ser modificadas por el autor de la página Web. Para modificar la posición
asignada por el Navegador Web, el autor utiliza las propiedades |top|, |right|, |bottom|, |left| de CSS. 

Las 4 propiedades especifican la longitud a mover en relación (relativo) a la posición asignada por el Navegador Web.

Entonces, las 4 propiedades sólo son utilizadas cuando el posicionamiento es relativo. Los valores de estas 4 propiedades
pueden ser: un valor |lenght|, porcentaje positivo, |auto|, o |inherit|.


\subsection{Propiedad color}

La propiedad |color| define el color con que se va a renderizar el texto de un |box|. Sus valores pueden ser: |color| o |inherit|.

En la \pref{sec:basicCSS} se describe el |parser| para reconocer un |color|.

\subsection{Propiedades font-size, line-height y vertical-align} \label{sec:lineline}

Las propiedades \textit{font-size}, \textit{line-height} y \textit{vertical-align} son utilizadas para calcular las dimensiones
de una línea, en la \pref{sec:altura} se da más detalles de la implementación de estas propiedades.

\subsubsection{Propiedad font-size}

Se tiene soporte para los siguientes valores de la propiedad \textit{font-size}: |valor absoluto|, |valor relativo|, valor |lenght|
o un valor porcentaje positivo. El |valor absoluto| puede ser: \textit{xx-small}, \textit{x-small}, \textit{small}, \textit{medium},
\textit{large}, \textit{x-large}, \textit{xx-large}. El |valor relativo| puede ser: |smaller| o |larger|.\\

Se ha definido constantes para representar los valores absolutos del \textit{font-size}, pero para los valores relativos se incrementa
o decrementa una constante de |0.2| del valor del \textit{font-size} para elemento anidado.

\subsubsection{Propiedad line-height}

Se tiene soporte para los siguientes valores de la propiedad \textit{line-height}: valor |lenght| positivo, porcentaje positivo, o |inherit|.

\subsubsection{Propiedad vertical-align}

Se tiene soporte para los siguientes valores de la propiedad \textit{vertical-align}: valor |lenght|, porcentaje, |baseline|, |sub|, |super|, 
\textit{text-top}, \textit{text-bottom} o |inherit|.


\subsection{Generación de contenidos}

La generación de contenidos sólo se aplica a \textit{pseudo-elementos} que sean |before/after|:

\begin{desc}
\small
\begin{verbatim}
p:before { content: ...}
p:after  { content: ...}
\end{verbatim}
\caption{Generación de contenidos con \textit{pseudo-elementos}}
\end{desc}

Para especificar el contenido se utiliza la propiedad |content| de CSS.\\

Se tiene soporte para los siguientes valores de la propiedad |content|: |string|, |counter|, |counters|, \textit{open-quote},
\textit{close-quote}, \textit{no-open-quote}, \textit{no-close-quote}, |normal|, |none| e |inherit|.\\

Una vez que se describe el contenido con la propiedad |content|, el \textit{pseudo-selector} define donde insertar el contenido
generado. Por ejemplo, si el \textit{pseudo-selector} es `before', el contenido se insertará antes del elemento, pero sí es `after',
el contenido se insertará después del elemento.\\

La generación de contenidos se realiza antes de generar la estructura de formato de fase 1.
Por ejemplo, si el contenido es:

\begin{itemize}
    \item \textbf{String}, se genera un |BoxText| con el contenido especificado.
    \item \textbf{counter/counters}, el |box| a generar depende del estilo del |counter/counters|. Por ejemplo, si el estilo es
          |decimal|, \textit{upper-roman} o \textit{lower-roman}, entonces se genera un |BoxText| con el número generado por el
          contador.
          Pero si el estilo es |disc|, |circle| o |square|, entonces se genera un |BoxContainer| que es |replaced|, de manera 
          que se renderize en una imagen.

          Tanto para |counter| y |counters| se debe especificar una variable que representa el contador.
          El contador es controlado por dos propiedades de CSS:
          \begin{itemize}
              \item \textit{counter-reset}: se encarga de inicializar una o más variables en cero u opcionalmente en un valor
                    especificado.
              \item \textit{counter-increment}: se encarga de incrementar una o más variables en uno u opcionalmente en un valor 
                    especificado.
          \end{itemize}

          Entonces, cada vez que se encuentre un \textit{counter-reset} en las propiedades de un nodo, se inicializa un contador,
          y de igual manera, cada vez que se encuentre un \textit{counter-increment} en un nodo, se incrementa en un valor 
          al contador.

    \item \textbf{open-quote/close-quote/no-open-quote/no-close-quote}, dependiendo del tipo de |quote|, se genera un |BoxText|
          con el |quote| correspondiente o no se genera nada.

          El |quote| a insertar puede ser especificado por la propiedad |quotes| de CSS, el cual define lo que se va a insertar 
          en cada nivel anidado de un elemento, por ejemplo:

          \begin{verbatim}
    q {quotes: '"' '"' "'" "'" "<" ">"}
          \end{verbatim}

          define 3 niveles de anidamiento de |quote| para el elemento |q|. 
          Cada uno de estos |quotes| pueden ser insertados utilizando \textit{open-quote} y \textit{close-quote} de la propiedad
          |content|.

          Los valores \textit{no-open-quote} y \textit{no-close-quote} no insertan ningún contenido, pero sirven para emular 
          el comportamiento de colocar un |quote| para varios elementos, así como el elemento |blockquote| de HTML.\\

    \item \textbf{normal/none}, no se genera ningún contenido.

\end{itemize}

%\subsection{content}
%\subsection{counter-increment, counter-reset}
%\subsection{quotes}



\subsection{Listas}

Para dar soporte a listas de HTML se ha creado un nuevo constructor en la estructura de formato de fase 1 y 2, 
esto es: |BoxItemContainer| del \pref{lac:item1} para fase 1, y |WindowItemContainer| del \pref{lac:item2} para
fase 2.

\begin{ag}
\small
\begin{code}
DATA BoxTree
    |  BoxItemContainer
        props   : {Map.Map String Property}
        attrs   : {Map.Map String String} 
        boxes   : Boxes
    |  BoxContainer
        name    : String
        fcnxt   : {FormattingContext}
        ...
\end{code}
\caption{Tipo de dato para el ítem de las listas en fase 1} \label{lac:item1}
\end{ag}

\begin{ag}
\small
\begin{code}
DATA WindowTree
    |  WindowItemContainer
            marker      :  {ListMarker}
            sizeMarker  :  {(Int,Int)}
            elem        :  Element
            props       :  {Map.Map String Property}
            attrs       :  {Map.Map String String}
    |  WindowContainer
        name    : String
        ...
\end{code}
\caption{Tipo de dato para el ítem de las listas en fase 2} \label{lac:item2}
\end{ag}


Cuando el valor de la propiedad |display| es \textit{list-item} se genera un |BoxItemContainer|
para fase 1. El comportamiento de un |BoxItemContainer| es similar a un |BoxContainer|, incluso es más sencillo.
Por ejemplo el contexto de un |BoxItemContainer| siempre es |block|, así, no es necesario verificar si puede ser
|inline|.\\

Para fase 2, además del contenido del |box|, se debe generar un nuevo |box| que represente el tipo del ítem.
El tipo del ítem está controlado por la propiedad \textit{list-style-type}, que tiene soporte para los siguientes
valores: |disc|, |circle|, |square|, |decimal|, \textit{lower-roman}, \textit{upper-roman}, |none|.

La forma de representar el nuevo |box| que representa el ítem en fase 2 es a través del campo |marker| (tipo de ítem) y 
|sizeMarker| (dimensiones del ítem) del \pref{lac:item2}. El tipo del campo |marker| está descrito en el \pref{lac:item3}.

\begin{ag}
\small
\begin{code}
DATA ListMarker
    |  Glyph        name    : String
    |  Numering     value   : String
    |  NoMarker
\end{code}
\caption{Tipo de dato que representa el tipo de un ítem} \label{lac:item3}
\end{ag}

El \pref{lac:genitem} muestra la generación del campo |marker| y sus dimensiones para un |WindownItemContainer|.
Si el valor de la propiedad \textit{list-style-type} es |disc|, |circle| o |square| se genera un tipo de dato |Glyph|
con el nombre del tipo y una dimensión por defecto de 14x14 |pixels|, pero sí el tipo es \textit{decimal},
\textit{lower-roman} o \textit{upper-roman} se genera un tipo de dato |Numering| con el valor |String| en el formato
del tipo especificado, también se calcula las dimensiones que el |String| ocupará usando la función |getSizeBox|.

En el \pref{lac:genitem} se hace referencia a un atributo heredado |counterItem| que es el número que representa el
ítem en la lista de ítem del contenedor padre.

Las funciones |toRomanLower| y |toRomanUpper| del \pref{lac:genitem} son funciones que convierten un número decimal
a un número romano.

\begin{ag}
\small
\begin{code}
SEM BoxTree
    |  BoxItemContainer 
        loc.marker 
            =  case computedValue (@props `get` "list-style-type") of
                        KeyValue "none"     -> (NoMarker      , (0,0)  )
                        KeyValue "disc"     -> (Glyph "disc"  , (14,14))
                        KeyValue "circle"   -> (Glyph "circle", (14,14))
                        KeyValue "square"   -> (Glyph "square", (14,14))
                        KeyValue "decimal" 
                            -> let str       = show ^^ @lhs.counterItem ++ "."
                                   (w,h,_,_) = unsafePerformIO $ getSizeBox str @lhs.cb ^^ @loc.usedValueProps
                               in (Numering str, (w,h))
                        KeyValue "lower-roman"
                            -> let str       = toRomanLower ^^ @lhs.counterItem ++ "."
                                   (w,h,_,_) = unsafePerformIO $ getSizeBox str ^^ @lhs.cb @loc.usedValueProps
                               in (Numering str, (w,h))
                        KeyValue "upper-roman"
                            -> let str       = toRomanUpper @lhs.counterItem ++ "."
                                   (w,h,_,_) = unsafePerformIO $ getSizeBox str ^^ @lhs.cb @loc.usedValueProps
                               in (Numering str, (w,h))
\end{code}
\caption{Generación del tipo y dimensiones del ítem} \label{lac:genitem}
\end{ag}

\vspace{2cm}

Además de generar el tipo y dimensión para el campo |marker| y |sizeMarker| respectivamente, también se debe generar 
una posición para el campo |marker|. Generar una posición para el campo |marker| afecta el posicionamiento del contenido,
de manera que el contenido debe recorrerse para no estar posicionado encima del campo |marker|. El \pref{lac:positem}
muestra la asignación de posiciones para el campo |marker| y contenido.

Se crea una variable local |markerPosition| para guardar la posición del campo |marker|.

\begin{ag}
\small
\begin{code}
SEM WindowTree
    |  WindowItemContainer
        loc.markerPosition
            =  let (x,y) = snd ^^ @lhs.statePos
               in (x,y + 2) -- para nivelar los bordes
        loc.position 
            = let  cposition  =  computedValue $ @props `get` "position"
                   (x,y)      =  let pos = snd ^^ @lhs.statePos
                                 in (fst ^^ @sizeMarker + fst pos + 6, snd pos)
              in  case cposition of
                    KeyValue "static"       ->  (x,y)
                    KeyValue "relative"     ->  let (xdespl, ydespl) = getDesplazamiento @props
                                                in (x + xdespl, y + ydespl)
        elem.statePos = let pointContent = getTopLeftContentPoint Full @props
                        in (BlockContext, pointContent)
\end{code}
\caption{Asignación de posiciones para |WindowItemContainer|} \label{lac:positem}
\end{ag}

Finalmente, para renderizar un |WindowItemContainer| se genera dos |boxes|, uno para representar
el |marker| y otro para el contenido. El \pref{lac:genboxitem} muestra la generación de |boxes|.

\begin{ag}
\small
\begin{code}
SEM WindowTree
    |  WindowItemContainer
        lhs.result = \cb -> 
            do  case ^^ @marker of
                            Numering str 
                                -> box str cb ^^ @loc.markerPosition ^^ @sizeMarker Full ^^ @props ^^ @attrs False
                            Glyph name 
                                ->  let attrs' = Map.insert "src" (name ++ ".png") @attrs
                                    in box "" cb ^^ @loc.markerPosition ^^ @sizeMarker Full ^^ @props attrs' True
                            NoMarker     
                                -> return ()
                cbox <- boxContainer cb ^^ @loc.position ^^ @loc.size Full ^^ @props ^^ @attrs False
                mapM_ (\f -> f cbox) @elem.result
\end{code}
\caption{Generación de |boxes| para |WindowItemContainer|} \label{lac:genboxitem}
\end{ag}

Si el tipo del |marker| es |Numering|, se genera un |box| con el |String| que contiene el |Numering|, posición
y dimensión. Pero si es un |Glyph|, se genera un elemento |replaced| que contiene una imagen, posición y dimensión.
(Para cada tipo del |marker| se ha generado una imagen de 14x14 |pixels|).

%{list-style-position, list-style-type}



\subsection{Propiedad background-color}

El valor para la propiedad \textit{background-color} puede ser cualquier color, |transparent| o |inherit|.\\

Esta propiedad se aplica al momento de renderizar el |box|. La \pref{sec:paintBackground} describe la forma
en que se implementa esta propiedad. Y la \pref{sec:basicCSS} describe el |parser| para especificar un |color|.

\subsection{Propiedad text-indent}

El valor para la propiedad \textit{text-indent} puede ser cualquier valor |length|, porcentage o |inherit|.
Esta propiedad sólo se aplica a elementos |block| que tengan un contexto de formato |inline|.\\

El algoritmo desarrollado en el (\pref{lac:wrapline}) de la \pref{sec:aline}, que tiene soporte para un valor de sangria,
muestra como se obtiene el valor de esta propiedad, el cual al mismo tiempo, es enviado como argumento a la función |applyWrap|.\\

En la estructura de formato de fase 2, se generan las posiciones para cada línea. El valor de esta propiedad
sólo afecta a la posición |x| de la primera línea de un contenedor. En el \pref{lac:posline} se muestra 
como se modifica la posición |x| de la primera línea.

\begin{ag}
\small
\begin{code}
SEM Lines
    | Cons hd.statePos =  let  (x,y)  = snd ^^ @lhs.statePos
                               newX   =  if ^^ @lhs.amifirstline
                                         then x + @lhs.indent
                                         else x
                          in (fst ^^ @lhs.statePos,(newX, y))
\end{code}
\caption{Aplicando el valor de \textit{text-indent} a la primera línea} \label{lac:posline}
\end{ag}



\subsection{Propiedad text-align}

Se tiene soporte para los siguientes valores de la propiedad \textit{text-align}: |left|, |right|, |center|, |inherit|.\\

Esta propiedad sólo se aplica a elementos |block| que tienen un contexto de formato |inline|.\\
La misma que se implementa al momento de generar las posiciones para cada |box|, es decir en la estructura de formato de fase 2
(\pref{sec:fase2}). Si el valor de la propiedad es |left|, se asigna las posiciones |x| de manera normal (desde la izquierda). 

Si el valor de la propiedad es |right|, se calcula la longitud de espacio sobrante (la resta entre el ancho del contenedor y línea) 
y se suma a la posición |x|, como si se tratara de un valor de sangría, y luego se asigna posiciones de manera normal.

Si su valor es |center|, entonces también se calcula la longitud del espacio sobrante, pero en vez de sumarle a |x| todo el valor, sólo se suma
la mitad de la longitud restante, y se continua asignando las posiciones. El \pref{lac:align} muestra la parte de asignación de posiciones
para esta propiedad.

\begin{ag}
\small
\begin{code}
SEM Line
    | Line  winds.statePos 
        =  case ^^ @lhs.align of
            "left"    ->  @lhs.statePos
            "right"   ->  let  (_,y)  = snd @lhs.statePos
                               newX   = @lhs.width - @winds.innerLineWidth
                          in (fst ^^ @lhs.statePos, (newX,y))
            "center"  ->  let  (_,y)  = snd ^^ @lhs.statePos
                               newX   = (@lhs.width - @winds.innerLineWidth) `div` 2
                          in (fst ^^ @lhs.statePos, (newX,y))
\end{code}
\caption{Asignación de posiciones para la propiedad \textit{text-align}} \label{lac:align}
\end{ag}

\subsection{Propiedad text-decoration}

Se tiene soporte para los siguientes valores de la propiedad \textit{text-decoration}: |underline|, |overline|, \textit{line-through},
|none|, |inherit|.\\

Esta propiedad se aplica al momento de renderizar el texto de un |box|. Si el valor es |none|, no se realiza nada, pero sí el valor
es diferente a |none|, entonces se debe dibujar una línea de acuerdo al tipo de valor. Si el valor es |underline|, se dibuja una línea
por debajo del |baseline| del texto, si el valor es |overline|, se dibuja una línea en la parte superior del texto, pero sí el valor
es \textit{line-through}, se dibuja una línea por el medio del texto.

El \pref{lac:pdecoration} muestra la implementación del dibujado de líneas.

\begin{hs}
\small
\begin{code}
doDecoration dc (Point x y) txtColor (Size width height, baseline, a) value
    =  case value of
          KeyValue "underline" 
              ->  do  let yb = height - baseline + 2
                      line dc (pt 0 yb) (pt width yb) [penColor := txtColor]
          KeyValue "overline"
              ->  do  let yb = y
                      line dc (pt 0 yb) (pt width yb) [penColor := txtColor]
          KeyValue "line-through"
              ->  do  let yb = height - baseline - ((height - baseline) `div` 3)
                      line dc (pt 0 yb) (pt width yb) [penColor := txtColor]
\end{code}
\caption{Implementación del comportamiento para la propiedad \textit{text-decoration}} \label{lac:pdecoration}
\end{hs}


\subsection{Propiedad text-transform}

Se tiene soporte para los siguientes valores de la propiedad \textit{text-transform}: |capitalize|, |uppercase|, 
|lowercase|, |none|, |inherit|.\\

Esta propiedad se aplica al momento de renderizar el texto de un |box|. Se ha utilizado funciones |toUpper| y |toLower| 
del módulo |Char| de Haskell para implementar el comportamiento de los valores de esta propiedad. El \pref{lhc:ptransform} muestra
la implementación del comportamiento para esta propiedad.

\begin{hs}
\small
\begin{code}
applyTextTransform props str 
    =  case usedValue (props `get` "text-transform") of
          KeyValue "none" 
              ->  str
          KeyValue "capitalize"
              ->  let  newStr        = words str
                       fcap (c:cs)   = toUpper c : cs
                  in unwords $ map fcap newStr
          KeyValue "uppercase"
              ->  map toUpper str
          KeyValue "lowercase"
              ->  map toLower str
\end{code}
\caption{Implementación del comportamiento para la propiedad \textit{text-transform}} \label{lhc:ptransform}
\end{hs}

\subsection{Propiedad white-space} \label{sec:wspace}

Se tiene soporte para los siguientes valores de la propiedad \textit{white-space}: \textit{normal}, \textit{pre}, 
\textit{nowrap}, \textit{pre-wrap}, \textit{pre-line}, \textit{inherit}.\\

En \cite[cap.~6]{cssGuide} se tiene una tabla que resume el comportamiento de cada valor para esta propiedad, la cual
se muestra en la \pref{desc:pwhite}.\\

La columna de \textit{whitespace} hace referencia a los espacios y tabs, si es |Collapsed| significa que se debe eliminar
todos los espacios y tabs, pero sí es |Preserved| se debe conservar todos los espacios y tabs.

La columna de |Linefeeds| hace referencia a los saltos de línea, si su valor es |Ignored|, se debe eliminar todos los saltos
de línea, pero sí es |Honored|, se debe conservar todos los saltos de línea.

La columna |Auto line wrapping| hace referencia a la forma automática de acomodar los elementos en líneas,
por ejemplo si el valor es |Allowed|, significa que el Navegador Web debe insertar saltos de línea para que los elementos
se acomoden de acuerdo al ancho del contenedor, pero sí el valor es |Prevented|, el Navegador Web no insertará saltos de línea a menos
que sean explícitamente declarador por el autor de la página web.

\begin{desc}
\small
\begin{verbatim}
Valor           Whitespace          Linefeeds           Auto line wrapping
normal          Collapsed           Ignored             Allowed
nowrap          Collapsed           Ignored             Prevented
pre             Preserved           Honored             Prevented
pre-wrap        Preserved           Honored             Allowed
pre-line        Collapsed           Honored             Allowed
\end{verbatim}
\caption{Comportamiento de la propiedad \textit{white-space}} \label{desc:pwhite}
\end{desc}

La propiedad \textit{white-space} se aplica sólo a elementos que contienen texto. Se ha utilizado funciones 
del módulo |List| de Haskell para 
implementar el comportamiento de esta propiedad. El \pref{lhc:whitespace} muestra la implementación para las columnas
|Whitespace| y |Linefeeds| de la \pref{desc:pwhite}.

\begin{hs}
\small
\begin{code}
processString isSpaceCollapsed isLineFeedIgnored input
    =  case (isSpaceCollapsed, isLineFeedIgnored) of
        (True , True )  ->    unwords :.: words $ input     -- case of normal and nowrap
        (True , False)  ->    unlines
                            :.: map unwords 
                            :.: map words 
                            :.: lines $ input               -- case of pre-line
        otherwise       ->    input                         -- case of pre and pre-wrap
\end{code}
\caption{Implementación de |Whitespace| y |Linefeed|} \label{lhc:whitespace}
\end{hs}

Para la columna |Auto line wrapping| se utiliza la función |lines| del módulo |List| de Haskell.\\

La 1ra y 2da columna se aplican antes de generar la estructura de formato de fase 1 (\pref{sec:genFSTree}), pero
la 3ra columna se aplica antes de generar los elementos atómicos en la estructura de formato de fase 1(\pref{sec:fase1}).\\

