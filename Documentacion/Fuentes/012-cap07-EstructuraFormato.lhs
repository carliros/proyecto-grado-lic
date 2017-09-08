
%include uuagc.fmt

\chapter{Estructura de Formato} \label{chp:eformato}

%\section{Introducción}

%if showChanges
\color{blue}
%endif

Cada elemento de la estructura Rosadelfa/NTree, dependiendo de la propiedad |display| de CSS, genera un |box| 
para que sea renderizado.

Luego, el |box| generado debe ser acomodado de acuerdo al posicionamiento estático de CSS.
Una vez acomodado, se debe calcular la posición y dimensión correspondiente para cada |box|, de manera 
que se pueda usar esa información para su renderización.\\

El cálculo de la dimensión de cada |box| es una tarea definida en la especificación de CSS.
Esta tarea depende de varias propiedades de CSS, entre ellas: \textit{line-height}, \textit{vertical-align},
\textit{width} y \textit{height}.
\newline
De la misma manera, el cálculo de la posición para cada |box| depende de un contexto de formato, el cual
esta definido en el posicionamiento estático de CSS. Básicamente, antes de calcular las posiciones se
deben formar bloques que contengan líneas de |boxes|.\\

En este capítulo se ha denominado |Estructura de Formato (Formatting Structure [FSTree])| a los |boxes|
generados. El cálculo de la posición y dimensión se ha dividido en dos fases, de manera que también se tiene dos 
estructuras de formato: |FSTreeFase1| y |FSTreeFase2|.
\newline
En las siguientes secciones se inicia describiendo los tipos de datos
para las dos fases de la estructura de formato.
Luego se describe la generación de la estructura de formato desde la estructura NTree y finalmente
se describe cada fase de la estructura de formato.\\

En este capítulo se utilizará la herramienta |UUAGC|\cite{uuagclib} para describir los atributos y semánticas.
También se utilizará la librería \wxhaskell para la parte de generación de ventanas.

%if showChanges
\color{black}
%endif


\section{Tipos de datos}

%\subsection{NTree}
%
%En el \pref{lst:ntree} se muestra la definición del tipo de dato para la estructura Rosadelfa 
%|NTree|.\\
%
%Se tiene 2 tipos de nodos: uno que es etiqueta (|NTag|) y otro que es texto (|NText|).
%El nodo texto solo guarda el texto que contiene, pero el nodo etiqueta guarda el nombre
%de la etiqueta, el tipo del etiqueta (sí es |replaced|) y los atributos de la etiqueta.
%
%\begin{listing}
%\begin{code}
%DATA NTree
%    |   NTree Node ntrees: NTrees
%
%TYPE NTrees = [NTree]
%
%DATA Node
%    |   NTag    name        : String
%                replaced    : Bool
%                atribs      : {Map.Map String String}
%    |   NText   text        : String
%\end{code}
%\caption{Tipo de dato para la estructura Rosadelfa |NTree| en |uuagc|} \label{lst:ntree}
%\end{listing}

En el \pref{lac:datantree} del \pref{chp:pselector} se muestra los tipos de datos para la 
estructura |NTree|. A continuación, sólo se mostrará los tipos de datos para la estructura de
formato.

\subsection{FSTreeFase1}
Los tipos de datos para la estructura de formato de fase~1 son similares
a los del |NTree|. Básicamente porque ambos guardan la misma información.\\

La nueva estructura |BoxTree| descrita en el \pref{lac:fstreefase1}, ya no tiene nodos, 
pero guarda la información del nodo directamente en el árbol.\\ 

Se tiene dos tipos de |BoxTree| en la nueva estructura. Para representar el texto 
se tiene a |BoxText|, el cual guarda un nombre, la lista de propiedades, la lista de atributos
y el texto. Se utiliza este tipo no sólo para representar los nodos de texto de un |NTree|,
sino también para representar los nodos etiquetas que sólo contienen texto, es por eso que se tiene una
lista de propiedades y atributos.\\

Para representar los nodos etiquetas  se tiene a |BoxContainer|, el cual guarda el nombre de la etiqueta,
el contexto del contenedor, la lista de propiedades, el tipo del contenedor, la lista de
atributos y los hijos del contenedor.

\begin{ag}
\small
\begin{code}
DATA BoxTree
    |   BoxContainer    name    :  String
                        fcnxt   :  {FormattingContext} 
                        props   :  {Map.Map String Property}
                        bRepl   :  Bool
                        attrs   :  {Map.Map String String}
                        boxes   :  Boxes
    |   BoxText     name    :  String
                    props   :  {Map.Map String Property}
                    attrs   :  {Map.Map String String}
                    text    :  String

TYPE Boxes = [BoxTree]
\end{code}
\caption{Tipo de dato para el |FSTreeFase1|} \label{lac:fstreefase1}
\end{ag}

La información que se guarda en este tipo es casi la misma que en los del |NTree|, con
la excepción del formato de contexto del contenedor, descrita en el \pref{lhc:fcontext}.

\begin{hs}
\small
\begin{code}
data FormattingContext
    =   InlineContext   |   BlockContext    |   NoContext
        deriving Show
\end{code}
\caption{Tipo de dato para representar el contexto de formato} \label{lhc:fcontext}
\end{hs}

\subsection{FSTreeFase2}

La nueva estructura para fase~2 descrita en el \pref{lac:fstreefase2}, tiene grandes cambios con respecto a 
la de fase~1.
En fase~1 se manejaba una lista de |boxes| como hijos de un contenedor, pero en fase~2 se tiene 
o bloques de ventanas que se acomodan uno debajo del otro o líneas de ventanas
que se acomodan una seguida de la otra. El tipo de dato |Element| del \pref{lac:dataelement} muestra
este comportamiento.

\begin{ag}
\small
\begin{code}
DATA Element
    |   EWinds    winds   :   WindowTrees
    |   ELines    lines   :   Lines
    |   ENothing

TYPE WindowTrees    =   [WindowTree]
TYPE Lines          =   [Line]

DATA Line
    |   Line winds  :   WindowTrees
\end{code}
\caption{Tipo de dato Element} \label{lac:dataelement}
\end{ag}

Además, un |BoxTree| puede ser dividido en varias partes para ser renderizado en 
varias líneas. Así, para representar a que parte pertenece una ventana, 
se utiliza el tipo de dato |TypeContinuation| del \pref{lhc:typecontinuation}.

