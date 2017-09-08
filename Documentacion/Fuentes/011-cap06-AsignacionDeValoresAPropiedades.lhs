
%include uuagc.fmt
%format :.: = "\mathbin{\circ}"
%format "~=" = "\ensuremath{\symbol{34}\sim=\symbol{34}}"

\chapter{Asignación de valores a Propiedades de CSS} \label{chp:pselector}

%\section{Introducción}

%if showChanges
\color{blue}
%endif

Hasta esta parte ya se ha trabajado en reconocer la entrada del Navegador Web, lo que ahora se debe 
hacer es procesar la entrada para su renderización. Así, en este capítulo y el siguiente se describirá
el proceso de renderización.\\

La renderización es guiada a través de las propiedades de CSS. Por ejemplo, la propiedad |display| determina
la forma en que se mostrará el elemento o nodo en la pantalla, si su valor es |none|, entonces no se mostrará
nada, pero si su valor es |block|, se mostrará un elemento que se renderice como un bloque en la pantalla.
\newline
De esa manera, las propiedades de CSS toman un rol importante en el proceso de renderización. Pero, para poder
disponer de un valor para una propiedad se debe primeramente asignar un valor a la propiedad.\\

La asignación de un valor a una propiedad, lamentablemente, no es una tarea trivial, más al contrario
es un proceso complejo.
\newline
El caso más sencillo es cuando un autor especifica en las hojas de estilo el valor para una propiedad, 
pero se va complicando cuando
se especifica más de dos veces valores diferentes para la misma propiedad, aún peor es cuando el Navegador Web
tiene sus propios valores por defecto, o cuando el autor especifica un valor para un subconjunto de elementos.
\newline
Todo este proceso de asignar una valor a una propiedad está definido en el algoritmo Cascada \cite[cap.~6]{css21} de la 
especificación de CSS. Básicamente, la especificación dice que una vez que se ha recolectado todas las reglas de estilo de 
la entrada, se debe asignar un valor a cada propiedad a través de un 
emparejamiento entre el nombre del nodo o etiqueta y el selector de la regla de estilo.\\


Por lo tanto, en este capítulo se presentará la secuencia de desarrollo del proceso de asignación de un valor a cada propiedad de CSS.
En las siguientes secciones, primeramente se recolectará u obtendrá todas las hojas de estilo de la entrada, luego 
se procederá con el emparejamiento de selectores y finalmente se construirá la lista de propiedades de CSS a las
cuales se ha asignado un valor.\\

Para especificar la semántica del proceso se hará uso de la herramienta UUAGC \cite{uuagclib}, la cual 
requiere que se reescriban
los tipos de datos del lenguaje de marcado a una sintaxis conocida por UUAGC. Este cambio no afectará los tipos
de datos definidos anteriormente.
En el \pref{lac:datantree} se presenta los tipos de datos del lenguaje de marcado en la sintaxis de UUAGC.

\begin{ag}
\small
\begin{code}
DATA Root
    | Root ntree:NTree

DATA NTree
    | NTree Node ntrees: NTrees

TYPE NTrees = [NTree]

DATA Node
    | NText     text                : String
    | NTag      name                : String
                iamReplacedElement  : Bool
                attributes          : {Map.Map String String}

DERIVING *: Show
\end{code}
\caption{Tipos de datos para el lenguaje de marcado} \label{lac:datantree}
\end{ag}

%if showChanges
\color{black}
%endif


\section{Obtener las Hojas de Estilo}

En esta sección se describirá la forma de obtener todas las hojas de estilo y hacerlas disponibles
para su utilización en cada nodo de la estructura |Rosadelfa| o |NTree|.

\subsection{El tipo |MapSelector|} \label{sec:mapselector}

Las hojas de estilo que se obtienen deben guardarse en alguna estructura o tipo de dato. Para esto, se utiliza la
estructura |Map| de Haskell con el tipo |MapSelector|:

\begin{hs} 
\small
\begin{code}
type MapSelector = Map.Map Selector [(Tipo,Origen,Declaraciones,Int)]
\end{code} 
\end{hs}

La estructura |Map| guarda la información en forma de clave-valor, donde la clave es el |Selector| 
y su valor es una lista de tuplas compuesto de: |Tipo|, |Origen|, |Declaraciones| y especificidad del 
selector (|Int|).\\

En el \pref{apd:map} se muestra la documentación de las funciones más importantes de la librería 
Map de Haskell.

%Las operaciones básicas con la estructura |Map| que se usarán son:
%
%\begin{itemize}
%    \item |Map.empty|: Construye una lista vacía de la estructura |Map|.
%    \item |Map.unionWith (++) map1 map2|: Une 2 estructuras |Map| y utiliza la función |(++)| si existen claves iguales.
%    \item |Map.insertWith (++) clave valor map|: Inserta la |(clave,valor)| en la estructura |map| y si la clave
%         ya existe, entonces utiliza la función |(++)|.
%\end{itemize}

\subsection{Obtener las hojas de estilos} \label{sec:obtenerHEst}

%Las hojas de estilo pueden encontrarse en 3 lugares de una estructura |Rosadelfa o NTree|:
%\begin{enumerate}
%    \item En una etiqueta de estilo, por ejemplo \verb?<style> ... </style>?. En este caso, el
%          contenido de la etiqueta corresponde a las hojas de estilo internas del autor |Author|.
%    \item En una etiqueta \verb?link? de \html. La hoja de estilo es especificada a través de una URL.
%          Estos estilos corresponden a las hojas de estilo externas del autor |Author|.
%%    \item En un etiqueta \verb?xml-stylesheet? de XML. La hoja de estilo es especificada a través 
%%          de una URL. Estos estilos corresponden a las hojas de estilo externas del autor autor.
%    \item En el atributo |style| de una etiqueta o nodo, por ejemplo \verb?<div style="display = inline">?. Estos
%          estilos corresponden a las hojas de estilo de tipo atributo del autor |Author|.
%\end{enumerate}
%
%Además de estas hojas de estilo, el autor que usa el Navegador Web (autor |User|), es capaz de 
%definirse su propia hoja de estilos. De la misma manera, el Navegador Web tiene su propia hoja de
%estilos por defecto bajo el autor |UserAgent|.\\

Las hojas de estilo pueden ser definidas de 3 formas y por 3 usuarios distintos. Esta información
esta descrita en la \pref{sec:mcascada} del Marco Teórico.\\

Para comenzar, en el \pref{lac:tagestilo} se define el atributo heredado |tagEstilo| de 
tipo |Bool| para verificar si una etiqueta tiene nombre ``style'':

\begin{ag}
\small
\begin{code}
ATTR NTree NTrees [ tagEstilo: Bool | ^^ | ^^ ]
SEM NTree
    | NTree ntrees.tagEstilo = case ^^  @nodo.self of
                                        NTag "style" _ _    -> True
                                        otherwise           -> False
\end{code}
\caption{Atributo |tagEstilo|} \label{lac:tagestilo}
\end{ag}

Se ha definido un atributo heredado porque esa información debe ser compartida con todos los nodos hijos
de cada nodo, especialmente con los nodos de texto, porque es de esa manera en que \html guarda la información 
de estilos.

Como se está utilizando un atributo heredado, debe ser inicializado en el nodo |Root|:

\begin{ag}
\small
\begin{code}
SEM NRoot
    | NRoot ntree.tagEstilo = False
\end{code}
\end{ag}

En las siguientes sub-secciones se procederá a obtener las hojas de estilo.

\subsubsection{Obtener la Hoja de estilo interna y externa del autor \textit{Author}}

Para obtener las hojas de estilo interna y externa del usuario |Author| se realiza 
las siguientes verificaciones:
\begin{itemize}
    \item Si es un nodo |NTexto|, se comprueba si su padre es un nodo |NTag| con nombre `style'; 
    \item Sino, se verifica que sea un nodo |NTag| `link' correcto.
\end{itemize}

En el \pref{lac:gethestilo1} se describe la forma de obtener las hojas de estilo para el usuario |Author|.
Se ha definido un atributo sintetizado |reglas| de tipo |MapSelector| para almacenar las hojas de estilo.

