
%include uuagc.fmt

\chapter{Tutorial para la librería UUAGC} \label{apd:agtutorial}

En este apéndice hallarás un tutorial simple para la librería |UUAGC|\footnote{UUAGC: Utrecht University 
Atribute Grammar Compiler}\cite{uuagclib}. El lector interesado en una descripción completa puede revisar
la página Web de la librería y encontrar el manual de |UUAGC|.\\

Además de mostrar un tutorial simple, este apéndice se enfoca en mostrar el flujo de información que ocurre 
cuando se utiliza la librería |UUAGC| para definir la semántica de la gramática.

Como una aplicación del apéndice, se desarrollará un módulo que genere las posiciones, dimensiones y líneas
para renderizar una estructura de árbol.

\section{Introducción}
Si se tiene el siguiente código HTML:

\begin{desc}
\small
\begin{verbatim}
<html>
    <head> <style>
                estilo
           </style>
    </head>
    <body>
        <p> texto1 </p>
        <p> texto2 </p>
    </body>
</html>
\end{verbatim}
\caption{Ejemplo de HTML} \label{desc:ex21}
\end{desc}

El cual puede ser representado en Haskell, sin considerar el texto, de la siguiente manera:

\begin{hs}
\small
\begin{code}
FSBox "html"  [ FSBox "head"  [ FSBox "style" [FSBox "texto" []]]
              , FSBox "body"  [ FSBox "p" [FSBox "texto" []]
                              , FSbox "p" [FSBox "texto" []]
                              ]
              ]
\end{code}
\caption{Representación Haskell de la \pref{desc:ex21}} \label{lhc:hsExample}
\end{hs}

y lo que se quiere, es dibujar una estructura de árbol que represente el código HTML
de la \pref{desc:ex21}:

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{061-figura-figura004.jpg}}
\end{center}
\caption{Renderización del ejemplo de la \pref{desc:ex21}} \label{img:figExample}
\end{figure}

Entonces, para renderizar la \pref{img:figExample} que representa la \pref{desc:ex21},
se debe generar una posición y dimensión para cada |FSBox| del \pref{lhc:hsExample}.
También se debe generar las líneas entre cada |FSBox|.\\

En este apéndice se utilizará la librería |UUAGC| para generar toda la información que
se va a renderizar: posición, dimensión y líneas.\\

La librería |UUAGC| es una herramienta que permite describir la semántica de una gramática
a través de atributos.
Lo interesante es que la librería permite utilizar código Haskell para la descripción de la
semántica.

La librería |UUAGC| es un lenguaje que tiene su propia sintaxis, pero que 
genera código Haskell, que puede ser utilizado en cualquier compilador de Haskell.\\

Se ha utilizado la librería |UUAGC| porque permite describir la semántica de la gramática
de manera sencilla, comprensible y en Haskell, además porque permite ahorrar la cantidad de código
que se tiene que escribir.\\

En las siguientes secciones, primero se describirá algunos elementos de la librería |UUAGC|
(los que se ha considerado importantes) y luego se describirá la forma de generar las
posiciones, dimensiones y líneas para el |FSBox|.

\section{Declaraciones DATA}

La librería |UUAGC| permite definir una gramática como una colección de declaraciones |DATA|.\\

Un |DATA| declara un \textit{No-Terminal} y sus producciones, donde cada producción contiene
el nombre del constructor y campos que contiene la producción. Cada campo debe tener un nombre único
y tipo.\\ 

Por ejemplo, la declaración de |DATAs| para el |FSBox| que se usará es:

\begin{ag}
\small
\begin{code}
DATA FSBox
    | FSBox     name    : String
                boxes   : FSBoxes

TYPE FSBoxes = [FSBox]
\end{code}
\caption{Declaración DATA para FSBox} \label{lac:fstree}
\end{ag}


\section{Descripción del comportamiento con UUAGC}

La librería |UUAGC| permite especificar atributos y semánticas para describir
el comportamiento que se desea implementar.

En otras palabras, la información que se desea procesar es almacenada en atributos,
pero la \textit{forma} de procesar la información es descrita a través de la semántica.

\subsection{Atributos de UUAGC}

Un atributo abstrae la información que se va a procesar y la forma de flujo de información 
que se va a realizar.