\begin{hs}
\small
\begin{code}
data TypeContinuation 
    = Full  | Init  | Medium | End
        deriving (Show, Eq)
\end{code}
\caption{Tipo de dato |TypeContinuation|} \label{lhc:typecontinuation}
\end{hs}

\begin{ag}
\small
\begin{code}
DATA WindowTree
    |   WindowContainer     name    :   String
                            fcnxt   :   {FormattingContext}
                            props   :   {Map.Map String Property}
                            attrs   :   {Map.Map String String}
                            tCont   :   {TypeContinuation}
                            bRepl   :   Bool
                            elem    :   Element
    |   WindowText  name    :   String
                    props   :   {Map.Map String Property}
                    attrs   :   {Map.Map String String}
                    tCont   :   {TypeContinuation}
                    text    :   String
\end{code}
\caption{Tipo de dato para el |FSTreeFase2|} \label{lac:fstreefase2}
\end{ag}


\section{Generar resultado para Fase 1} \label{sec:genFSTree}
Una vez que se procesa las hojas de estilo y se asigna valores a |specifiedValue| y 
\newline
|computedValue|
en el |NTree|, se debe proceder con la fase~1. Para esto, se debe generar una estructura |FSTreeFase1|
desde el |NTree|.

\subsection{Generar un \textit{BoxText}}

Lo más sencillo es generar un |BoxText| desde un |NText|. Se recibe la lista de propiedades y 
el contenido y se construye el |BoxText| con una lista vacía de atributos:

\begin{hs}
\small
\begin{code}
genTextBox props str
    =   Just $ BoxText "text" props Map.empty str
\end{code}
\end{hs}

\subsection{Generar un \textit{ReplacedBox}}

Si se tiene un nodo que es |replaced|, se genera un |BoxContainer| que no tiene contexto, ni tampoco  hijos,
porque el contenido de este elemento es externo:

\begin{hs}
\small
\begin{code}
genReplacedBox nm attrs props
    = Just $ BoxContainer nm NoContext props True attrs []
\end{code}
\end{hs}

\subsection{Generar un \textit{InlineBox}}

Para el caso de generar un |InlineBox| se debe realizar 2 comprobaciones:

\begin{itemize}
    \item Que ninguno de sus hijos tenga |display = "block"|. Esto porque no se está dando soporte
          al manejo de bloques en elementos |inline|, es más no se esta dando soporte a \textit{display = ``inline-block''}.

          Para verificar este valor, se ha creado la función |isThereBlockDisplay|, que verifica si algún 
          elemento tiene |display = "block"|:

\begin{hs}
\small
\begin{code}
isThereBlockDisplay bx
    =   case bx of
            BoxContainer    _   _   props   _   _   _   ->  verifyProperty "display" "block" props
            BoxText         _       props   _   _       ->  verifyProperty "display" "block" props
\end{code}
\end{hs}

    \item También se debe comprobar si el hijo del contenedor es simplemente texto, si es así, 
    se puede crear un |BoxText| extrayendo el contenido del texto.
\end{itemize}

Con estas consideraciones, se muestra la implementación para crear un |inlineBox|:

\begin{hs}
\small
\begin{code}
genInlineBox nm attrs props boxes
    =   case boxes of
            [BoxText "text" _ _ str]
                ->  mkBoxText str
            otherwise
                ->  if any isThereBlockDisplay boxes
                    then    error $ "Unsupported feature: inline block at node:" ++ nm
                    else    mkBoxContainer InlineContext
    where   mkBoxContainer context
                = Just $ BoxContainer nm context props False attrs boxes
            mkBoxText str
                = Just $ BoxText nm props attrs str
\end{code}
\end{hs}

Vea que en la implementación de la función |genInlineBox|, se consideró las 2 comprobaciones.

\subsection{Generar un \textit{BlockBox}}

Para el caso del |BlockBox| el contexto puede ser |InlineContext| o |BlockContext|. Para que sea |InlineContext|
todos los hijos deben tener |display = "inline"| y de la misma forma, para que sea |BlockContext| todos los hijos
deben tener |display = "block"|.\\

Muchas veces, no todos los hijos del contenedor tienen |display = "block"|, en esos casos se debe agrupar
todos los elementos que son |inline| e insertarlos como hijos en un nuevo contenedor |block|.

Se utiliza la función |funGroupCompare| para agrupar todos los elementos |inline|:

\begin{hs}
\small
\begin{code}
funGroupCompare = (&&) `on` (\bx -> verifyProperty "display" "inline" (getProps bx))
    where   getProps bx     =   case bx of
                                    BoxContainer    _   _   props   _   _   _   -> props
                                    BoxText         _       props   _   _       -> props
\end{code}
\end{hs}

Y se utiliza la función |toBoxContainer| para convertirlos en bloques:

\begin{hs}
\small
\begin{code}
toBoxContainer broot sprops replaced lst@(bx:bxs) 
    =   case bx of
            BoxContainer nm _ props _ _ _ 
                ->  if verifyProperty "display" "block" props   then     bx
                    else     BoxContainer   (nm ++ "???") InlineContext 
                                            (doInheritance broot propiedadesCSS sprops replaced) 
                                            ...
            BoxText nm props _ _
                ->  if verifyProperty "display" "block" props   then bx
                    else BoxContainer   ...
\end{code}
\end{hs}

La función |doInheritance| se encarga de generar una nueva lista de propiedades para el nuevo
contenedor. La forma de generar las propiedades es obteniendo las propiedades heredables
del contenedor donde se encuentra.

\begin{hs}
\small
\begin{code}
doInheritance broot listProps fatherProps replaced
    =   let  lprops      =  map   (\p ->  (   getPropertyName p
                                          ,   applyInheritance broot fatherProps p
                                          )
                                  ) listProps
             inhProps    =  Map.fromList lprops
             blockProps  =  Map.adjust adjustFunction "display" inhProps
        in Map.map (doComputedValue broot fatherProps blockProps replaced False) blockProps
  where  adjustFunction 
            = adjustPropertyValue (\pv -> pv{specifiedValue = KeyValue "block"})
\end{code}
\end{hs}

La función |applyInheritance| es similar a seleccionar un valor para el |specifiedValue| de una
propiedad. Esta función esta definida en el módulo |Property|.\\

Con todo esto, la función |genBlockBox| es de la siguiente manera:

\begin{hs}
\small
\begin{code}
genBlockBox nm attrs props boxes broot
    =   if any isThereBlockDisplay boxes
        then    let     listGrouped         = groupBy funGroupCompare boxes
                        listBoxContainer    = map (toBoxContainer broot props Nothing) listGrouped
                in mkBoxContainer BlockContext listBoxContainer
        else mkBoxContainer InlineContext boxes
    where   mkBoxContainer context children
                = Just $ BoxContainer nm context props False attrs children
            mkBoxText str
                = Just $ BoxText nm props attrs str
\end{code}
\end{hs}


Lo siguiente es crear los |boxes| de acuerdo a la propiedad |display| y el nodo. Si |display = "none"|,
entonces no se genera nada, caso contrario, se va generando los |boxes| de acuerdo al tipo. 
El \pref{lhc:genboxes} describe la función para generar |boxes|.

\begin{hs}
\small
\begin{code}
genBox (NText str) props boxes _
    =   genTextBox props str
genBox (NTag nm replaced attrs) props boxes broot
    =   if replaced     then    genReplacedBox nm attrs props
        else    case computedValue (props `get` "display") of
                        KeyValue "none"     -> Nothing
                        KeyValue "inline"   -> genInlineBox nm attrs props boxes
                        KeyValue "block"    -> genBlockBox nm attrs props boxes broot 
\end{code}
\caption{Generación de Boxes} \label{lhc:genboxes}
\end{hs}

Finalmente, se utiliza UUAGC para llamar a las funciones que se ha definido. Se ha creado el atributo
sintetizado |fstree| para recolectar todos los |boxes| generados:

\begin{ag}
\small
\begin{code}
ATTR NRoot NTree [^^ | ^^ | fstree: {Maybe BoxTree}]
SEM NTree
    | NTree lhs.fstree 
                =  let boxes = catMaybes @ntrees.fstree
                   in genBox @node.self ^^ @loc.computedValueProps boxes ^^ @lhs.iamtheroot

ATTR NTrees [^^ | ^^ | fstree USE {:} {[]}:{[Maybe BoxTree]}]
\end{code}
\end{ag}


\section{Estructura de Formato, Fase 1} \label{sec:fase1}
Ahora que se ha generado el |FSTreeFase1| se comenzará a procesar la estructura de formato
de fase~1.\\

Esta fase se encarga básicamente de construir líneas de |boxes| para todos los contenedores que tengan un
contexto de |InlineContext|. Para generar las líneas se necesita saber las dimensiones de todos los
|boxes|, especialmente del contenedor que tiene el contexto deseado.

Y para conocer las dimensiones de un |box| se necesita avanzar un nivel más en los valores de la
propiedad. Es decir, se necesita obtener el |usedValue| de una propiedad.\\

En esta sección, primeramente se construirá el |usedValue| para todas las propiedades, luego se generará
las líneas y finalmente se generará el tipo de dato |FSTreeFase2| para continuar con el proceso
de formatear la estructura.

\subsection{Construir el |usedValue|}

Para construir el |usedValue| se utiliza la función |doUsedValue| (\pref{sec:modproperty})
definida en el módulo |Property|.

Primero, se debe definir un atributo heredado |iamtheroot| de tipo |Bool| para determinar
quien es el nodo |Root|:

\begin{ag}
\small
\begin{code}
ATTR BoxTree Boxes [ iamtheroot: Bool | ^^ | ^^]
SEM BoxRoot
    |  BoxRoot boxtree.iamtheroot = True

SEM BoxTree
    |  BoxItemContainer     boxes.iamtheroot = False
    |  BoxContainer         boxes.iamtheroot = False
\end{code}
\end{ag}

Segundo, se debe llamar a la función |doUsedValue| y guardar el resultado en la variable local |usedValueProps|.
El \pref{lac:usedValue} describe la forma de calcular el |usedValue|.

\begin{ag}
\small
\begin{code}
SEM BoxTree
    |  BoxContainer 
            loc.usedValueProps 
                =  Map.map   (doUsedValue   ^^   @lhs.iamtheroot
                                                 (toTupleFloat (@lhs.cbSize))
                                                 @lhs.propsFather 
                                                 @props
                                                 @attrs
                                                 @bRepl) ^^ @props
    |  BoxText
            loc.usedValueProps 
                =  Map.map  (doUsedValue  ^^   @lhs.iamtheroot
                                               (toTupleFloat (@lhs.cbSize))
                                               @lhs.propsFather 
                                               @props
                                               @attrs
                                               False) ^^ @props
\end{code}
\caption{Calcular el |usedValue| de una Propiedad} \label{lac:usedValue}
\end{ag}

En el \pref{lac:usedValue} se hace uso del atributo sintetizado |cbSize| que contiene las dimensiones (|Size|) del
contenedor |box|, el cual se recibe desde afuera y es compartido con todo el árbol |FSTreeFase1|:

\begin{ag}
\small
\begin{code}
ATTR BoxRoot BoxTree Boxes [cbSize:{(Int,Int)} | ^^ | ^^ ]
\end{code}
\end{ag}

Finalmente, las propiedades que se obtiene deben ser compartidas con los nodos hijos, para esto se ha
creado el atributo heredado |propsFather|, que es inicializado en el |BoxRoot|:

\begin{ag}
\small
\begin{code}
ATTR BoxTree Boxes [propsFather: {Map.Map String Property} | ^^ | ^^ ]
SEM BoxTree
    |   BoxItemContainer    boxes.propsFather = @loc.usedValueProps
    |   BoxContainer        boxes.propsFather = @loc.usedValueProps

SEM BoxRoot
    |   BoxRoot boxtree.propsFather = Map.empty
\end{code}
\end{ag}


\subsection{Construir líneas} \label{sec:aline}
Otra de las tareas importantes de esta fase es la construcción de líneas de ventanas en contenedores
|block| que tengan un contexto de formato |InlineContext|.\\

La forma de construir líneas es convirtiendo el árbol de |boxes| en una lista de elementos, donde 
cada elemento es atómico (que no se puede dividir y que se debe renderizar como tal), luego se debe aplicar
un algoritmo que acomode los elementos en líneas de un determinado tamaño. Una vez que se tiene las
líneas, se debe volver a convertir cada línea (lista de elementos) a un árbol de ventanas.