\begin{ag}
\small
\begin{code}
ATTR NTree NTrees [ ^^ | ^^ | reglas: {MapSelector}]
SEM NTree
    | NTree lhs.reglas 
                =  let nsel = case ^^ @nodo.self of
                                 NTexto str    ->  if ^^ @lhs.tagEstilo 
                                                   then parseHojaInterna str
                                                   else Map.empty
                                 NTag nm _ at  ->  if nm == "link" && verificarLinkAtributos at
                                                   then  getHojaExterna at
                                                   else Map.empty
                   in Map.unionWith (++) nsel ^^ @ntrees.reglas

{
getHojaExterna atProps =  let  url   = atProps  Map.! "href"
                               path  = getStylePath url
                          in parseHojaExterna path
}
\end{code}
\caption{Obtener las Hojas de estilo} \label{lac:gethestilo1}
\end{ag}

Las declaraciones de un selector son concatenadas con las de sus hijos. Las reglas de los hijos
también son concatenadas en una sola lista. Para esto, se utiliza la función |(++)| y |unionWith| 
de la estructura |Map|:

\begin{ag} 
\small
\begin{code}
SEM NTrees
    | Cons  lhs.reglas = Map.unionWith (++) ^^ @hd.reglas ^^ @tl.reglas
    | Nil   lhs.reglas = Map.empty
\end{code} 
\end{ag}

Para verificar si los valores de los nodos son adecuados, no sólo se verifica su nombre, sino también que se disponga 
de los atributos correctos.
La función |verificarLinkAtributos| del \pref{lhc:testlink} se encarga de verificar la existencia de los atributos 
|href|, |rel| y |type| en el nodo |link|:

\begin{hs} 
\small
\begin{code}
verificarLinkAtributos at = href && rel && tipo
    where  href  = Map.member "href" at
           rel   = maybe False (== "stylesheet")  $ Map.lookup "rel"  at
           tipo  = maybe False (== "text/css")    $ Map.lookup "type" at