Se tiene, básicamente, dos formas de flujo: de \textit{abajo-arriba} y de \textit{arriba-abajo}.
Por ejemplo, se puede sumar una lista de enteros de dos formas:

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{080-figura-figura023.jpg}}
\end{center}
\caption{Flujos de información para sumar una lista de enteros}
\end{figure}

Entonces, de acuerdo al flujo de información, se tiene 3 formas de atributos:

\begin{itemize}
    \item \textbf{Atributos Heredados}. Son atributos que tienen un flujo de información
          de \textit{arriba-abajo}.
    \item \textbf{Atributos Sintetizados}. Son atributos que tienen un flujo de información
          de \textit{abajo-arriba}.
    \item \textbf{Atributos Encadenados}. Son atributos que son heredados y sintetizados
          al mismo tiempo.
\end{itemize}

Para declarar un atributo se debe seguir la siguiente estructura:

\begin{desc}
\small
\begin{verbatim}
ATTR No_Terminales  [ atributos_Heredados 
                    | atributos_Encadenados 
                    | atributos_Sintetizados
                    ]
\end{verbatim}
\caption{Estructura para declarar un atributo} \label{desc:eattr}
\end{desc}

Donde \verb?No_Terminales? es una lista de No-Terminales separados con espacios, 
\newline
\verb?atributos_Heredados?,
\verb?atributos_Encadenados?, \verb?atributos_Sintetizados? son una lista de declaraciones separados
por espacios que tienen la siguiente forma:

\begin{verbatim}
nombreAttributo : tipoAttributo
\end{verbatim}

El |tipoAtributo| puede ser simple (|Int, Float, String, ...|) o complejo (|[Int]|, |Map String String|, |Maybe Int|), 
cuando es complejo debe estar encerrado entre llaves (|{[Bool]}|).\\

Algunos ejemplos de declaraciones de atributos son:

\begin{ag}
\small
\begin{code}
ATTR Arbol [ ^^ | ^^ | valmin:Int]
ATTR Arbol [ ming: Int | ^^ | ^^ ]

ATTR Arbol [ profundidad : Int | minimo : Int | salida : {[Bool]} ]
ATTR Decl [ contador1:Int contador2:Int | ^^ | contador:Int ]
\end{code}
\caption{Ejemplos de declaraciones de Atributos con |UUAGC|}
\end{ag}

\subsection{Especificación de la semántica con |UUAGC|}

La semántica define el como se va procesar la información de un atributo. La librería |UUAGC|
provee la estructura |SEM| para la especificación de la semántica:

%format Constructor_1
%format Constructor_n
%format referencia_1
%format referencia_2
%format referencia_n
%format nombreAtributo_1
%format nombreAtributo_2
%format nombreAtributo_n
%format expresionHaskell_1
%format expresionHaskell_2
%format expresionHaskell_n

\begin{desc}
\small
\begin{code}
SEM Noterminal
    | Constructor_1  referencia_1.nombreAtributo_1 = expresionHaskell_1
                     referencia_2.nombreAtributo_2 = expresionHaskell_2
    ...
    | Constructor_n  referencia_n.nombreAtributo_n = expresionHaskell_n
\end{code}
\caption{Estructura para declarar la semántica} \label{desc:esem}
\end{desc}

La estructura |SEM| se utiliza para definir la semántica para un No-Terminal. Este es definido
a través de una expresión de Haskell para una producción y atributo determinado.

