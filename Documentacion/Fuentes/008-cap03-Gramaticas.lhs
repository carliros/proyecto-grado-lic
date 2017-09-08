
%include lhs2TeX.fmt
\chapter{Sintaxis Concreta y Abstracta} \label{chp:gramaticas}

%\section{Introducción}

%if showChanges
\color{blue}
%endif

La primera tarea a realizar en el desarrollo de un Navegador Web es entender y representar la entrada para
el Navegador Web. Ésta entrada es una página Web, que está descrita a través de un lenguaje de marcado como HTML, 
que puede contener, dentro del archivo HTML, reglas de hojas de estilo que son descritas a través del lenguaje 
para hojas de estilos de CSS.
Entonces, la entrada para el Navegador Web está descrita a través de dos lenguajes, uno de marcado (HTML) y otro de 
estilos (CSS).\\

Los lenguajes son descritos a través de una sintaxis concreta, al mismo tiempo, una sintaxis concreta puede ser
representada utilizando una notación EBNF.
\newline
Para entender un lenguaje, básicamente, se necesita conocer su sintaxis concreta. 
Y para representarlo, se necesita una sintaxis abstracta.
\newline
La importancia de representar un lenguaje en Haskell radica en la necesidad de aplicar futuras operaciones 
sobre la entrada, de manera que ésta pueda ser renderizada como una página Web.\\

En las siguientes secciones del capítulo, se describirá en más detalle la sintaxis concreta y abstracta de un
lenguaje. También se mostrará la sintaxis concreta y abstracta para un lenguaje de marcado y de estilos.

%if showChanges
\color{black}
%endif

\section{Sintaxis concreta y abstracta de un lenguaje}

Una sintaxis concreta es descrita a través de una gramática\cite[p.~18]{grammar}, la cual está compuesta de un
conjunto de reglas de producción, símbolos terminales, símbolos no terminales y un símbolo de inicio. 
Estos 4 componentes definen la sintaxis para la gramática de un lenguaje.\\

La sintaxis abstracta también puede tener los 4 componentes de una gramática, pero normalmente
sólo guarda la información que es importante para el lenguaje (por ejemplo, no guarda los símbolos
terminales de la gramática). En otras palabras, una sintaxis abstracta \emph{abstrae} la
información importante de la gramática.\\

\vspace{3cm} 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sintaxis para Gramaticas Concretas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Notación BNF y EBNF}

\bnf, la versión no extendida de \ebnf, provee un formalismo para describir la sintaxis de un lenguaje. El formalismo de \bnf\ 
consiste de un conjunto de reglas de producción, que están compuestos de \emph{Terminales y No-Terminales}.\\

Un \emph{No-Terminal} es simplemente un nombre que hace referencia a una regla de producción. Y un \emph{Terminal} es un símbolo
o elemento del lenguaje (un \emph{Terminal} no hace referencia a una regla de producción). También se tiene un \emph{Terminal} 
especial denominado \textit{épsilon}, que significa que no produce nada.\\

Concretamente, una regla de producción consiste de un \emph{No-Terminal} en el lado izquierdo y un conjunto de producciones 
en el lado derecho. Las producciones del lado derecho de una regla pueden contener \emph{Terminales y No-Terminales}, si se tiene
dos o más producciones en el lado derecho, deben estar separadas por el símbolo `\verb?|?', que indica que es 
una producción alternativa.

Además, el lado izquierdo y derecho están separados por un símbolo `\verb?::=?' que significa que el \emph{No-Terminal}
de la izquierda genera las reglas de producción de la derecha.\\ 

A continuación se muestra la gramática de un lenguaje que produce palíndromos para los caracteres `a',`b' y `c':

\begin{desc}
\small
\input{024-ejemplo-ejemplo003}
\caption{Sintaxis concreta para palíndromos} \label{desc:scpal}
\end{desc}

La versión extendida de \bnf(\ebnf) añade características para hacer la gramática del lenguaje más legible:

\begin{itemize}
    \item \textbf{Paréntesis de Agrupación}\\
        Permite agrupar \emph{Terminales y No-Terminales} entre paréntesis.
    \item \textbf{Ocurrencia Opcional ($?$)}\\
        Hace que el símbolo al que se refiere tenga una ocurrencia de uno o cero.
    \item \textbf{Ocurrencia de Lista ($+$)}\\
        Hace que el símbolo al que se refiere tenga una ocurrencia de uno o más símbolos.
    \item \textbf{Ocurrencia de Lista ($*$)}\\
        Hace que el símbolo al que se refiere tenga una ocurrencia de cero o más símbolos.
\end{itemize}

Un símbolo puede ser tanto \emph{Terminales, No-Terminales o agrupaciones}.\\

\subsection{Ejemplo de sintaxis concreta y abstracta}

Para una mejor comprensión de la relación entre sintaxis concreta y abstracta se revisará en detalle el ejemplo 
de la \pref{desc:scpal}.\\

La gramática para la \pref{desc:scpal} sería:


%if showChanges
\color{blue}
%endif

\begin{desc}
\small
\input{022-ejemplo-ejemplo001}
\caption{Gramática para palíndromos}
\end{desc}

%if showChanges
\color{black}
%endif

La sintaxis abstracta es similar a la sintaxis concreta, pero sólo representa lo más importante de la sintaxis concreta.
Por ejemplo, para el caso de los palíndromos se puede usar el tipo |Char| de Haskell para representar `a', `b', `c'; 
se puede usar un constructor especial |NoPal| para representar \verb?épsilon?; Y para las distintas versiones de \verb?`a' Pal `a'?,
\verb?`b' Pal `b'?, \verb?`c' Pal `c'? se puede usar el tipo |Char| para el carácter que se repite en ambos lados 
y una referencia a otro palíndromo:

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
data Pal
    =  NoPal
    |  SimplePal    Char
    |  ComplexPal   Char Pal
\end{code}
\caption{Sintaxis Abstracta para la sintaxis concreta de palíndromos}
\end{hs}

%if showChanges
\color{black}
%endif

En el siguiente ejemplo se muestra la sintaxis abstracta para el palíndromo \verb?"cbaabc"?:

\begin{hs}
\small
\begin{code}
test1 = ComplexPal 'c' (ComplexPal 'b' (ComplexPal 'a' NoPal))
\end{code}
\caption{Ejemplo de sintaxis abstracta}
\end{hs}


\section{Lenguaje de Marcado genérico} \label{sec:lgenerico}

En está sección se definirá la sintaxis concreta y abstracta para un lenguaje de marcado genérico.\\

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gramática Concreta para un lenguaje de marcado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Sintaxis Concreta para un \lmarcado\ Genérico}

Un \lmarcado\ genérico es un lenguaje que utiliza marcas o etiquetas para estructurar un documento o texto. 
Éstas etiquetas no necesariamente corresponden a las etiquetas de \html, sino que también pueden ser 
etiquetas de \xml, de ahí su nombre genérico.\\

Las etiquetas del lenguaje genérico tienen una única restricción dentro del documento, 
que el nombre de la etiqueta de inicio sea el mismo que la etiqueta final (si es que tiene etiqueta final).\\

A continuación se presenta la sintaxis concreta para el lenguaje de marcado genérico:

\begin{desc}
\small
\input{025-ejemplo-ejemplo004}
\caption{\gconcreta\ para un lenguaje de marcado genérico (Fuente: Elaboración propia)} \label{desc:gmarcado}
\end{desc}

Con la sintaxis concreta de la \pref{desc:gmarcado} se puede describir el 
siguiente ejemplo de \html:

\begin{desc}
\small
\input{026-ejemplo-ejemplo005}
\caption{Ejemplo HTML} \label{desc:html1}
\end{desc}

%\subsubsection{Algunas notas con respecto a HTML y XHTML}
%HTML y XHTML además de definir casi el mismo \lmarcado, también definen un conjunto de
%etiquetas, donde cada etiqueta tiene un conjunto de atributos y un conjunto de elementos que pueden ser 
%hijos o descendientes.

%HTML y XHTML definen ese comportamiento a través de un \dtd\footnote{DTD: Document Type Definition}.
%Un \dtd\ define aspectos de la estructura y comportamiento de un elemento.\\

%En este proyecto no se está considerando los \dtd, ni tampoco el comportamiento que éstos definen.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gramática Abstracta para un lenguaje de marcado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Gramática Abstracta para el \lmarcado} \label{sec:srosa}

Revisando la bibliografía \cite{bird, hxt}, normalmente se utiliza una estructura \rosa\ para 
representar un \lmarcado (por ejemplo \textbf{HXT} (Haskell Xml Toolbox) utiliza 
una estructura \rosa\ llamada \textbf{NTree}\cite[cap.~2, p.~8]{hxt}). En este proyecto también se utilizará una estructura \rosa.\\

\vspace{2cm}

Una \fthkey{Rosadelfa} o \fthkey{Árbol Rosa}\cite[cap.~6, p.~167]{bird} es una estructura para describir árboles que 
tienen una ramificación múltiple, cada ramificación tiene un nodo, que es utilizado para guardar la información 
del árbol.\\

A continuación se muestra la implementación de una estructura Rosadelfa en Haskell:

\begin{hs}
\small
\begin{code}
data ArbolRosa
    = ArbolRosa Nodo [ArbolRosa]
    
data Nodo
    = NTag   Nombre Atributos
    | NTexto String

type Atributos = [(Nombre,Valor)]
type Nombre = String
type Valor  = String
\end{code}
\caption{Estructura Rosadelfa} \label{lhc:codrosa}
\end{hs}

En el tipo de dato |Nodo| del \pref{lhc:codrosa} se ha definido dos constructores: |NTag| y |NTexto|. 
El constructor |NTag| guarda el nombre y atributos de una etiqueta y el nodo |NTexto| sólo guarda el texto (|String|).\\

Antes de representar el ejemplo \html\ del \pref{desc:html1}, considere el siguiente gráfico:

\begin{figure}[H]
\begin{center}
    \scalebox{0.3}{\includegraphics{063-figura-figura006.png}}
\end{center}
\caption{Gráfico representativo de un árbol rosa} \label{img:rosa}
\end{figure}

Cada rectángulo en la \pref{img:rosa} es un |ArbolRosa| y las líneas dirigen a cada elemento de una lista de 
\textit{Árboles Rosa} (Porque la estructura dice que un |ArbolRosa| contiene un |Nodo| y una lista de \textit{árboles Rosa)}.

Así, una etiqueta especial como el |img|, es un Árbol Rosa, con la diferencia de que no tiene ramificaciones;
un |texto|, también es un Árbol Rosa, que tampoco tiene ramificaciones. Se debe notar que la diferencia entre 
una |etiqueta| y un |texto| está en el tipo de nodo.\\

A continuacion se muestra la representación de la \pref{desc:html1} 
en el \pref{lhc:exhs}.

\begin{hs}
\small
\begin{code}
texto1 :: ArbolRosa
texto1 = ArbolRosa (NTexto "Ejemplo 1: El Saludo") []

texto2 :: ArbolRosa
texto2 = ArbolRosa (NTexto "Hola Mundo Cruel.") []

title :: ArbolRosa
title = ArbolRosa (NTag "title" []) [texto1]

jead :: ArbolRosa
jead = ArbolRosa (NTag "head" []) [title]

p :: ArbolRosa
p = ArbolRosa (NTag "p" [("name","saludo")]) [texto2]

img :: ArbolRosa
img = ArbolRosa (NTag "img" [("src","saludo.png")]) []

body :: ArbolRosa
body = ArbolRosa (NTag "body" []) [p, img]

html :: ArbolRosa
html = ArbolRosa (NTag "html" []) [jead, body]
\end{code}
\caption{Ejemplos de arboles rosa} \label{lhc:exhs}
\end{hs}


\section{Lenguaje para hojas de estilos CSS} \label{sec:lcss}

En está sección se definirá la sintaxis concreta y abstracta para CSS.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gramática Concreta para CSS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Sintaxis Concreta para \acss} \label{sec:sgcss}

\css\cite{css21}, que traducido al castellano es \cssc, es un lenguaje de hojas de estilos que 
permite a los usuarios adjuntar un estilo para documentos estructurados (como ser \html, \xml).\\

La especificación de \acss\cite{css21} define la sintaxis para el lenguaje de estilos de CSS, su sintaxis es amplia
y con soporte para versiones anteriores. 
En este proyecto sólo se considera la parte central de CSS, cuya sintaxis se define en la \pref{desc:gcss}
(note que no se considera todas las declaraciones de \textit{pseudo-selectores}, 
ni tampoco las declaraciones de \textit{charset, import, media y page}).

\begin{desc}
\small
\input{027-ejemplo-ejemplo006}
\caption{\gconcreta\ para CSS (Fuente: Elaboración propia)} \label{desc:gcss}
\end{desc}

La sintaxis de la \pref{desc:gcss} corresponde al núcleo de \acss. La parte que no 
está especificada en esta sintaxis es la parte de la |Declaracion|.
Porque cada propiedad de \acss\ tiene su propia sintaxis para
el valor de la propiedad. Se tratará esta parte con más detalle en el \pref{chp:parsercss}.
Sin embargo, la estructura general de una |Declaracion| no cambia.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gramática Abstracta para CSS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Sintaxis Abstracta para \acss}\label{sec:gcCSS}

La \gabstracta para CSS se deriva casi directamente de la \gconcreta de la \pref{desc:gcss}.
En esta sección, se presentará, parte por parte, los tipos de datos para la sintaxis abstracta de CSS.\\

Viendo la \gconcreta, se puede decir sencillamente que una |Hoja de Estilo| es una lista de |Reglas| y que cada
|Regla| tiene \textit{Selectores y Declaraciones}.

Sin embargo, la especificación de CSS define el modelo en Cascada (\pref{sec:mcascada}) a través de 3 tipos
y 3 orígenes de las hojas de estilo.
De manera que una |Regla| tiene un tipo y origen determinado.

Entonces, se inicia definiendo el |Tipo| y |Origen| en la parte de |Regla|, porque un documento estructurado 
puede tener una |Hoja de Estilo| que está compuesto de varios tipos y orígenes.

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
type HojaEstilo = [Regla]

type Regla = (Tipo, Origen, Selectores, Declaraciones)

data Tipo = HojaExterna | HojaInterna | EstiloAtributo
    deriving Show

data Origen = UserAgent | User | Author
    deriving Show
\end{code}
\caption{\gabstracta\ para \acss, regla, tipo y origen}
\end{hs}

%if showChanges
\color{black}
%endif


Por otro lado, también se tiene la lista de selectores, donde cada |Selector| puede ser |Simple| o |Compuesto|. 
Así un |Selector Compuesto| es una lista de 2 o más selectores simples separados por un operador 
(ese operador es almacenado en un tipo de dato |String| de Haskell).

Si es un |Selector Simple|, puede ser un Selector Tipo (|TypeSelector|), que tiene |Nombre|, |Atributos| y |PseudoSelector|,
o también puede ser un Selector Universal (|UnivSelector|) que también puede tener |Atributos| o un |PseudoSelector|, pero
no puede tener |Nombre|.

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
type Selectores = [Selector]

data Selector
    =   SimpSelector    SSelector
    |   CompSelector    SSelector Operador Selector
    deriving Show

type Operador = String

data SSelector
    =   TypeSelector    Nombre  Atributos Pseudo
    |   UnivSelector            Atributos Pseudo
    deriving Show

type Nombre = String
\end{code}
\caption{\gabstracta\ para \acss, selectores}
\end{hs}

%if showChanges
\color{black}
%endif

Para la parte de los atributos, \acss dice que el atributo \verb?.nombreClase? corresponde a un atributo tipo operador 
\verb?[class ~= "nombreClase"]?, entonces sólo se tiene 3 tipos de atributos, estos son:

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
type Atributos = [Atributo]

data Atributo
    =   AtribID         ID
    |   AtribNombre     Nombre
    |   AtribTipoOp     Nombre TipoOp AtributoValor
    deriving Show

type ID             = String
type TipoOp         = String
type AtributoValor  = String
\end{code}
\caption{\gabstracta\ para \acss, atributos} \label{lhc:attr}
\end{hs}

%if showChanges
\color{black}
%endif

Los |Pseudo| selectores, que aparecen al final de un selector simple, se encargan de 
marcar a un selector como |PseudoSelector|. 

Para su representación se utiliza el tipo |Maybe| de Haskell, el cual guarda la información en el 
constructor |Just| y utiliza |Nothing| para referirse a la no existencia de la información.

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
type Pseudo = Maybe PseudoElemento

data PseudoElemento
    =   PseudoBefore
    |   PseudoAfter
    deriving Show
\end{code}
\caption{\gabstracta\ para \acss, pseudo selectores}
\end{hs}

%if showChanges
\color{black}
%endif

Y por último las |Declaraciones|, cada declaración es simplemente una declaración de propiedad de \acss.
Entonces las declaraciones son simplemente una lista declaración con nombre, valor e importancia.\\

Cada |Declaracion| tiene un |Nombre| de propiedad (|String|), un |Valor| asignado y un 
nivel de |Importancia| (|Bool|).

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
type Declaraciones = [Declaracion]

data Declaracion
    = Declaracion Nombre Valor Importancia
    deriving Show

type Nombre       = String
type Importancia  = Bool

data Valor
     =  NumeroPixel     Float
     |  NumeroPoint     Float
     |  NumeroEm        Float
     |  Porcentage      Float
     |  ValorClave      String
     |  ValorString     String
     |  NoEspecificado
     deriving Show
\end{code}
\caption{\gabstracta\ para \acss, declaraciones}
\end{hs}

%if showChanges
\color{black}
%endif

Así como se mencionó anteriormente, esta sintaxis corresponde a la parte central de \acss. La otra parte que no
está detallado aquí son las más de 80 propiedades de CSS.

Cada propiedad de CSS define su propia sintaxis para asignar su valor, de manera que, cada sintaxis de una 
propiedad define sus propias palabras claves, números y valores. 
La forma en que se representa esta parte, es definiendo valores genéricos para cada propiedad.\\

Por ejemplo, la especificación de CSS define la propiedad \textbf{font-size} 
de la siguiente manera:

\begin{desc}
\small
\begin{verbatim}
'font-size'
	Value           : <absolute-size> |  <relative-size> | <length> 
                        | <percentage>    |  inherit
	Initial         : medium
	Applies to      : all elements
	Inherited       : yes
	Percentages     : refer to inherited font size
	Media           : visual
	Computed value  : absolute length

<absolute-size> ::=  xx-small   |   x-small | small | medium | large 
                    | x-large   |   xx-large

<relative-size>  ::= larger | smaller
<length>         ::= pixel  | point | em
<percentage>     ::= Number%
<pixel>          ::= Number`px'
<point>          ::= Number`pt'
<em>             ::= Number`em'
\end{verbatim}
\caption{Propiedad font-size de CSS (Fuente: Especificación de la propiedad font-size de CSS)} \label{lst:fz}
\end{desc}

Ésta propiedad indica que el valor para `font-size' puede ser |absoluto|, |relativo|, |length|, |porcentage| o la
palabra clave `inherit'. Además, |absoluto| y |relativo| definen su propio conjunto de palabras clave. También se tiene
que los |porcentajes| y números |length| pueden ser |Pixel|, |Point| o |Em|.\\

La forma de representar los valores de la propiedad `font-size' es:
\begin{itemize}
    \item se utiliza el constructor \textbf{PalabraClave String} para todas las palabras claves de la sintaxis 
          (\textit{inherit, small, medium, large, larger, smaller}, etc)
    \item se utiliza el constructor \textbf{Porcentage Float} para representar todos los número porcentaje.
    \item y para los otros números se utiliza el constructor \textbf{NumeroPixel Float, NumeroPoint Float, NumeroEm Float}.
\end{itemize}

La sintaxis de todas la propiedades se describirán o implementarán a nivel del parser para cada propiedad.
Se hablará más de este tema en los capítulos posteriores.