\end{code}
\caption{Función para verificar los atributos del elemento `link'} \label{lhc:testlink}
\end{hs}

\subsubsection{Obtener el estilo de los atributos para el usuario Author}

Las hojas de estilo también pueden encontrarse en los atributos de un nodo, para esto se debe buscar 
si existe un atributo |style| en los atributos del nodo, si el atributo no se encuentra, simplemente se 
devuelve una estructura |Map| vacía (|empty|).\\

En el \pref{lac:gethestilo2} se describe la forma de obtener los estilos desde los atributos de un nodo con etiqueta.
Se ha definido la variable local |atributoEstilo| para guardar los estilos de un atributo.

\begin{ag} 
\small
\begin{code}
SEM NTree
    |  NTree loc.atributoEstilo 
        = case ^^ @nodo.self of
            NTag name _ attrs  -> maybe  Map.empty 
                                         (parseEstiloAtributo name) 
                                         (Map.lookup "style" attrs)
            otherwise          -> Map.empty
\end{code} 
\caption{Obtener las Hojas de estilo atributo} \label{lac:gethestilo2}
\end{ag}

En todas las formas para obtener los estilos se ha utilizado las funciones correspondientes 
de la \pref{sec:cssParserInterfaces} del Parser de CSS.

\subsubsection{Hojas de Estilo externas del usuario UserAgent y User}

En el \pref{lst:gethestilo3} se define un atributo heredado para obtener las hojas de estilo del autor |UserAgent| y |User|.

\begin{ag} 
\small
\begin{code}
ATTR NRoot [defaultcss4html: {MapSelector} | ^^ | ^^ ]
ATTR NRoot [usercss4html: {MapSelector} | ^^ | ^^ ]
\end{code} 
\caption{Obtener las Hojas de estilo para el |UserAgent| y |User|} \label{lst:gethestilo3}
\end{ag}


\subsection{Distribución de Hojas de Estilo}
Una vez que se obtienen todas las hojas de estilo, se debe recolectarlas y distribuirlas a cada nodo del |NTree|.
Para esto, primeramente se concatena las reglas del |UserAgent| y |User| con las reglas definidas por |Author| 
y luego son distribuidas con el atributo heredado |css|:

\begin{ag} 
\small
\begin{code}
ATTR NTrees NTree [ css:{MapSelector} | ^^ | ^^ ]
SEM NRoot
    | NRoot ntree.css =  let reglas = Map.unionWith  (++) 
                                                     @lhs.defaultcss4html
                                                     @lhs.usercss4html
                         in Map.unionWith (++) reglas ^^ @ntree.reglas
\end{code} 
\end{ag}

\subsection{Variable local \textit{misHojasEstilo}}

Finalmente, se ha definido la variable local |misHojasEstilo| en cada nodo del |NTree|. Esta variable contiene
las hojas de estilo atributo del nodo y las hojas de estilo de todo el |NTree|:

\begin{ag} 
\small
\begin{code}
SEM NTree
    | NTree loc.misHojasEstilo = Map.unionWith  (++) 
                                                @loc.atributoEstilo 
                                                @lhs.css
\end{code}
\caption{La variable local |misHojasEstilo|}
\end{ag}

\section{Emparejando Selectores}
Una vez que se tiene todas las hojas de estilo en cada nodo, se debe comenzar con el proceso de asignación de
un valor a cada propiedad.

Este proceso inicia con el emparejamiento de selectores, que se encarga de comprobar si una regla de estilo se
puede aplicar a un nodo o etiqueta. Esta comprobación es realizada a través de un emparejamiento entre el selector
y la etiqueta.\\

En esta sección se describirá el proceso de emparejamiento de selectores.

\subsection{Funciones básicas para el emparejamiento}

\subsubsection{Emparejando Atributos}

Se inicia definiendo una función que recibe 3 valores de tipo |String|, de los cuales 2 de ellos son valores
y el último es un operador. Esta función hace la comparación y devuelve un valor |Bool|:

\begin{hs} 
\small
\begin{code}
funOp :: String -> String -> String -> Bool
funOp val1 op val2
    = case  op of
            "="   -> val1 == val2
            "~="  -> any (== val1) $ words val2
\end{code}
\caption{Función de comparación para atributos} \label{lhc:funop}
\end{hs}

La función definida en el \pref{lhc:funop} es usada para comparar los atributos de los selectores con los de HTML.
Si el operador es `$=$', ambos valores deben ser iguales. Si el operador es `$\sim=$', el primer
valor debe pertenecer a alguna palabra de la lista de palabras separadas por espacios del segundo valor.\\


También se define, en el \pref{lhc:funattr1}, una función para testear o verificar los atributos de CSS y HTML, la cual
utiliza la función |funOp| del \pref{lhc:funop}. Se recibe una lista de 
atributos de \html, un atributo \acss\ y se devuelve un valor |Bool|, que significa si el atributo \acss\
empareja la lista de atributos de \html.

La implementación trabaja en base al atributo de CSS, por ejemplo, si se recibe un |AtribNombre|, 
simplemente se verifica su existencia en la lista de atributos de \html. 
Pero, si se trata de un atributo |AtribTipoOp| o |AtribID|, entonces
primeramente se obtiene el atributo que se quiere de la lista de atributos de \html,
si el atributo no se encuentra, se devuelve directamente el valor |False|, 
pero si se encuentra, se llama a la función |funOp| del \pref{lhc:funop}.

\begin{hs} 
\small
\begin{code}
testAttribute :: Map.Map String String -> Atributo -> Bool
testAttribute htmlAttrs at
    = case  at of
            AtribID value
                -> maybe False (funOp value "~=")  (Map.lookup "id" htmlAttrs)
            AtribNombre name
                -> Map.member name htmlAttrs
            AtribTipoOp name op value
                -> maybe False (funOp value op)    (Map.lookup name htmlAttrs)
\end{code} 
\caption{Función para testear un atributo} \label{lhc:funattr1}
\end{hs}

Para terminar esta parte, si se quiere testear una lista de atributos, simplemente se utiliza la función
|all| del preludio de |Haskell| con la función |testAtribute| y la lista de atributos de \acss:

\begin{hs} 
\small
\begin{code}
testAttributes :: Map.Map String String -> Atributos -> Bool
testAttributes htmlAttrs = all (testAttribute htmlAttrs)
\end{code}
\caption{Función para testear varios atributos} \label{lhc:funattr2}
\end{hs}


\subsubsection{Emparejando Pseudo elementos}

Lo siguiente es verificar un pseudo elemento. Para esto se recibe un valor |Bool| y el pseudo elemento. 
Si el valor |Bool| es verdadero, entonces se debe verificar que exista un pseudo elemento, caso contrario
se debe verificar su no existencia:

\begin{hs} 
\small
\begin{code}
testPseudo :: Bool -> Maybe PseudoElemento -> Bool
testPseudo bool pse = if bool then isJust pse else isNothing pse
\end{code} 
\caption{Función para testear pseudo-elementos} \label{lhc:funpseudo1}
\end{hs}

\subsection{Emparejar un Selector Simple}

Con las funciones definidas hasta ahora es posible implementar una función que
verifique o compruebe un selector simple.

En el \pref{lhc:funsel1} se define la función |testSimpleSelector|, que recibe el selector simple, 
el nodo con el que se quiere verificar y un valor |Bool| que indica si se debe verificar el pseudo elemento. 
Y se devuelve un valor |Bool| para indicar si se emparejo el selector simple y el nodo.\\

Los selectores sólo se aplican a los nodos con etiquetas (|NTag|), no así a los nodos de texto. Entonces, si el nodo es 
diferente a un |NTag|, directamente se devuelve |False|. 
\newline
Caso contrario, se 
trabaja de acuerdo al selector, si el selector es universal (|UnivSelector|) se verifica sus atributos y el pseudo elemento, 
pero si es un tipo selector (|TypeSelector|) además de lo anterior, se verifica su nombre.

\begin{hs} 
\small
\begin{code}
testSimpleSelector :: SSelector -> Nodo -> Bool -> Bool
testSimpleSelector ssel nd bool
    = case  nd of
            NTag nm1 _ attrs  -> case  ssel of
                                       TypeSelector nm2 atsel pse
                                             ->      (nm1 == nm2) 
                                                 &&  testAttributes attrs atsel 
                                                 &&  testPseudo bool pse
                                       UnivSelector atsel pse
                                             ->      testAttributes attrs atsel 
                                                 &&  testPseudo bool pse
            otherwise         -> False
\end{code} 
\caption{Función para verificar un Selector Simple} \label{lhc:funsel1}
\end{hs}


\subsection{Emparejar Selectores compuestos}

A continuación se describirán las funciones de emparejamiento para cada uno de los tipos 
del selector compuesto.

\subsubsection{La función matchSelector}

La función |matchSelector| definida en el \pref{lhc:matchselector} es una función que empareja de acuerdo 
al tipo de selector. Esta función consume elemento por elemento la lista de |ESelector|.

Si |Selector| es una lista vacía, entonces se devuelve el valor |True|, que significa que el selector tuvo éxito 
en emparejar el nodo.
Caso contrario, se continua llamando a la función correspondiente para emparejar el primer elemento de la lista.

\begin{hs} 
\small
\begin{code}
type TypeMatchSelector 
    = Nodo ->  [(Nodo,[Nodo])] ->  [Nodo] ->  [(Nodo,[Nodo])] ->  Int ->  Selector ->    Bool ->  Bool
matchSelector ::  TypeMatchSelector
matchSelector _ _ _ _ _ [] _
    = True
matchSelector nd fathers siblings before level (sel:nextSel) pseudo
    =  case sel of
            SimpSelector s 
                -> applySimplSelector nd fathers siblings before level s nextSel pseudo
            DescSelector s 
                -> applyDescdSelector nd fathers siblings before level s nextSel pseudo
            ChilSelector s 
                -> applyChildSelector nd fathers siblings before level s nextSel pseudo
            SiblSelector s 
                -> applySiblnSelector nd fathers siblings before level s nextSel pseudo
\end{code}
\caption{Función matchSelector} \label{lhc:matchselector}
\end{hs}

La función |matchSelector| recibe un nodo de tipo |Nodo|, una lista de padres (que también incluye a los
hermanos de cada padre) de tipo |[(Nodo,[Nodo])]|, una lista de hermanos de tipo |[Nodo]|, una lista de padres
anteriores (los nodos padres que ya se reviso) de tipo |[(Nodo, [Nodo])]|, un contador de tipo |Int| que indica el nivel 
del árbol donde se encuentra el proceso de emparejamiento y un valor |Bool| que indica si se va a revisar el pseudo elemento. 
Finalmente, la función devuelve un valor |Bool| el cual indica si se emparejo el selector con el nodo.

\subsubsection{Emparejar un Simple Selector}

En el \pref{lhc:applys1} se define la función |applySimplSelector|, que empareja un selector simple.
Para emparejar un selector simple, se llama a la función |testSimpleSelector| definida en \pref{lhc:funsel1}, 
y luego se continua emparejando los siguientes selectores.

\begin{hs} 
\small
\begin{code}
applySimplSelector nd fathers siblings before level s nextSel pseudo
    =  testSimpleSelector s nd pseudo 
   &&  matchSelector nd fathers siblings before level nextSel False
\end{code}
\caption{Emparejar un SimplSelector} \label{lhc:applys1}
\end{hs}

Note que no se modifica las variables `before' y `level' porque se está manteniendo en el mismo nivel.


\subsubsection{Emparejar un Selector Descendiente}

Para emparejar un selector descendiente, primeramente se verifica que la lista de padres 
no sea vacía, si es así, se devuelve directamente |False|, 
porque no se puede aplicar este tipo de selector. 

En otro caso, cuando la lista de padres no es vacía, se crea 2 opciones de emparejamiento con el operador OR \verb?(||)?
de Haskell. La primera opción empareja el primer padre y el selector y continua emparejando los siguientes 
selectores añadiendo el primer padre a la lista de anteriores e incrementando el contador de nivel |level|. 
Si la primera opción falla en el emparejamiento, se utiliza la segunda opción. 

La segunda opción vuelve a llamar a la función para emparejar selectores descendientes con la lista restante 
de padres.

El uso del operador |OR| de Haskell permite implementar el algoritmo de |backtraking| de los selectores 
descendientes.\\

En el \pref{lhc:applys2} se describe la implementación de la función |applyDescdSelector|.

\begin{hs} 
\small
\begin{code}
applyDescdSelector  _   []      _         _       _      _  _        _
    = False
applyDescdSelector  nd  (f:fs)  siblings  before  level  s  nextSel  pseudo
    =   (    testSimpleSelector s (fst f) pseudo 
	     &&  matchSelector nd fs siblings (f:before) (level+1) nextSel False)
    ||  applyDescdSelector nd fs siblings before level s nextSel False
\end{code} 
\caption{Emparejar un DescdSelector} \label{lhc:applys2}
\end{hs}

\subsubsection{Emparejar un Selector Hijo}

El selector hijo es similar al selector descendiente, la única diferencia entre ambos es que el selector hijo
simplemente revisa el primer nivel, en otras palabras, no necesita hacer backtracking. En el \pref{lhc:applys3}
describe la implementación de la función |applyChildSelector|.

\begin{hs} 
\small
\begin{code}
applyChildSelector  _   []      _         _       _      _  _        _
    = False
applyChildSelector  nd  (f:fs)  siblings  before  level  s  nextSel  pseudo
    =   testSimpleSelector s (fst f) pseudo 
    &&  matchSelector nd fs siblings (f:before) (level+1) nextSel False
\end{code} 
\caption{Emparejar un ChildSelector} \label{lhc:applys3}
\end{hs}

Note que de la misma manera que para el selector descendiente, se incrementa el nivel |level|.

\subsubsection{Emparejar un Selector Hermano}

Para implementar el Selector Hermano, se inicia definiendo la función |getNextvalidTag| del \pref{lhc:valids},
que se encarga de encontrar un hermano válido dada una lista de hermanos.

Un hermano válido es el primer nodo o etiqueta que se encuentra en la lista. Note que este nodo no puede
ser comentario o texto. 
Se retorna una tupla, donde el primer elemento es un `Bool' que indica si se encontró un hermano válido, 
y el segundo elemento es una lista de nodos, donde el primer elemento es el hermano válido. Sino se encuentra
un hermano válido, se devuelve lista vacía.

\begin{hs} 
\small
\begin{code}
getNextValidTag ::  [Nodo]            ->  (Bool, [Nodo])
getNextValidTag     []                =   (False, [])
getNextValidTag     l@(NTag _ _ _:_)  =   (True, l)
getNextValidTag     (_:xs)            =   getNextValidTag xs
\end{code} 
\caption{Función para encontrar un hermano válido} \label{lhc:valids}
\end{hs}


Para el selector hermano (Sibling Selector) se debe considerar a los nodos hermanos del nodo actual.
Los nodos hermanos pueden aparecer en 2 lugares: en la variable |siblings| si se encuentra en el nivel 0, 
o en la lista de nodos padres y hermanos |before| si se encuentra en un nivel mayor a 0. 

Cuando se encuentra en un nivel mayor a |0|, la lista de hermanos es el segundo elemento de la lista de tuplas |before|.\\

En el \pref{lhc:applys4} se define la función |applySiblnSelector|, esta función define la variable |brothers| que 
guarda la lista de hermanos de nivel 0 o superior.

Luego, dependiendo de la función |getNetValidTag|, se procede a construir la nueva lista de hermanos y a procesar los siguientes selectores.

Si existe un hermano válido, entonces se debe comprobar que sea el hermano que se esta buscando (para esto, se llama a función 
|testSimpleSelector| definida en \pref{lhc:funsel1}), caso contrario se retorna |False| y termina la función.

Si el nodo hermano empareja con el selector, entonces se debe construir una nueva lista de hermanos, porque podría existir
otro selector hermano el cual debe trabajar con la nueva lista de hermanos. \textbf{Nota:} Solo se modifica la lista de hermanos,
porque la otra información puede ser importante para los selectores restantes.

\begin{hs} 
\small
\begin{code}
applySiblnSelector nd fathers siblings before level s nextSel pseudo
    = let  brothers           =  if level == 0 then siblings else snd $ head before
           (bool,ts)          =  getNextValidTag brothers
           (ntest,rsibl)      =  if bool
                                 then (testSimpleSelector s (head ts) pseudo  , tail ts  )
                                 else (False                                  , []       )
           (newSibl,newBefo)  =  if level == 0
                                 then (rsibl,before)
                                 else  let  (f,_)      = head before
                                            newBefore  = (f, rsibl) : tail before
                                       in (siblings, newBefore)
      in ntest && matchSelector nd fathers newSibl newBefo level nextSel False
\end{code}
\caption{Emparejar un SiblnSelector} \label{lhc:applys4}
\end{hs}

Vea que no se modifica el nivel, ni tampoco la lista |before|, porque se está manteniendo en el mismo nivel.

\subsection{La función emparejarSelector}

Finalmente, en el \pref{lhc:mainsel} se define la función `emparejarSelector', la cual inicializa los valores 
por defecto para llamar a la función `matchSelector'.

\begin{hs} 
\small
\begin{code}
emparejarSelector :: Nodo -> [(Nodo,[Nodo])] -> [Nodo] -> Selector -> Bool -> Bool
emparejarSelector nd fths sbls = matchSelector nd fths sbls [] 0
\end{code} 
\caption{La función emparejarSelector} \label{lhc:mainsel}
\end{hs}

Con todo esto, la función |emparejarSelector| recibe un |Nodo| con el cual emparejar, una lista de nodos padres junto 
con sus hermanos, otra lista de nodos hermanos, el selector a emparejar y un valor |Bool| que indica si se desea emparejar 
el elemento pseudo. Y como resultado se devuelve un |Bool| que indica verdadero si el selector empareja con el nodo o falso
en caso contrario.


\subsection{Usando UUAGC para recolectar información}

Ahora se utilizará la herramienta UUAGC para recolectar la información que la función |emparejarSelector|
necesita.

Se inicia definiendo el atributo sintetizado |self| sobre |Nodo|, el cual guarda la información de sí mismo:

\begin{ag} 
\small
\begin{code}
ATTR Nodo [ ^^ | ^^ | self: SELF ]
\end{code} 
\end{ag}

También se define otro atributo sintetizado |nd| en cada |NTree|, este atributo almacena el nodo |self|:

\begin{ag} 
\small
\begin{code}
ATTR NTree [ ^^ | ^^ | nd:Nodo ]
SEM NTree
    | NTree lhs.nd = @nodo.self
\end{code} 
\end{ag}

Ahora, se construirá la lista de padres y hermanos de cada padre. Se define un atributo heredado |fathers|
el cual es una lista de tuplas, donde el primer elemento es el nodo padre y el segundo elemento es la lista
de los hermanos del nodo padre:

\begin{ag} 
\small
\begin{code}
ATTR NTrees NTree [ fathers: {[(Nodo, [Nodo])]} | ^^ | ^^ ]
SEM NTree
    | NTree  ntrees.fathers  = (@nodo.self, @loc.siblings) : @lhs.fathers
             loc.fathers     = @lhs.fathers
\end{code} 
\end{ag}

También se define una variable local |fathers| que almacena la lista de padres que se ha recolectado hasta
el nivel del |NTree| donde es invocado.

Al momento de construir la tupla, se hace referencia a |loc.siblings|. La variable local |siglings|
es similar a la variable local |fathers| con la diferencia de que |siblings| guarda la lista de hermanos que se ha
recolectado hasta el nivel de |NTree| donde es invocado.

La lista de hermanos está definido a través de un atributo heredado |siblings|, que colecciona los nodos de los
|NTrees| y comparte la lista de hermanos con el |NTree|.

\begin{ag} 
\small
\begin{code}
ATTR NTrees NTree [ siblings: {[Nodo]} | ^^ | ^^ ]
SEM NTrees
    | Cons  tl.siblings  = @hd.nd : @lhs.siblings
            hd.siblings  = @lhs.siblings
\end{code} 
\end{ag}

Cada lista de hermanos es inicializada en cada |NTree| con una lista vacía.
También se define la variable local |siblings| (la cual es utilizada en el atributo |fathers|) que almacena la lista de
hermanos del nodo:

\begin{ag} 
\small
\begin{code}
SEM NTree
    | NTree  ntrees.siblings  = []
             loc.siblings     = @lhs.siblings
\end{code} 
\end{ag}

Se necesita inicializar los atributos |fathers| y |siblings| en el nodo |Root|:

\begin{ag} 
\small
\begin{code}
SEM NRoot
    | NRoot  ntree.fathers   = []
             ntree.siblings  = []
\end{code} 
\end{ag}

\subsection{La variable local \textit{reglasEmparejadas}}

Finalmente, en el \pref{lac:reglasEmparejadas}, se define la variable local |reglasEmparejadas| que almacena la lista
de reglas CSS que emparejan con el nodo.

Para emparejar las reglas se hace uso de la función |emparejarSelector| definida en el \pref{lhc:mainsel}:

\begin{ag} 
\small
\begin{code}
SEM NTree
    | NTree loc.reglasEmparejadas 
                =  let  applyMatchSelector selector = emparejarSelector ^^  @nodo.self 
                                                                            @loc.fathers 
                                                                            @loc.siblings 
                                                                            selector 
                                                                            False
                        obtenerReglas selector r1 r2 =  if applyMatchSelector selector
                                                        then r1 ++ r2
                                                        else r2
                   in Map.foldWithKey obtenerReglas [] ^^ @loc.misHojasEstilo
\end{code}
\caption{La variable local reglasEmparejadas} \label{lac:reglasEmparejadas}
\end{ag}


\section{Propiedades de CSS}
En esta sección se continua con la asignación de un valor a una propiedad. Primeramente
se definirá el tipo de dato para representar una propiedad de CSS en Haskell, luego se describirá
las funciones que se encarguen de asignar un valor a una propiedad.

\subsection{El tipo de dato Property} \label{sec:tprop}

Uno de los tipos de datos importantes del proyecto es el tipo de dato |Property|. 
Este tipo representa a una propiedad de CSS (descrita en \pref{sec:mprops}), 
por consiguiente, tiene un nombre, un valor |Bool| para representar
si es heredable, un valor inicial, un parser para sus valores, el valor de la propiedad de 
tipo |PropertyValue|
y dos funciones para generar valores de tipo computed y used respectivamente.

En el \pref{lhc:property} se muestra la definición del tipo de dato |Property|.

\begin{hs} 
\small
\begin{code}
data Property
    = Property      { nombre           :: String
                    , inherited        :: Bool
                    , initial          :: Valor
                    , valor            :: Parser Valor
                    , propertyValue    :: PropertyValue
                    , fnComputedValue  :: FunctionComputed
                    , fnUsedValue      :: FunctionUsed
                    }

data PropertyValue
    = PropertyValue     { specifiedValue    :: Valor
                        , computedValue     :: Valor
                        , usedValue         :: Valor
                        , actualValue       :: Valor
                        }
\end{code}
\caption{El tipo de dato |Property|} \label{lhc:property}
\end{hs}

\subsection{Funciones útiles para Property} \label{sec:funprops}

En esta sub~sección se define algunas funciones útiles para |Property|.

\begin{itemize}
\item Obtener el nombre de la propiedad:

\begin{hs}
\small
\begin{code}
getPropertyName = nombre
\end{code}
\caption{Obtener el nombre de una propiedad} \label{lhc:property1}
\end{hs}

\item Obtener el |PropertyValue| de una propiedad. Recibe una estructura |Map| y una clave y devuelve
      el |PropertyValue| de la propiedad donde apunta la clave en la estructura |Map|.

\begin{hs}
\small
\begin{code}
get :: Map.Map String Property -> String -> PropertyValue
get map k = propertyValue $ map ^^ Map.! ^^ k
\end{code}
\caption{Obtener el |PropertyValue| de una propiedad} \label{lhc:property2}
\end{hs}

\item Obtener el |PropertyValue| de una propiedad encapsulado en un tipo |Maybe|. Al igual que el anterior,
      se recibe una estructura |Map| y una clave, si la clave no se encuentra en la estructura |Map| se 
      devuelve |Nothing|, caso contrario se devuelve el |PropertyValue| (encapsulado en el tipo |Just|) de la propiedad donde apunta
      la clave.

\begin{hs}
\small
\begin{code}
getM :: Map.Map String Property -> String -> Maybe PropertyValue
getM map k = maybe Nothing (Just :.: propertyValue) $ Map.lookup k map
\end{code}
\caption{Obtener el |PropertyValue| de una propiedad encapsulado en |Maybe|} \label{lhc:property3}
\end{hs}

\item Modificar el |PropertyValue| de una propiedad. Se recibe una función que modifique
      el |PropertyValue|, la propiedad y se retorna la propiedad modificada.

\begin{hs}
\small
\begin{code}
adjustPropertyValue :: (PropertyValue -> PropertyValue) -> Property -> Property
adjustPropertyValue fpv prop@(Property _ _ _ _ pv _ _)
    = prop{propertyValue = fpv pv}
\end{code}
\caption{Función para modificar el |PropertyValue| de una propiedad} \label{lhc:property4}
\end{hs}

\item Comparar un |ValorClave| con un |String|. Se recibe una función para comparar,
      el valor y el |String|. Si el valor que se recibe no es |ValorClave|, entonces
      se retorna directamente |False|, caso contrario se aplica la función que se recibe.

\begin{hs}
\small
\begin{code}
compareKeyPropertyValueWith fcmp val str 
    =   case val of
            ValorClave str'   -> fcmp str' str
            _                 -> False
\end{code}
\caption{Función genérica para comparar el valor de una propiedad} \label{lhc:property5}
\end{hs}

Con la ultima definición, se puede crear una función que realice una comparación con la función de igualdad:

\begin{hs}
\small
\begin{code}
compareKeyPropertyValue :: Valor -> String -> Bool
compareKeyPropertyValue = compareKeyPropertyValueWith (==)
\end{code}
\caption{Función para comparar el valor de una propiedad con la igualdad} \label{lhs:property6}
\end{hs}

\item Obtener el |ValorClave| envuelto en el tipo de dato |Valor|.

\begin{hs}
\small
\begin{code}
unKeyUsedValue       = (\(ValorClave    v) -> v) :.: usedValue
unKeyComputedValue   = (\(ValorClave    v) -> v) :.: computedValue
unKeySpecifiedValue  = (\(ValorClave    v) -> v) :.: specifiedValue
\end{code}
\caption{Funciones que retornan el valor almacenado por el constructor |ValorClave|} \label{lhc:property7}
\end{hs}

\item Obtener el |ColorClave| envuelto en el tipo de dato |Valor|.

\begin{hs}
\small
\begin{code}
unKeyUsedColor          = (\(ColorClave    v) -> v) :.: usedValue
unKeyComputedColor      = (\(ColorClave    v) -> v) :.: computedValue
unKeySpecifiedColor     = (\(ColorClave    v) -> v) :.: specifiedValue
\end{code}
\caption{Funciones que retornan el color almacenado por el constructor |ColorClave|} \label{lhc:property8}
\end{hs}

\item Obtener el |NumeroPixel| envuelto en el tipo de dato |Valor|.

\begin{hs}
\small
\begin{code}
unPixelUsedValue        = (\NumeroPixel px -> px) :.: usedValue
unPixelComputedValue    = (\NumeroPixel px -> px) :.: computedValue
unPixelSpecifiedValue   = (\NumeroPixel px -> px) :.: specifiedValue
\end{code}
\caption{Funciones que retornan el número |pixel| almacenado por el constructor |NumeroPixel|} \label{lhc:property9}
\end{hs}

\item Verificar que el |ValorClave| de una propiedad sea el mismo que el que recibe como argumento.

\begin{hs}
\small
\begin{code}
verifyProperty :: String -> String -> Map.Map String Property -> Bool
verifyProperty nm val props 
    =   let pval = computedValue $ props `get` nm
        in compareKeyPropertyValue pval val
\end{code}
\caption{Función para comparar el |ValorClave| de una propiedad} \label{lhc:property10}
\end{hs}

\end{itemize}

\subsection{SpecifiedValue de CSS}

El SpecifiedValue de CSS corresponde al valor especificado en las hojas de estilo, el cual se
obtiene como resultado de aplicar el algoritmo cascada de CSS (\pref{sec:acascada}).

\subsubsection{El algoritmo en Cascada}
El algoritmo en cascada (\pref{sec:acascada}) indica que una vez que se tiene las hojas de estilo que emparejan con el nodo, 
lo primero que debe hacer es obtener todas las declaraciones de estilo para la propiedad, 
para la cual se quiere encontrar su valor. Luego se aplica el algoritmo de ordenamiento en cascada a la lista resultante
y finalmente se selecciona el primer valor de la lista resultado.

En el \pref{lhc:doSpecifiedValue} se muestra la definición de la función |doSpecifiedValue|, que se encarga de
obtener las declaraciones, aplicar el algoritmo cascada y seleccionar un valor. 

Se utiliza |parttern matching| en la definición de la función, si el valor de la propiedad es |NoEspecificado|, 
entonces se aplica el algoritmo, pero si existe un valor, simplemente se devuelve el valor especificado.

\begin{hs} 
\small
\begin{code}
doSpecifiedValue  :: Map.Map String Property
				  -> Bool 
				  -> [(Tipo,Origen,Declaraciones,Int)] 
				  -> Property
				  -> Property
doSpecifiedValue  father 
                  isRoot 
                  rules 
                  prop@(Property nm inh defval _ NoEspecificado _ _ _ _ _)

    = selectValue :.: applyCascadingSorting $ getPropertyDeclarations nm rules
    
   where  applyCascadingSorting 
              = head' :.: dropWhile null :.: cascadingSorting
          selectValue rlist
              =  if null rlist
                 then  if inh && not isRoot
                       then  let sv = getComputedValue $ father `get` nm
                             in prop{propertyValue = pv{specifiedValue = sv}}
                       else prop{propertyValue = pv{specifiedValue = defval}}
                 else  let (_, _, Declaracion _ val _, _, _) = head rlist
                       in  if compareKeyPropertyValue val "inherit"
                           then  if isRoot
                                 then prop{propertyValue = pv{specifiedValue = defval}}
                                 else  let sv = computedValue $ father `get` nm
                                       in prop{propertyValue = pv{specifiedValue = sv}}
                           else prop{propertyValue = pv{specifiedValue = val}}
doSpecifiedValue  _ _ _ p 
    = p
\end{code}
\caption{La función |doSpecifiedValue|} \label{lhc:doSpecifiedValue}
\end{hs}

La función |applyCascadingSorting| devuelve el primer elemento del resultado de
eliminar todas listas vacías de la llamada a la función |cascadingSorting|. Si la
lista que se aplica a |head'| es vacía, se devuelve lista vacía.

\subsubsection{Seleccionar un valor}

La función |selectValue| que está definida en la función |doSpecifiedValue|, selecciona
un valor para una propiedad de CSS. 

Si la lista de declaraciones que se recibe es vacía, significa que no se encontró un valor
en las hojas de estilo, en este caso, se puede hacer 2 cosas: (a) heredar el valor del
nodo padre o (b) devolver el valor por defecto de la propiedad.\\

Para el primer caso, se debe verificar que la propiedad sea heredable y que no sea el nodo |Root| 
(porque el nodo |Root| no tiene nodo padre).\\

En el caso de que la lista que se recibe no es vacía, significa que existe al menos una declaración
para la propiedad en las hojas de estilo, entonces se obtiene la primera declaración de la lista.
Luego se verifica si el valor que se ha obtenido es |inherit|, si es así, se debe obtener el
valor del padre con la consideración de no encontrarse en el nodo |Root|, pero si se encuentra en el
nodo |Root| se debe usar el valor por defecto de la propiedad.
\newline
Si el valor de la primera declaración no es ``inherit'', se utiliza su valor para construir 
la propiedad.

\subsubsection{Obteniendo las declaraciones para una propiedad específica}

En el \pref{lhc:getpd} se define la función |getPropertyDeclarations| que recibe el nombre de una propiedad,
una lista de declaraciones y devuelve todas las declaraciones para el nombre de la propiedad. 

Como una tarea extra, se expande la lista de listas de declaraciones a una lista simple de declaraciones.

\begin{hs} 
\small
\begin{code}
getPropertyDeclarations  ::  String  ->  [(Tipo,Origen,Declaraciones,Int)] 
                                     ->  [(Tipo,Origen,Declaracion,Int)]
getPropertyDeclarations nm1 = foldr fConcat []
    where  fConcat (tipo,origen,declaraciones,spe) r2 
             =  let r0 = filter (\ (Declaracion nm2 _ _) -> nm1 == nm2) declaraciones
                in  if null r0
                    then r2
                    else  let r1 = map (\decl -> (tipo,origen,decl,spe)) r0
                          in r1 ++ r2
\end{code}
\caption{Obtener todas las declaraciones para una propiedad} \label{lhc:getpd}
\end{hs}


\subsubsection{Ordenamiento en Cascada}

%El algoritmo de ordenamiento en cascada nos dice que se debe ordenar de acuerdo a ciertos patrones:
%\begin{itemize}
%	\item de acuerdo al origen e importancia:
%    \begin{enumerate}
%	    \item declaraciones User important
%	    \item declaraciones Author important
%	    \item declaraciones Author normal
%	    \item declaraciones User normal
%	    \item declaraciones UserAgent normal
%    \end{enumerate}
%	\item y para evitar igualdades, de acuerdo a la especificidad de un selector
%	\item y si aun hubiera más igualdades, se ordena de acuerdo al orden de especificación.
%\end{itemize}
%
%Las declaraciones |important| corresponden a las declaraciones que tienen `$!important$' en la sintaxis 
%concreta. Estos valores están especificados con un valor |Bool| verdadero si son |important| y 
%falso si son normal.\\

En la \pref{sec:acascada} se describe el algoritmo de ordenamiento en cascada, el cual es implementado
en la función |cascadingSorting| definida en el \pref{lhc:algoritmoCascading}. Esta función recibe una 
lista de tuplas de |Tipo|, |Origen|, |Declaracion| y |Especificidad|
del selector que corresponde al último valor de la tupla. La especificidad es calculado después del proceso
de análisis sintáctico (parsing), pero se explicará como se encuentra la especificidad de un selector 
en la siguiente sección.\\


Lo primero que se hace en la función |cascadingSorting| es asignar una posición a cada declaración (esto
para ordenar de acuerdo a la especificación). Luego, se construye la lista resultado donde la primera sub-lista
son las declaraciones |User Important|, posteriormente están los de |Author Important| y así sucesivamente. 

La función |getDeclarations| obtiene las declaraciones de acuerdo al origen e importancia. Luego, 
se llama a la función |sortBy| para que ordene la lista de acuerdo a la especificidad y posición.

\begin{hs} 
\small
\begin{code}
cascadingSorting :: [(Tipo,Origen,Declaracion,Int)] -> [[(Tipo,Origen,Declaracion,Int,Int)]]
cascadingSorting lista1 
    = let  lista2   = myZip lista1 [1..]
           lst1     = sortBy fsort $ getDeclarations User       True  lista2
           lst2     = sortBy fsort $ getDeclarations Author     True  lista2
           lst3     = sortBy fsort $ getDeclarations Author     False lista2
           lst4     = sortBy fsort $ getDeclarations User       False lista2
           lst5     = sortBy fsort $ getDeclarations UserAgent  False lista2
      in [lst1, lst2 ,lst3, lst4, lst5]
    where  myZip []                _       = []
           myZip ((a,b,c,d):next)  (f:fs)  = (a,b,c,d,f) : myZip next fs
           getDeclarations origin important 
              = filter (\(_,org, Declaracion _ _ imp,_,_) -> origin==org && important==imp)
           fsort (_, _, _, v1, v3) (_, _, _, v2, v4)
                  | v1 > v2              = LT
                  | v1 < v2              = GT
                  | v1 == v2 && v3 > v4  = LT
                  | v1 == v2 && v3 < v4  = GT
                  | otherwise            = EQ
\end{code} 
\caption{Algoritmo |cascadingSorting|} \label{lhc:algoritmoCascading}
\end{hs}

\subsubsection{Especificidad de un Selector}

Este valor corresponde al 4to elemento de la tupla de la lista de declaraciones. Se obtiene este valor
después de hacer el análisis sintáctico (parsing).

La forma de obtener la especificidad de un selector esta descrita en la \pref{sec:acascada}. 
Básicamente, la especificidad de un selector es un número de 4 cifras: `abcd'.

En cada cifra se cuenta las ocurrencias de un cierto tipo. Por ejemplo, 
en la cifra `d' se cuenta todas las ocurrencias de los elementos pseudo. Para esto se ha definido un
atributo sintetizado `d':

\begin{ag} 
\small
\begin{code}
ATTR MaybePseudo [ ^^ | ^^ | d: Int ]
SEM MaybePseudo
    | Just      lhs.d = 1     -- tiene un pseudo
    | Nothing   lhs.d = 0     -- no tiene pseudo
\end{code} 
\end{ag}

También se cuenta todos los atributos |ID| en `b' y todos los atributos que no son |ID| `c'.
Del mismo modo, se ha definido un atributo sintetizado para cada contador.

Como se puede tener una lista de atributos, se suma todas las ocurrencias de `b' y `c'.

\begin{ag} 
\small
\begin{code}
ATTR Atributos Atributo [ ^^ | ^^ | b, c USE {+} {0}: Int]
SEM Atributo
    | AtribID     lhs.b = 1   
                  lhs.c = 0   -- 0 (cero) porque no tiene otros atributos
    | AtribNombre lhs.b = 0   -- 0 (cero) porque no es ID
                  lhs.c = 1
    | AtribTipoOp lhs.b = 0   -- 0 (cero) porque no es ID
                  lhs.c = 1
\end{code} 
\end{ag}

También se debe contar los nombres de los elementos en `d'. Vea que sólo el |TypeSelector|
tiene nombre, el |UnivSelector| no tiene nombre y por consecuente no se cuenta.

Como puede haber una lista de |ESelector|, se suma todas las ocurrencias de estas cifras:

\begin{ag} 
\small
\begin{code}
ATTR Selector ESelector SSelector [ ^^ | ^^ | b, c, d USE {+} {0}: Int ]
SEM SSelector
    | TypeSelector lhs.d = @maybePseudo.d + 1
\end{code} 
\end{ag}

La cifra `a' es un caso especial, porque si se está frente a un |EstiloAtributo|, 
la especificidad es igual a `1000' y se omiten las otras cifras. Es decir $a=1$ y $b=0,c=0,d=0$.
Caso contrario, $a=0$ y no se omiten las demás cifras.

\begin{ag} 
\small
\begin{code}
ATTR Regla [ ^^ | ^^ | output: {(Tipo, Origen, Selector, Declaraciones, Int)}]
SEM Regla
    | Tuple lhs.output =  let  especificidad 
                                =  if ^^ @x1.self == EstiloAtributo
                                   then 1000
                                   else  ^^  @x3.b * (10^3) + 
                                             @x3.c * (10^2) + 
                                             @x3.d * 10
                          in  ( @x1.self, @x2.self, @x3.self, @x4.self, especificidad)
\end{code} 
\end{ag}

Las referencias a atributos `self' son atributos sintetizados que contienen su mismo valor y tipo:

\begin{ag} 
\small
\begin{code}
SET All = * - SRoot
ATTR All [ ^^ | ^^ | self: SELF]
\end{code} 
\end{ag}

Una vez que se obtiene la especificidad de un selector, se recoge todas las reglas en una lista:

\begin{ag} 
\small
\begin{code}
ATTR HojaEstilo [ ^^ | ^^ | output USE {:} {[]}: {  [(Tipo, Origen, Selector, Declaraciones, Int)]}]
\end{code} 
\end{ag}

Finalmente se construye la estructura |Map| con el tipo |MapSelector| (descrito en \pref{sec:mapselector})
y se aplica la función |reverse| de Haskell sobre los selectores para que el proceso de emparejamiento 
sea más sencillo.

\begin{ag} 
\small
\begin{code}
ATTR SRoot [ ^^ | ^^ | output2: {MapSelector}]
SEM SRoot
    | SRoot lhs.output2 =  let fMap  (t,o,s,d,e) map' 
                                     = Map.insertWith  (++) (reverse s) [(t,o,d,e)] map'
                           in foldr fMap Map.empty ^^ @he.output
\end{code} 
\caption{Construir la estructura |MapSelector|} \label{lac:mapSelector}
\end{ag}

\subsection{ComputedValue, UsedValue y ActualValue de CSS} \label{sec:modproperty}

La función para encontrar el |specifiedValue| es el mismo para todas las propiedades, 
pero las funciones para encontrar los otros valores (computedValue, usedValue y actualValue) 
pueden ser diferentes para cada propiedad.

Es por eso que se ha definido funciones `fnComputedValue' y `fnUsedValue' en el tipo de
dato |Property|. No se ha definido una función para el |actualValue| porque no se está utilizando 
en todo el proyecto.

\subsubsection{ComputedValue} \label{sec:computed}

En el \pref{lhc:fcomputed} se muestra el tipo de la función `fnComputedValue'.

\begin{hs} 
\small
\begin{code}
type FunctionComputed   =   Bool                            -- soy el root?
                        ->  Map.Map String Property         -- father props
                        ->  Map.Map String Property         -- local  props
                        ->  Maybe Bool                      -- soy replaced ?
                        ->  Bool                            -- revizare el pseudo?
                        ->  String                          -- Nombre
                        ->  PropertyValue                   -- PropertyValue
                        ->  Valor
\end{code}
\caption{El tipo de la función |fnComputedValue|} \label{lhc:fcomputed}
\end{hs}

Para obtener el valor |computedValue| de una propiedad se debe llamar a la función 
\newline
|doComputedValue| con los
parámetros que necesita la función |fnComputedValue| de la propiedad.

El \pref{lhc:docomputedvalue} muestra la definición de la función |doComputedValue|. Se está usando \textit{Pattern matching} 
sobre la propiedad para definir la función.
Si el valor |computedValue| de la propiedad es |NoEspecificado| entonces se obtiene la función \textit{fnComputedValue}
de la propiedad y se aplica con los parámetros con que se le envía a |doComputedValue|, con ese resultado
se construye una nueva propiedad.

Pero, si el valor |computedValue| de la propiedad es diferente a |NoEspecificado|, significa que se aplicó la
función |fnComputedValue|, entonces simplemente se devuelve la propiedad:

\begin{hs} 
\small
\begin{code}
doComputedValue     ::     Bool 
				    ->     Map.Map String Property
				    ->     Map.Map String Property
				    ->     Maybe Bool 
				    ->     Bool 
				    ->     Property
				    ->     Property

doComputedValue     iamtheroot 
                    fatherProps 
                    locProps 
                    iamreplaced 
                    iamPseudo 
                    prop@(Property nm _ _ _ pv@(PropertyValue _ NoEspecificado _ _) fnc _)
    =   let cv = fnc iamtheroot fatherProps locProps iamreplaced iamPseudo nm pv
        in prop{propertyValue = pv{computedValue = cv}}
 
doComputedValue _ _ _ _ _ p 
    = p 
\end{code} 
\caption{La función |doComputedValue|} \label{lhc:docomputedvalue}
\end{hs}

Muchas veces el valor |computedValue| es el mismo que |specifiedValue|, para estos casos, se ha definido un función
`computed\_asSpecified' el cual copia el valor del |specifiedValue| al |computedValue|.

\begin{hs} 
\small
\begin{code}
computed_asSpecified :: FunctionComputed
computed_asSpecified _ _ _ _ _ _ = specifiedValue
\end{code}
\caption{La función \textit{computed\_asSpecified}} \label{lhc:fcomputed1}
\end{hs}

\subsubsection{UsedValue} \label{sec:used}

En el \pref{lhc:fused} se muestra el tipo de la función `fnUsedValue'.

\begin{hs}
\small
\begin{code}
type FunctionUsed   =   Bool                                -- soy el root?
                    ->  (Float, Float)                      -- dimenciones del root
                    ->  Map.Map String Property             -- father props
                    ->  Map.Map String Property             -- local props
                    ->  Map.Map String String               -- atributos
                    ->  Bool                                -- soy replaced?
                    ->  String                              -- Nombre
                    ->  PropertyValue                       -- PropertyValue
                    ->  Valor
\end{code}
\caption{El tipo de la función |fnUsedValue|} \label{lhc:fused}
\end{hs}

Al igual que |doComputedValue|, en el \pref{lhc:dousedvalue} se define la función |doUsedValue| para aplicar la función y 
encontrar el valor de |usedValue|. Esta función está definido usando |pattern matching| sobre el valor de |usedValue|,
si este es |NoEspecificado|, se aplica la función, caso contrario se devuelve simplemente
la propiedad.

\begin{hs}
\small
\begin{code}
doUsedValue     ::  Bool 
                ->  (Float,Float) 
                ->  Map.Map String Property 
                ->  Map.Map String Property 
                ->  Map.Map String String 
                ->  Bool 
                ->  Property 
                ->  Property
doUsedValue     iamtheroot 
                icbsize 
                fatherProps 
                locProps 
                attrs 
                iamreplaced 
                prop@(Property nm _ _ _ pv@(PropertyValue _ _ NoEspecificado _) _ fnu)
    =   let uv = fnu iamtheroot icbsize fatherProps locProps attrs iamreplaced nm pv
        in prop{propertyValue = pv{usedValue = uv}}
 
doUsedValue _ _ _ _ _ _ p = p
\end{code}
\caption{La función |doUsedValue|} \label{lhc:dousedvalue}
\end{hs}

También se define una función `used\_asComputed' el cual copia el valor de |computedValue| en el 
de |usedValue|:

\begin{hs} 
\small
\begin{code}
used_asComputed :: FunctionUsed
used_asComputed _ _ _ _ _ _ _ = computedValue
\end{code} 
\caption{La función \textit{used\_asComputed}} \label{lhc:fused1}
\end{hs}


\subsection{La lista de Propiedades} \label{sec:lprops}

En la \pref{sec:props_css} se ha definido una lista de propiedades CSS como una lista de tuplas, donde el
primer valor era el nombre de la propiedad y el segundo valor era el parser para los valores de la propiedad.
En esta sección se modificará esa lista de propiedades, de manera que la nueva lista
debe almacenar el tipo de dato |Property|.\\

Para crear un valor de tipo |Property| no se necesita que todos los parámetros sean 
escritos explícitamente, por ejemplo, los valores 
|specifiedValue|, |computedValue|, |usedValue| y |actualValue| no necesitan ser descritos al momento inicial. 
Así, en el \pref{lhc:mkprop} se ha definido la función |mkProp|, que recibe sólo los argumentos que necesarios.

\begin{hs} 
\small
\begin{code}
mkProp (nm, bool, init, pval, fnc, fnu)
    = Property  nm 
                bool 
                init 
                pval 
                defaultPropertyValue
                fnc
                fnu

defaultPropertyValue 
    = PropertyValue     {   specifiedValue  = NoEspecificado
                        ,   computedValue   = NoEspecificado
                        ,   usedValue       = NoEspecificado
                        ,   actualValue     = NoEspecificado
                        }
\end{code} 
\caption{La función |mkProp|} \label{lhc:mkprop}
\end{hs}

A continuación, se muestra un ejemplo de la nueva lista de propiedades
utilizando la función |mkProp|:

\begin{hs} 
\small
\begin{code}
propiedadesCSS :: [Property]
propiedadesCSS
 = [ mkProp  ( "display",  False, (ValorClave "inline"), display, cdisplay, udisplay)]

display :: Parser Valor
display = pValoresClave  [ "inline"
                         , "block"
                         , "list-item"
                         , "none"
                         , "inherit"]

cdisplay = computed_asSpecified
udisplay = used_asComputed
\end{code}
\end{hs}

En la anterior versión (\pref{sec:props_css}) se necesitaba tener una lista de tuplas con nombre y parser del valor.
Se puede definir la función |propertyParser| para obtener el nombre y parser de una propiedad:

\begin{hs}
\small
\begin{code}
propertyParser :: Property -> (String, Parser Valor)
propertyParser (Property nm _ _ pr _ _ _) = (nm,pr)
\end{code}
\caption{Obtener el nombre y parser de una propiedad}
\end{hs}

Luego, la función para construir la declaración cambiaría de la siguiente manera:

\begin{hs}
\small
\begin{code}
lista_valor_parser :: [Parser Declaraciones]
lista_valor_parser =  map (construirDeclaracion :.: propertyParser) propiedadesCSS
\end{code}
\end{hs}

\subsection{Encontrar los valores de SpecifiedValue y ComputedValue}

Para encontrar los valores |specifiedValue| de cada propiedad de la lista de propiedades
se debe primeramente recolectar los argumentos que se necesita para llamar a la función
|doSpecifiedValue|.

Para ello, se necesita saber si el nodo donde se encuentra, es el nodo |Root|.
Se define el atributo heredado |iamtheroot| de tipo |Bool| para identificar al nodo |Root|:

\begin{ag}
\small
\begin{code}
ATTR NTree NTrees [ iamtheroot: Bool | ^^ | ^^ ]
SEM NRoot
    | NRoot ntree.iamtheroot = True

SEM NTree
    | NTree ntrees.iamtheroot = False
\end{code} 
\end{ag}

Con esta información, se puede llamar a la función |doSpecifiedValue| de la siguiente forma:

\begin{ag} 
\small
\begin{code}
SEM NTree
    | NTree loc.specifiedValueProps
                 =  let propsTupla = map  (\p ->  ( getPropertyName p
                                                  , doSpecifiedValue ^^  @lhs.propsFather 
                                                                         @lhs.iamtheroot 
                                                                         @loc.reglasEmparejadas 
                                                                         p
                                                  )
                                          ) propiedadesCSS
                    in  Map.fromList propsTupla
\end{code} 
\caption{Llamando a la función |doSpecifiedValue|} \label{lac:callDoSpecified}
\end{ag}

En la definición del \pref{lac:callDoSpecified}, se construye una lista de tuplas, donde el primer 
valor es el nombre de la propiedad y el segundo
valor es el resultado de llamar a |doSpecifiedValue|. Con esta lista, se construye la estructura 
`Map~String~Property' y se guarda en la variable local |specifiedValueProps|.\\

Los parámetros con los que se llama a la función |doSpecifiedValue| son: un valor heredado |propsFather| el cual
es definido una vez que se obtiene el |computedValue| de una propiedad, el valor heredado |iamtheroot|, 
un valor local |reglasEmparejadas| el cual es definido en el proceso de emparejar los selectores con el nodo, 
y una propiedad `|p|' que se recibe de la lista de propiedades.\\

Para encontrar el |computedValue| de una propiedad, se necesita casi los mismos valores que para 
|specifiedValue|. Lo que falta es encontrar el valor |replaced| de un nodo.

Un nodo es |replaced| sólo si el nodo con etiqueta es |replaced|, caso contrario es |Nothing| (del tipo de dato |Maybe|):

\begin{ag} 
\small
\begin{code}
ATTR Nodo [ ^^ | ^^ | replaced: {Maybe Bool}]
SEM Nodo
    | NTag    lhs.replaced = Just ^^ @replaced
    | NTexto  lhs.replaced = Nothing
\end{code} 
\end{ag}

Con esta información se puede llamar a la función |doComputedValue|:

\begin{ag} 
\small
\begin{code}
SEM NTree
    | NTree loc.computedValueProps = Map.map  (doComputedValue ^^   @lhs.iamtheroot
                                                                    @lhs.propsFather
                                                                    @loc.specifiedValueProps 
                                                                    @nodo.replaced 
                                                                    False
                                              ) ^^ @loc.specifiedValueProps
\end{code} 
\caption{Llamando a la función |doComputedValue|}
\end{ag}

La información que se enviará a |doComputedValue| es: un valor heredado que representa si el nodo es |Root|,
un valor heredado que representa la lista de propiedades del nodo padre, un valor local 
que representa la lista de propiedades locales, un valor sintetizado que representa si el nodo
es |replaced| y un valor |Bool| que indica si se revisará los elementos pseudo.\\

Vea que se está utilizando la función |map| de la estructura |Map|, para construir la nueva estructura |Map| de propiedades.
Esta nueva estructura es almacenada en la variable local |computedValueProps|.\\

Una vez que se tiene la nueva lista de propiedades, se debe compartir con los nodos hijos, para esto, se define 
el atributo heredado |propsFather|:

\begin{ag} 
\small
\begin{code}
ATTR NTree NTrees [propsFather: {Map.Map String Property} | ^^ | ^^ ]
SEM NTree
    | NTree ntrees.propsFather = @loc.computedValueProps

SEM NRoot
    | NRoot ntree.propsFather = Map.empty
\end{code} 
\end{ag}

Entonces, en cada nodo |NTree|, se comparte la nueva estructura (|computedValueProps|) con los nodos hijos (|ntrees|).
Pero para el caso del nodo |Root|, la lista de propiedades del padre es una estructura |Map| vacía.