Para referirse a un atributo se utiliza una referencia (|lhs|,|loc|,|nombreProduccion|) y el
nombre de un atributo. Las referencias a los atributos también pueden aparecer en la 
expresión Haskell, pero deben estar prefijadas con el símbolo `|@|'. Los atributos |loc| son 
variables locales a nivel de la producción que se definen directamente en la estructura |SEM|.

Dependiendo el lugar donde se encuentren las referencias a los atributos, lado derecho (dentro expresión Haskell) 
o lado izquierdo (ver \pref{desc:esem}), tienen diferentes significados:

\begin{itemize}
    \item \textbf{lhs}: Si se encuentra en el lado izquierdo, hace referencia a un atributo sintetizado, pero
                        si se encuentra en el lado derecho (dentro de la expresión Haskell) hace referencia 
                        al atributo heredado del No-Terminal padre del actual No-Terminal.
    \item \textbf{nombreProduccion}: Si se encuentra en el lado izquierdo, hace referencia al atributo heredado,
                                     pero si se encuentra en el lado derecho (dentro de la expresión Haskell)
                                     hace referencia al atributo sintetizado del |nombreProduccion|.
    \item \textbf{loc}: En ambos lados hacen referencia al mismo atributo.
\end{itemize}

\subsection{Declaraciones TYPE}

La estructura |TYPE| permite definir No-Terminales comunes utilizando una sintaxis especial.

Por ejemplo, se puede definir listas de la siguiente manera:

\begin{ag}
\small
\begin{code}
TYPE Enteros = [ Numero ]
\end{code}
\caption{Sintaxis especial para la definición de listas} \label{lac:listas1}
\end{ag}

La definición del \pref{lac:listas1} genera la siguiente declaración |DATA|:

\begin{ag}
\small
\begin{code}
DATA Enteros
    |  Cons  hd  : Numero
             tl  : Enteros
    |  Nil
\end{code}
\caption{Definición DATA para listas} \label{lac:listas2}
\end{ag}

Además de listas, la librería también provee una sintaxis especial para declarar tuplas, estructuras |Map|,
|Maybe|, |Either|, |IntMap|.


\section{Generar la información}

En esta sección se procederá a generar la información necesaria para renderizar: posiciones, dimensiones
y líneas.\\

Se inicia definiendo un |DATA Root| el cual se encarga simplemente de marcar el nodo Root de la
estructura de árbol:

\begin{ag}
\small
\begin{code}
DATA FSRoot
    | FSRoot fsbox: FSBox
\end{code}
\caption{Definición de Root}
\end{ag}

\subsection{Generando la posición `y'}

Se comenzará con la generación de la posición `y' para cada |FSTree| del \pref{lac:fstree}.\\

Inicialmente, se tiene una posición `y' inicial donde se comenzará a dibujar: |yInit = 10|.

\begin{figure}[H]
\begin{center}
    \scalebox{0.4}{\includegraphics{081-figura-figura024.jpg}} 