Por ejemplo, sí se tiene un elemento párrafo (`|p|') que es |block| y tiene un contexto de |InlineContext|,
así como en el siguiente ejemplo:

\input{049-ejemplo-ejemplo028}

Puede ser representado en forma de árbol:

\begin{figure}[H]
\begin{center}
    \scalebox{0.35}{\includegraphics{064-figura-figura007.png}}
\end{center}
\caption{Representación en forma de árbol} \label{img:arbol1}
\end{figure}

En la \pref{img:arbol1} se muestra que se asigna un código a cada nodo, ese código es importante para volver a construir
el árbol después de convertirlos en líneas.\\

Si se convierte el árbol en una lista de elementos atómicos, la \pref{img:arbol1} cambiaría a:

\begin{figure}[H]
\begin{center}
    \scalebox{0.4}{\includegraphics{065-figura-figura008.png}}
\end{center}
\caption{Lista de elementos atómicos} \label{img:arbol2}
\end{figure}

Ahora, cada nodo ha sido separado en partes atómicas, por ejemplo, en la \pref{img:arbol2},
el elemento |span| ha sido separado en 2 partes y el |texto| ha sido separado en 3 partes.

Además, cada elemento tiene un nuevo código y un valor que identifica la posición del elemento
con respecto al contenedor (esto es el |TypeContinuation|).
También se tiene las dimensiones que ocupará cada elemento atómico en el contenedor.\\


Luego se aplica un algoritmo para acomodar cada elemento en una línea de un tamaño fijo. Por ejemplo, 
sí el tamaño es 30, el ejemplo se vería de la siguiente manera:

\begin{figure}[H]
\begin{center}
    \scalebox{0.3}{\includegraphics{066-figura-figura009.png}}
\end{center}
\caption{Acomodar los elementos en líneas} \label{img:arbol3}
\end{figure}

El algoritmo para acomodar los elementos es relativamente sencillo, simplemente se va construyendo líneas hasta que ya no 
haya más elementos.\\

En el \pref{lhc:linef1} se muestra la definicion de la función |inlineFormatting|, la cual recibe una lista de elementos, el tamaño fijo de la línea 
(|width|), un valor entero que representa la longitud de sangría para la primera línea y el tamaño que ocupa un espacio. 

Si la lista de elementos es vacía, termina el algoritmo, caso contrario, se va construyendo las líneas de manera acumulativa.

\begin{hs}
\small
\begin{code}
inlineFormatting ::  [ElementList] ->  Int ->  Int ->  Int     -> [[ElementList]]
inlineFormatting     []                _       _       _       = []
inlineFormatting     lst               width   indent  space   = doInline width  indent space lst
\end{code}
\caption{Algoritmo para acomodar los elementos en líneas, 1} \label{lhc:linef1}
\end{hs}

La función |doInline| del \pref{lhc:linef1} construye las líneas de manera recursiva llamando a la función |buildLine| 
el cual devuelve una tupla con la línea y la lista de elementos que aún no se ha consumido. El \pref{lhc:linef2}
muestra su implementación.\\

La primera vez que se llama a la función |doInline| del \pref{lhc:linef2} se crea una nueva longitud para la línea restando 
la cantidad de que ocupa la sangría, para emular el comportamiento de la sangría en el contenido de la línea. Una vez que se devuelve una línea, 
el valor de la sangría para todas las siguientes líneas cambia a |0|, porque la sangría sólo se aplica a la primera línea.

\begin{hs}
\small
\begin{code}
doInline w indent s []    = []
doInline w indent s list  =  let  newWidth      = w - indent
                                  (line, rest)  = buildLine list (newWidth + s) 0 s
                             in line: doInline w 0 s rest
\end{code}
\caption{Algoritmo para acomodar los elementos en líneas, 2} \label{lhc:linef2}
\end{hs}

La función |buildLine| del \pref{lhc:linef2} construye una línea de manera acumulativa, recibe la lista de elementos,
la longitud de la línea, una longitud temporal (que inicialmente es cero) y la longitud
que ocupa un espacio. El \pref{lhc:linef3} muestra su implementación.

Si la lista de elementos es vacía, se termina todo con lista vacía, caso contrario se debe verificar sí el primer
elemento de la lista puede acomodarse en la línea actual, si es así se inserta el elemento en la línea
y se vuelve a llamar a |buildLine| con la nueva longitud temporal incrementada; pero, sí no se acomoda, entonces se devuelve
una lista vacía y la lista de elementos sin modificar. 

\begin{hs}
\small
\begin{code}
buildLine [] _ _  _      
    =  ([],[])
buildLine nlst@(e:es) w wt space 
    =  let len = wt + getLength e + space
       in  if len <= w
           then  let (ln,rs) = buildLine es w len space
                 in (e:ln, rs)
           else ([],nlst)
\end{code}
\caption{Algoritmo para acomodar los elementos en líneas, 3} \label{lhc:linef3}
\end{hs}

El algoritmo presentado, puede ingresar en un bucle recursivo si el tamaño de la línea no es suficiente para un
elemento. En el código del proyecto se ha modificado el algoritmo haciendo una 
verificación de este caso antes de llamar a la función |inlineFormatting|. De manera que, si alguno de los elementos
es más largo que la longitud de la línea, entonces se modifica la longitud de la línea para abarcar 
al elemento más largo.

Otra modificación al algoritmo es el de tener elementos que obliguen a hacer el rompimiento de línea. Cuando 
ocurra este tipo de elementos en la lista, simplemente se debe terminar la construcción de la línea y comenzar
a construir una nueva línea. 

Estos elementos son necesarios para dar soporte a elementos como el |br| o a la propiedad |whitespace| de CSS.\\

Finalmente, se debe volver a reconstruir el árbol, pero en vez de reconstruir el mismo árbol (|Fase1|) se debe 
reconstruirlo directamente para |Fase2|.\\

Para reconstruir el árbol se utiliza los códigos que se había puesto antes de dividirlos en partes. 
A continuación se muestra la siguiente figura que ejemplifica la reconstrucción para fase 2 del
ejemplo de la \pref{img:arbol3}:

\begin{figure}[H]
\begin{center}
    \scalebox{0.4}{\includegraphics{067-figura-figura010.png}}
\end{center}
\caption{Ejemplo de reconstrucción del árbol para fase 2} \label{img:arbol4}
\end{figure}


Para terminar, se muestra la parte del código con UUAGC el cual hace el trabajó de llamar a la función |applyWrap|. 

La función |applyWrap| llama a la función |inlineFormatting| la cual esta definido en el \pref{lhc:linef1}.

\begin{ag}
\small
\begin{code}
SEM BoxTree
    |  BoxContainer loc.lines 
         =  let indent = toInt $ unPixelUsedValue $ ^^ @loc.usedValueProps `get` "text-indent"
            in applyWrap ^^ @loc.width indent 6 ^^ @boxes.elements
\end{code}
\caption{Aplicar el algoritmo para acomodar los elementos en líneas} \label{lac:wrapline}
\end{ag}

Esta función se aplica en cada |BoxContainer| del árbol. Se podría solamente aplicar en los elementos
que son |block| con |InlineContext| pero se deja el trabajó al lenguaje con evaluación perezosa, el cual se
encarga de evaluar sólo lo que es necesario.

\subsection{Generar resultado para Fase 2}
Finalmente, como la última tarea de |Fase1|, se debe generar un resultado para continuar con la |Fase2|.\\

Para esta parte se debe hacer una generación que dependa del valor de la propiedad |display| y del contexto de 
un contenedor. Por ejemplo, sí se tiene un elemento que es |block| que tiene |InlineContext|, se debe generar 
un contenedor que tenga como hijos a las líneas que se ha construido en la anterior sub-sección. Pero si se tiene
un contexto |BlockContext| sus hijos serán una lista de ventanas y no de líneas.\\

Se crea el atributo sintetizado |boxtree| que inspecciona la propiedad |display| y el contexto del 
contenedor. Y sí es |block| e |InlineContext| se usa las líneas (variable local |loc.lines|), 
pero sí es |BlockContext| se usa las ventanas (atributo sintetizado |boxes.boxtree|).
El \pref{lac:genfase2} muestra la implementación para esta parte.

\begin{ag}
\small
\begin{code}
ATTR BoxRoot BoxTree [ ^^ | ^^ | boxtree: {WindowTree} ]
SEM BoxTree
    |  BoxContainer lhs.boxtree 
         =  case computedValue (@loc.usedValueProps `get` "display") of
                    KeyValue "block"
                        ->  case ^^ @fcnxt of
                                InlineContext  -> WindowContainer  ^^  @name  
                                                                       InlineContext 
                                                                       @loc.usedValueProps 
                                                                       @attrs Full
                                                                       @bRepl 
                                                                       (ELines ^^ @loc.lines)
                                otherwise      -> WindowContainer  ^^  @name 
                                                                       @fcnxt 
                                                                       @loc.usedValueProps 
                                                                       @attrs Full 
                                                                       @bRepl 
                                                                       (EWinds ^^ @boxes.boxtree)
                    KeyValue "inline"
                        ->  case ^^ @fcnxt of
                                InlineContext  -> WindowContainer   ^^  @name 
                                                                        InlineContext 
                                                                        @loc.usedValueProps 
                                                                        @attrs Full 
                                                                        @bRepl 
                                                                        (EWinds ^^ @boxes.boxtree)
                                otherwise      -> error $ " error ..." 
    |  BoxText lhs.boxtree 
         = WindowText ^^ @name ^^ @loc.usedValueProps ^^ @attrs Full ^^ @text
\end{code}
\caption{Generar resultado para Fase 2} \label{lac:genfase2}
\end{ag}

\section{Estructura de Formato, Fase 2} \label{sec:fase2}

La tarea para formatear la estructura de fase 2 es generar una ventana renderizable que tenga
dimensiones y posiciones de acuerdo al contexto del contenedor.\\

Se inicia esta sección generando las dimensiones para cada ventana, luego se asigna posiciones
y finalmente se genera las ventanas renderizables.

\subsection{Generar dimensiones para cada ventana}

En esta sección se procederá a calcular el ancho (|width|) y alto (|height|) con los que una
ventana se va a renderizar.\\

Se ha definido una lista de consideraciones los cuales guían la implementación para esta parte del proyecto:

\begin{enumerate}
    \item Cada ventana tiene una lista de propiedades de CSS, de las cuales son importantes las propiedades
          |width| y |height|.

          El valor |usedValue| de cada una de estas propiedades puede tener uno de los 2 valores correctos
          (sí existe algún otro tipo de valor, significa que hubo algún error.):
          \begin{itemize}
               \item |KeyValue "auto"|. Significa que el valor debe ser asignado por el Navegador Web.
               \item |PixelNumber px|. Significa que existe una dimensión concreta para la ventana, 
               la cual debe ser utilizada.
          \end{itemize}
    \item Los valores de las propiedades |width| y |height| corresponden a las dimensiones del 
          \newline
          \verb?content-box?
          de un |Box| de CSS y no así a las dimensiones de todo el |box|. Para calcular la dimensión de
          todo el |box| se debe sumar todas las áreas del |box|.

          En el \pref{chp:boxmodel} se describirá más del modelo |Box| de CSS.

    \item Para sumar el ancho (width) de las dimensiones externas (\verb?padding-box?, \verb?border-box? y 
          \verb?margin-box?) con el ancho del \verb?content-box? se debe
          considerar el tipo |TypeContinuation| de cada ventana. Por ejemplo, la siguiente figura, muestra
          un contenedor que tiene 2 líneas:

            \begin{figure}[H]
                \begin{center}
                    \scalebox{0.45}{\includegraphics{068-figura-figura011.png}}
                \end{center}
                \caption{Ejemplo para |TypeContinuation|} \label{img:extypec}
            \end{figure}
          
          El |TypeContinuation| afecta el ancho de un |box|, de manera que:
          
          \begin{itemize}
                \item Si es |Full|, se considera ambos lados del ancho (|width|) de la dimensión externa.
                \item Si es |Init|, sólo se considera el lado izquierdo del ancho de la dimensión externa.
                \item Si es |Medium|, no considera ninguno de los lados del ancho de la dimensión externa.
                \item Si es |End|, sólo considera el lado derecho del ancho de la dimensión externa.
          \end{itemize}

    \item Para obtener el ancho y alto de un |WindowContainer| se debe considerar el tipo del contenedor
          de acuerdo a la propiedad |display|:
          \begin{itemize}
               \item Si el contenedor es |Block|, el ancho del contenedor estará determinado por el valor de la propiedad 
                     |width| que siempre estará en |pixels|.
                     
                     Esto es así porque las propiedades de CSS siempre
                     calculan su valor con respecto al ancho del contenedor donde se encuentra el elemento.\\

                     Entonces, el ancho del contenedor sería simplemente sumar el valor de la propiedad |width|
                     con las dimensiones externas.\\

                     Para el caso de la altura del contenedor, la propiedad |height| puede ser |"auto"| o
                     un valor en |pixels|. Si es un valor en |pixels|, entonces simplemente se suma
                     el valor con las dimensiones externas.

                     Pero sí es |"auto"|, se debe calcular la altura del contenido y sumarlo con las dimensiones 
                     externas. La altura del contenido depende del formato de contexto del contenedor.
                     
                     Por ejemplo, en el \pref{img:block} se tiene un contenedor con |BlockContext| y en la 
                     \pref{img:inline} se tiene un contenedor con |InlineContext|.

                    \begin{figure}[H]
                        \begin{center}
                            \scalebox{0.4}{\includegraphics{069-figura-figura012.png}}
                        \end{center}
                        \caption{Contenedor con |BlockContext|} \label{img:block}
                    \end{figure}

                    \begin{figure}[H]
                        \begin{center}
                            \scalebox{0.4}{\includegraphics{070-figura-figura013.png}}
                        \end{center}
                        \caption{Contenedor con |InlineContext|} \label{img:inline}
                    \end{figure}

                    Entonces, el formato de contexto afecta la altura del contenedor, de manera que:
                     \begin{itemize}
                         \item Si es |BlockContext|, la altura del contenido es la suma de todas las alturas de
                               las |ventanas| contenedor.
                         \item Si es |InlineContext|, la altura del contenido es la suma de todas las alturas
                               de las \textit{líneas} del contenedor.
                     \end{itemize}
                \item Si el contenedor es |Inline|, entonces siempre se calculará las dimensiones, porque los
                      valores de las propiedades |width| y |height| siempre serán |"auto"|.

                      Para calcular las dimensiones del contenedor |inline|, se debe considerar el tipo del
                      contenedor:
                      \begin{itemize}
                           \item Si el elemento es |replaced|\footnote{replaced: El único elemento que se considera como
                                 |replaced| es el etiqueta |img|.}, se debe obtener las dimensiones del contenido
                                 externo y sumarlas con las dimensiones externas.

                                 Para encontrar las dimensiones del contenido, se debe verificar las propiedades |width| y 
                                 |height| del elemento. Si sus valores están en |pixels|, se utiliza
                                 como las dimensiones del contenido, caso contrario, se obtiene las dimensiones del objeto
                                 externo.
                            \item Si el elemento no es |replaced|, entonces se trata de un elemento |inline| que tiene
                                  otros elementos |inline| como hijos.
                                  El ancho (|width|) del contenedor es la sumatoria de todos los anchos (|widths|)
                                  de los elementos hijos.
                                  Y la altura (|height|) del contenedor es la altura máxima de todos los elementos hijos.
                    \end{itemize}
          \end{itemize}
    \item Para obtener el ancho y alto de un |WindowText|, se hace lo mismo que con 
          \newline
          |WindowContainer|, pero
          con las suposiciones de que el formato de contexto siempre es |InlineContext| y que no existen
          elementos |replaced| en |WindowText|.
\end{enumerate}

\subsection{La altura de una línea} \label{sec:altura}

La altura (height) de una línea es calculado con respecto al |fontMetrics| y |logicalMetrics|. Estos valores
son calculados usando algunas propiedades de CSS como: \verb?font-size?, 
\newline
\verb?line-height? y \verb?vertical-align?.\\

El |fontMetrics| es básicamente el \verb?font-size? de un elemento, es decir el área que ocupa un texto. 
Tiene un |fontTop| y |fontBottom|.
El |fontTop| es la distancia desde la línea base del texto hacia arriba. Y el |fontBottom| es la distancia
desde la línea base hacia abajo. 

Por ejemplo, sí se tiene la siguiente entrada:

\begin{desc}
\small
\input{050-ejemplo-ejemplo029}
\caption{Ejemplo simple} \label{desc:esimple}
\end{desc}

Que tiene el siguiente estilo:

\input{051-ejemplo-ejemplo030}

El |fontMetrics| de cada elemento de la \pref{desc:esimple} se muestra en la \pref{img:fontMetrics}.

\begin{figure}[H]
\begin{center}
    \scalebox{0.3}{\includegraphics{071-figura-figura014.png}}
\end{center}
\caption{Métricas para el ejemplo de la \pref{desc:esimple}} \label{img:fontMetrics}
\end{figure}

El |logicalMetrics| corresponde a la altura de una línea. También tiene un |logicalTop| y |logicalBottom|. 
Estas variables son calculadas con respecto al \verb?half-leading?, \verb?fontMetrics? y la propiedad \verb?vertical-align?.\\

El \verb?half-leading? es calculado con respecto a las propiedades \verb?line-height? y \verb?font-size?. 
El \pref{desc:hleading} muestra la ecuación para calcular el \verb?half-leading?, |logicalTop| y |logicalBottom|.

\begin{desc}
\small
\input{052-ejemplo-ejemplo031}
\caption{Ecuaciones para encontrar el \textit{half-leading}, |logicalTop| y |logicalBottom|} \label{desc:hleading}
\end{desc}

Para que el valor del \verb?vertical-align? sea utilizable en la ecuación del \pref{desc:hleading}, se debe convertirlo a un 
número entero:

\begin{itemize}
    \item \verb?baseline?. Se convierte a |0| (cero).
    \item \verb?super?. Se convierte a |+10|. Significa que el elemento se eleva |10px| sobre el |baseline|.
    \item \verb?sub?. Se convierte a |-10|. Significa que el elemento baja |10px| debajo del |baseline|.
    \item \verb?text-top?. Esta propiedad  indica que se debe elevar el elemento hasta que toque la parte
                        máxima (|top|) del texto de la línea. Para esto, se necesita saber la altura (|fontTop|)
                        máxima y restarlo con la altura actual (|fontTop|) del elemento, el resultado de esa resta será
                        la cantidad que se debe elevar el elemento.
    \item \verb?text-bottom?. Al igual que el anterior, el elemento debe ser colocado en la parte más inferior
                           del texto de la línea. Entonces, se resta el máximo |fontBottom| con el |fontBottom| actual
                           del elemento, su resultado será la cantidad que se debe bajar el elemento.
    \item \verb?PixelNumber?. El valor también puede ser un número pixel (positivo o negativo), donde simplemente
                           se eleva o baja la cantidad especificada.
\end{itemize}

Como ejemplo, se procederá a calcular el |logicalTop| y |logicalBottom| para cada elemento del ejemplo de la \pref{desc:esimple}:

\begin{listing}
\input{053-ejemplo-ejemplo032}
\end{listing}

Con el |fontMetrics| y |logicalMetrics| para cada elemento, se puede calcular la |altura| de cada línea.
La altura de una línea es el máximo |logicalMetrics| de la lista de ventanas de una línea. 
Es decir, la altura de una línea, que corresponde al máximo |logicalMetrics|, es la sumatoria del máximo |logicalTop| y máximo 
|logicalBottom|.

El cálculo del valor máximo de |logicalTop| y |logicalBottom| debe hacerse de manera independiente, 
es decir que puede corresponder a diferentes elementos.

\subsection{Generar posiciones para las ventanas}

En esta sección se generará una posición |(x,y)| para cada ventana. Esta posición se utilizará para posicionar a
la ventana con respecto a su contenedor.\\

La asignación de posiciones se realiza de acuerdo al contexto de formato, si el contexto es |inline|, se incrementa la 
variable |x| de la posición con el ancho (|width|) de cada ventana, pero si el contexto es |block|, se incrementa 
la variable |y| de la posición con la altura de cada ventana.

Se ha definido, en el \pref{lac:statePos}, el atributo heredado |statePos| que representa el estado de la posición.
Se debe llevar este atributo a todos los lugares donde se quiera asignar posiciones:

\begin{ag}
\small
\begin{code}
SET WPos = WindowTree Element WindowTrees Lines Line 
ATTR WPos [statePos: {(FormattingContext,(Int,Int))} | ^^ | ^^ ]
\end{code}
\caption{Atributo para el estado de una posición} \label{lac:statePos}
\end{ag}

Inicialmente, el atributo |statePos| no tiene contexto y se inicializa en la posición |(0,0)|:

\begin{ag}
\small
\begin{code}
SEM WindowRoot
    |   WindowRoot windowTree.statePos = (NoContext, (0,0))
\end{code}
\end{ag}

\subsubsection{Posiciones de acuerdo al contexto}
Si se tiene una lista de ventanas, las posiciones para cada ventana se logra sumando las dimensiones correspondientes 
de acuerdo al contexto.\\

Si el contexto es |InlineContext|, se incrementa la variable |x| de la posición con el ancho (|width|) de cada ventana.
Pero sí el contexto es |BlockContext|, entonces se incrementa la variable |y| de la posición con la altura (|height|) 
de cada ventana. En el \pref{lac:semState1} se describe este comportamiento.

\begin{ag}
\small
\begin{code}
SEM WindowTrees
    |   Cons    hd.statePos     =   @lhs.statePos
                tl.statePos     =   case  fst ^^ @lhs.statePos of
                                          InlineContext  ->  let (x,y) = snd ^^ @lhs.statePos
                                                             in (InlineContext, ((fst ^^ @hd.size) + x + 6 , y))
                                          BlockContext   ->  let (x,y) = snd @lhs.statePos
                                                             in (BlockContext , (x, (snd ^^ @hd.size) + y))
\end{code}
\caption{Asignar posiciones de acuerdo al contexto} \label{lac:semState1}
\end{ag}

El atributo sintetizado |@hd.size| del \pref{lac:semState1} es una tupla que guarda las dimensiones de la ventana, 
el primero es el ancho y el segundo es la altura. 
Y el número |6|, es la cantidad que un espacio ocupa en |pixels|.

\subsubsection{Posiciones en una lista de líneas}

Si se tiene una lista de líneas, se debe incrementar la variable |y| de la posición con la altura de cada línea.
El \pref{lac:semState2} muestra esta parte de la implementación.

\begin{ag}
\small
\begin{code}
SEM Lines
    |  Cons  hd.statePos  =  ^^ @lhs.statePos
             tl.statePos  =     let  (x,y)  = snd ^^ @lhs.statePos
                                     newY   = y + ^^ @hd.lineHeight
                                in (fst ^^ @lhs.statePos,(x, newY))
\end{code}
\caption{Asignar posiciones a una lista de líneas} \label{lac:semState2}
\end{ag}

En el \pref{lac:semState2}, |@hd.lineHeight| corresponde a la altura de cada línea, que es
la sumatoria de: |maxLogicalTop| y |maxLogicalBottom|.

\subsubsection{Asignar posiciones a ventanas}

Para guardar la posición de una ventana se ha creado la variable local |position|, que almacena una tupla
que representa las posiciones |(x,y)| de la ventana.\\

Para un |WindowText|, se recibe el atributo heredado |statePos|, del cual sólo se necesita las variables |(x,y)|.
La variable |y| puede ser afectada por la propiedad \verb?vertical-align? de CSS, la cual es aplicada sólo 
a elementos |inline|.

La nueva posición |y| es calculada a través de la ecuación de la \pref{desc:ecy}. La implementación para 
calcular la nueva posición |y| esta descrita en el \pref{lac:calpos1}.

\begin{desc}
\small
\input{054-ejemplo-ejemplo032}
\caption{Formula para calcular la posición |y| en un elemento de texto inline} \label{desc:ecy}
\end{desc}

\begin{ag}
\small
\begin{code}
    |  WindowText
        loc.position 
            =  let  (x,y1)     = snd ^^ @lhs.statePos
                    y2         =  case ^^ @loc.vdisplay of
                                     "inline"   ->  fst ^^ @lhs.maxLogicalMetrics 
                                                    -  (  @loc.verticalAlign 
                                                       +  @loc.fontTop 
                                                       +  (thd4 @loc.extSize)
                                                       )
                                     otherwise  -> 0
               in (x, y1 + y2)
\end{code}
\caption{Asignar posición a un |WindowText|} \label{lac:calpos1}
\end{ag}

Para el caso del |WindowContainer|, se utiliza directamente la posición que se recibe del |statePos|.
Como el contenedor puede tener hijos, se debe generar un nuevo |statePos| para los hijos.

El nuevo |statePos| debe tener el contexto del contenedor y la posición donde se comienza a dibujar 
en el contenedor. La implementación para esta parte se describe en el \pref{lac:calpos2}.

\begin{ag}
\small
\begin{code}
    |  WindowContainer
        loc.position   =  snd ^^ @lhs.statePos
        elem.statePos  =  let pointContent = getTopLeftContentPoint ^^ @tCont ^^ @props
                          in (@fcnxt, pointContent)
\end{code}
\caption{Asignar posición a un |WindowContainer|} \label{lac:calpos2}
\end{ag}

La función |getTopLeftContentPoint| del \pref{lac:calpos2} obtiene la nueva posición donde se comienza a dibujar. 
Esta posición corresponde a la esquina superior izquierda del \verb?content-box? del contenedor.\\

Para terminar esta parte, se presenta las figuras: \pref{img:pos1} y \pref{img:pos2}, que ejemplifican
la asignación de posiciones.

\begin{figure}
    \begin{center}
        \scalebox{0.4}{\includegraphics{072-figura-figura015.png}}
        \scalebox{0.4}{\includegraphics{073-figura-figura016.png}}
    \end{center}
    \caption{Posicionamiento con |BlockContext|} \label{img:pos1}
\end{figure}

\begin{figure}
    \begin{center}
        \scalebox{0.4}{\includegraphics{074-figura-figura017.png}}
        \scalebox{0.4}{\includegraphics{075-figura-figura018.png}}
    \end{center}
    \caption{Posicionamiento con |InlineContext|} \label{img:pos2}
\end{figure}


\subsection{Generar ventanas renderizables} \label{sec:genVenRend}

Finalmente, como resultado de formatear toda la estructura, se debe generar las ventanas renderizables.\\

Cada elemento de |FSTreeFase2| genera una ventana renderizable, es decir un |box|. En el \pref{chp:boxmodel} 
se dará más detalles del |box|. Por ahora sólo se conoce que se dispone de las funciones |boxContainer| y |box|
para la creación de un |box|.
En el \pref{lhc:fbox} se muestra los tipos de las funciones |boxContainer| y |box|.

\begin{hs}
\small
\begin{code}
boxContainer    ::  Window a                    -- ventana padre
                ->  (Int, Int)                  -- posicion
                ->  (Int, Int)                  -- dimencion
                ->  TypeContinuation            
                ->  Map.Map String Property     -- propiedades de CSS
                ->  Map.Map [Char] String       -- atributos
                ->  Bool                        -- replaced
                ->  IO (ScrolledWindow ())

box     ::  String                      -- contenido
        ->  Window a                    -- ventana padre
        ->  (Int, Int)                  -- posicion
        ->  (Int, Int)                  -- dimencion
        ->  TypeContinuation
        ->  Map.Map String Property     -- propiedades de CSS
        ->  Map.Map [Char] String       -- atributos
        ->  Bool                        -- replaced
        ->  IO (ScrolledWindow ())
\end{code}
\caption{Funciones para construir un |box|} \label{lhc:fbox}
\end{hs}

Cada |WindowContainer| genera un |boxContainer| y cada |WindowText| genera un |box|. La ventana padre de ambos |boxes|
es el contenedor padre donde se encuentra el elemento.\\

La idea para generar los |boxes| es generar funciones que esperen una ventana y produzcan acciones de renderización.
Para esto, se ha definido el atributo sintetizado |result|, que tiene el tipo mencionado:

\begin{ag}
\small
\begin{code}
ATTR WindowRoot WindowTree [ ^^ | ^^ | result: {WX.Window a -> IO()}]
\end{code}
\end{ag}

El \pref{lac:genWindow1} describe la forma de generar un |box| para un |WindowText|.

\begin{ag}
\small
\begin{code}
    |  WindowText
        lhs.result = \cb -> do  box ^^  @text cb 
                                        @loc.position 
                                        @loc.size 
                                        @tCont 
                                        @props 
                                        @attrs 
                                        False
                                return ()
\end{code}
\caption{Generar un |box| para |WindowText|} \label{lac:genWindow1}
\end{ag}

En el \pref{lac:genWindow1} se crea una función |lambda| que recibe un `|cb|' (|Container Box|) y devuelve la acción 
para renderizar el |WindowText|.\\

El \pref{lac:genWindow2} describe la forma de generar un |box| para el |WindowContainer|.

\begin{ag}
\small
\begin{code}
    |  WindowContainer 
        lhs.result = \cb -> do  cbox <- boxContainer cb ^^  @loc.position 
                                                            @loc.size 
                                                            @tCont 
                                                            @props 
                                                            @attrs 
                                                            @bRepl
                                mapM_ (\f -> f cbox) ^^ @elem.result
\end{code}
\caption{Generar un |box| para |WindowContainer|} \label{lac:genWindow2}
\end{ag}

En el \pref{lac:genWindow2} el |WindowContainer| es padre de sus hijos, esto significa que se 
debe compartir la ventana creada con todos 
los hijos. Se utiliza la función |mapM_| de Haskell para compartir la ventana creada 
por el contenedor con todos los hijos.\\

También se define el atributo sintetizado |result| para recolectar todas las acciones de la lista
de hijos:

\begin{ag}
\small
\begin{code}
ATTR Element Lines Line [ ^^ | ^^ | result USE {++} {[]} : {[WX.Window a -> IO()]}]
ATTR WindowTrees [ ^^ | ^^ | result USE {:} {[]}: {[WX.Window a -> IO()]}]
\end{code}
\end{ag}

Con todo esto, ya se tiene generado todas las ventanas para su renderización.\\

Finalmente, un detalle que no se ha mostrado hasta ahora, es la generación de eventos de |clic| para un contenedor. 
Los eventos son generados utilizando las funciones de la librería WxHaskell.
Por ejemplo, si se quiere generar un evento de |clic| de un URL, se debe disponer de una 
función que va a procesar el |clic|:

\begin{ag}
\small
\begin{code}
    WX.set cbox [on focus := onClick ^^ @lhs.goToURL url]
\end{code}
\caption{Generación de eventos de |clic|}
\end{ag}

La función que procesa el |clic| es la función |onClick|, que llama a la función |goToURL| (su argumento) 
con el nuevo |url| que se quiere renderizar:

\begin{hs}
\small
\begin{code}
onClick function url bool
    =  if bool
       then function url
       else return ()
\end{code}
\caption{Función |onClick|} \label{lhc:onClick}
\end{hs}