\end{center}
\caption{Posición `y' para cada |FSBox|} \label{img:ypos01}
\end{figure}

A partir de la posición inicial se genera la posición `y' para cada |FSTree|. Para calcular la 
posición `y' para los nodos hijos de un |FSTree| se incrementa una distancia, así como se ve en 
la \pref{img:ypos01}.\\

Entonces, la forma de asignar una posición `y' a cada |FSTree| es utilizando un atributo heredado
(\textit{arriba-abajo}) para |FSBox| y |FSBoxes|:

\begin{ag}
\small
\begin{code}
ATTR FSBox FSBoxes [yPos: Int | ^^ | ^^ ]
\end{code}
\caption{Atributo heredado |yPos|}
\end{ag}

Se especifica la posición inicial en el nodo |Root|, el lugar donde comienza todo el |FSTree|:

\begin{ag}
\small
\begin{code}
SEM FSRoot
    | FSRoot fsbox.yPos = 10
\end{code}
\caption{Posición inicial `y'}
\end{ag}

Se crea una variable local (sólo por motivos didácticos) |yPos| para cada |FSBox|, el cual guarda
la posición `y' del |FSBox|. 

\begin{ag}
\small
\begin{code}
SEM FSBox
    | FSBox     loc.yPos    = @lhs.yPos
                boxes.yPos  = @loc.yPos + ySep
\end{code}
\caption{Posición `y' para |FSBox|} \label{lac:ypos1}
\end{ag}

En el \pref{lac:ypos1} se especifica que la posición `y' (|yPos|) para los hijos (|boxes|)
es la posición del |FSBox| (|@loc.yPos|) más una cantidad de separación (|ySep|). La cantidad de 
separación es una constante que equivale a: |80|.\\

En el No-Terminal |FSBoxes|, el atributo |yPos| se copia a cada elemento:

\begin{ag}
\small
\begin{code}
SEM FSBoxes
    | Cons  hd.yPos  = @lhs.yPos
            tl.yPos  = @lhs.yPos
\end{code}
\caption{Posición `y' para |FSBoxes|} \label{lac:ypos2}
\end{ag}

En el \pref{lac:ypos2}, sólo se declara la semántica para la producción |Cons| porque la producción |Nil|
no tiene ningún campo que herede el atributo |yPos|.

\textbf{Nota.-} No es necesario especificar la semántica para |FSBoxes| del \pref{lac:ypos2}, porque
                la librería |UUAGC| puede derivar la semántica aplicando una regla de copiado. Pero
                no existe ningún problema si este es especificado.\\

Gráficamente, las siguientes figuras: \pref{img:ypos0}, \pref{img:ypos1}, \pref{img:ypos2} muestran el movimiento del 
atributo |yPos| para el |FSRoot|, |FSBox| y |FSBoxes| respectivamente:

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{082-figura-figura025.jpg}} 
\end{center}
\caption{Atributo |yPos| para |FSRoot|} \label{img:ypos0}
\end{figure}

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{083-figura-figura026.jpg}} 
\end{center}
\caption{Atributo |yPos| para |FSBox|} \label{img:ypos1}
\end{figure}

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{084-figura-figura027.jpg}} 
\end{center}
\caption{Atributo |yPos| para |FSBoxex|} \label{img:ypos2}
\end{figure}

La \pref{img:yposc} muestra el movimiento de información para el ejemplo de la \pref{desc:ex21}
con el atributo |yPos|:

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{085-figura-figura028.jpg}} 
\end{center}
\caption{Movimiento de información para el atributo |yPox|} \label{img:yposc}
\end{figure}

\subsection{Calculando el ancho que ocupa un |FSBox|}

En la \pref{img:ancho} se muestra que cada |FSBox| tiene un ancho. 

El ancho de cada |FSBox| es la sumatoria del ancho de todos |FSBox| hijos.
Si un |FSBox| no tiene hijos, entonces el ancho debe ser un valor por defecto: la
longitud del |FSBox| más la distancia de separación, esto es:

\begin{verbatim}
anchoPorDefecto = widthBox + xSep

widthBox = 95
xSep     = 40
\end{verbatim}

El \pref{lac:len0} muestra la especificación para calcular el ancho para el |FSBox| y |FSBoxes|. 

Se utiliza un atributo sintetizado (\textit{abajo-arriba}) |len| para |FSBox| y |FSBoxes|.
También se utiliza una variable local |len| en |FSBox| para guardar el ancho que ocupa el |FSBox|.

\begin{ag}
\small
\begin{code}
ATTR FSBox FSBoxes [ ^^ | ^^ | len: Int ]
SEM FSBox
    | FSBox     loc.len =   if @boxes.len == 0
                            then widthBox + xSep
                            else @boxes.len
                lhs.len = @loc.len

SEM FSBoxes
    | Cons  lhs.len = @hd.len + @tl.len
    | Nil   lhs.len = 0
\end{code}
\caption{Calcular el ancho de un |FSBox| y |FSBoxes|} \label{lac:len0}
\end{ag}

\begin{figure}
\begin{center}
    \scalebox{0.5}{\includegraphics{086-figura-figura029.jpg}} 
\end{center}
\caption{Ancho de cada |FSBox|} \label{img:ancho}
\end{figure}

La \pref{img:len1} y \pref{img:len2} representa el movimiento del atributo |len| para |FSBox| y |FSBoxes|
respectivamente. Y la \pref{img:lenc} muestra el movimiento de información para el ejemplo de la \pref{desc:ex21}
con el atributo |len|:

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{087-figura-figura030.jpg}} 
\end{center}
\caption{Atributo |len| para |FSBox|} \label{img:len1}
\end{figure}

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{088-figura-figura031.jpg}} 
\end{center}
\caption{Atributo |len| |FSBoxes|} \label{img:len2}
\end{figure}

\begin{figure}
\begin{center}
    \scalebox{0.5}{\includegraphics{089-figura-figura032.jpg}} 
\end{center}
\caption{Movimiento de información para el atributo |len|} \label{img:lenc}
\end{figure}

\textbf{Nota:} Es posible reducir la cantidad de líneas para el \pref{lac:len0} utilizando
la cláusula |USE| que la librería |UUAGC| provee. La cláusula |USE|, que se utiliza sólo en atributos
sintetizados, calcula su atributo sintetizado aplicando una función a todas las producciones que tienen más 
de dos campos. Si la producción tiene menos de 2 campos, entonces el atributo sintetizado es
un valor por defecto.

Por ejemplo, para el caso del |FSBoxes| se puede aplicar la cláusula |USE| sobre la producción |Cons| 
con la función |+|, y para la producción |Nil| se utiliza el valor por defecto |0|. El \pref{lac:len1}
muestra la nueva versión.

\begin{ag}
\small
\begin{code}
ATTR FSBox FSBoxes [ ^^ | ^^ | len USE {+} {0} : Int ]
SEM FSBox
    | FSBox     loc.len =   if @boxes.len == 0
                            then widthBox + xSep
                            else @boxes.len
                lhs.len = @loc.len
\end{code}
\caption{Calcular el ancho de un |FSBox| y |FSBoxes|, versión 2} \label{lac:len1}
\end{ag}

\subsection{Generando la posición `x'}

En la \pref{img:xpos0} se muestra que la asignación de la posición `x', al igual que para `y', tiene una
posición de inicio. También se puede ver que cada |FSBox| debe estar ubicado en el centro del ancho
que ocupa el mismo |FSBox|.

Para su implementación se utiliza un atributo heredado |xPos| sobre |FSBox| y |FSBoxes|. El \pref{lac:xpos0}
muestra la especificación para calcular la posición `x'. El atributo |xPos| para los nodos hijos (|boxes|) de
un |FSBox| se inicia en el mismo valor de |xPos| heredado. Se utiliza una variable local |xPos| para guardar
la posición `x' del |FSBox|.

Para el caso del |FSBoxes|, |xPos| se incrementa con el ancho (|len|) de cada |FSBox|.

\begin{figure}
\begin{center}
    \scalebox{0.5}{\includegraphics{089-figura-figura033.jpg}} 
\end{center}
\caption{Posición `x' para |FSBox|} \label{img:xpos0}
\end{figure}

\begin{hs}
\small
\begin{code}
widthBox    = 95
heightBox   = 50
\end{code}
\caption{Dimensión para |FSBox|} \label{lhc:dim0}
\end{hs}


\begin{ag}
\small
\begin{code}
ATTR FSBox FSBoxes [ xPos:Int | ^^ | ^^ ]

SEM FSRoot
    | FSRoot fsbox.xPos = 10

SEM FSBox
    | FSBox  boxes.xPos  = @lhs.xPos
             loc.xPos    = @lhs.xPos + (@loc.len `div` 2) + (xSep `div` 2) - (widthBox `div` 2)

SEM FSBoxes
    | Cons  hd.xPos      = @lhs.xPos
            tl.xPos      = @lhs.xPos + @hd.len
\end{code}
\caption{Especificación para calcular la posición `x'} \label{lac:xpos0}
\end{ag}

El movimiento de atributos es similar a los anteriores, pero conviene ver la \pref{img:xpos1} la cual muestra
el movimiento de atributos para |FSBoxes|. Lo nuevo es que se utiliza un atributo sintetizado para
calcular el valor del atributo heredado.

\begin{figure}
\begin{center}
    \scalebox{0.5}{\includegraphics{090-figura-figura034.jpg}} 
\end{center}
\caption{Movimiento del atributo |xPos| para |FSBoxes|} \label{img:xpos1}
\end{figure}

\subsection{Generando puntos para las líneas}

En la \pref{img:line0} se puede ver que se necesita que cada |FSBox| genere dos puntos para conectar las líneas.
Cada punto debe estar en el centro de la parte superior e inferior de cada |FSBox|.

En el \pref{lac:line0} se muestra la especificación que genera los dos puntos para un |FSBox|. Se ha definido
un atributo sintetizado |pt1| en |FSBox| de tipo |(Int,Int)|, también se ha definido una variable local |pt2|
para guardar el segundo punto.

Así mismo se ha definido un atributo sintetizado |pt1| en |FSBoxes| de tipo |[(Int,Int)]| que almacena la lista
de puntos de todos los nodos hijos.

Para calcular el centro se utiliza las dimensiones definidas en \pref{lhc:dim0}.

\begin{figure}
\begin{center}
    \scalebox{0.5}{\includegraphics{091-figura-figura034.jpg}} 
\end{center}
\caption{Puntos para las líneas de un |FSBox|} \label{img:line0}
\end{figure}

\begin{ag}
\small
\begin{code}
ATTR FSBox [ ^^ | ^^ | pt1:{(Int,Int)} ]
SEM FSBox
    | FSBox  lhs.pt1  = (@loc.xPos + (widthBox `div` 2),@loc.yPos)
             loc.pt2  = (@loc.xPos + (widthBox `div` 2),@loc.yPos + heightBox)

ATTR FSBoxes [ ^^ | ^^ | pt1 USE {:} {[]} : {[(Int,Int)]}]
\end{code}
\caption{Especificación para calcular los puntos extremos de cada línea} \label{lac:line0}
\end{ag}

\subsection{Generando información para renderizar}

Ahora que se ha calculado toda la información para renderizar, se procederá a generar el resultado final.\\

El resultado final será una lista de objetos renderizables. Se ha definido el tipo de dato resultado |Object|
en el \pref{lac:obj0} el cual esta compuesto de un constructor |OBox| que tiene nombre, posición y dimensión,
y también se tiene un constructor |OLine| que tiene |pt1| y |pt2|.

\begin{ag}
\small
\begin{code}
DATA Object
    |  OBox  name        : String 
             position    : {(Int,Int)}
             dimension   : {(Int,Int)}
    |  OLine     pt1  : {(Int,Int)}
                 pt2  : {(Int, Int)}
\end{code}
\caption{Definición del tipo de dato para el resultado final} \label{lac:obj0}
\end{ag}


En el \pref{lac:obj1} se muestra la especificación para obtener el resultado final. Se ha utilizado
un atributo sintetizado |out| de tipo |[Object]| sobre |FSRoot|, |FSBox| y |FSBoxes| para recolectar
todo el resultado. 

Se ha utilizado la cláusula |USE| sobre |FSBoxes| con la función |++| (concatenar) y una lista vacía
como valor por defecto.

No se ha especificado nada para |FSRoot| porque la librería |UUAGC| deriva el valor para su atributo 
sintetizado utilizando una copia directa del atributo sintetizado de |FSBox|.
Sin embargo, sólo se ha especificado la semántica para |FSBox|. Lo primero que se hace es generar
la lista de líneas |cmdVec|. Luego se genera el |OBox| con la información necesaria: nombre, posición
y dimensión (son valores constantes definidos en \pref{lhc:dim0}). Finalmente se concatena todos los
objetos generados.

\begin{ag}
\small
\begin{code}
ATTR FSRoot FSBox FSBoxes [ ^^ | ^^ | out USE {++} {[]}: {[Object]}]

SEM FSBox
    |  FSBox lhs.out =  let  cmdVec  = map (OLine @loc.pt2) ^^ @boxes.pt1
                             box     = OBox   ^^    @name  
                                                    (@loc.xPos,@loc.yPos) 
                                                    (widthBox,heightBox) 
                        in ( box : @boxes.out) ++ cmdVec
\end{code}
\caption{Especificación de la semántica para el resultado final} \label{lac:obj1}
\end{ag}

Finalmente, en la \pref{img:obj2} se muestra el movimiento del atributo |out| para |FSBox|.

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{092-figura-figura035.jpg}} 
\end{center}
\caption{Movimiento del atributo |out| para |FSBox|} \label{img:obj2}
\end{figure}

\section{Generación de código Haskell desde UUAGC} \label{sec:genhaskell}

Una vez que los atributos y semánticas han sido descritos en un archivo con extensión `ag', se utiliza
la herramienta UUAGC para generar código Haskell.\\

UUAGC permite, entre otras cosas, generar los tipos de datos (opción \verb?data?), las funciones semánticas
(opción \verb?semfuns?), los tipos de las funciones semánticas (opción \verb?catas?), y la cabecera del módulo
para el código generado (opción \verb?module?).

Cada una de estas opciones puede generarse de manera independiente y en archivos diferentes o también todas
las opciones en una sola y en un sólo archivo.\\

Por ejemplo, para generar los atributos y semánticas de este apéndice, se puede escribir lo siguiente
(suponga que la descripción se encuentra en el archivo |fsbox.ag|):

\begin{verbatim}
uuagc --data --semfuns --catas --module fsbox.ag
\end{verbatim}
