\documentclass[11pt]{article}

%include polycode.fmt

\usepackage[left=2.5cm,top=2cm,right=2cm,bottom=2.5cm]{geometry}
\usepackage[utf8]{inputenc}
\usepackage[spanish]{babel}
\usepackage{graphics}
\usepackage{float}
\usepackage{prettyref}
\usepackage{color}
% \usepackage{xspace}
\usepackage[pdftex,bookmarks=true,colorlinks=false]{hyperref}
%\usepackage{bookmark}

\newcommand{\pref}[1]{\prettyref{#1}}
\newrefformat{lhc}{Código~Haskell~\ref{#1}}
\newrefformat{lac}{Código~UUAGC~\ref{#1}}
\newrefformat{desc}{Descripción~\ref{#1}}
\newrefformat{sec}{Sección~\ref{#1},~página~\pageref{#1}}
\newrefformat{apd}{Apéndice~\ref{#1}}
\newrefformat{chp}{Capítulo~\ref{#1}}
\newrefformat{img}{Figura~\ref{#1}}

\newfloat{hs}{H}{lhc}
\floatname{hs}{Código Haskell}

\newfloat{ag}{H}{lac}
\floatname{ag}{Código UUAGC}

\floatstyle{ruled}
\newfloat{desc}{H}{ldt}
\floatname{desc}{Descripción}


\title{ \large \huge {Desarrollo de Navegador Web con Haskell} }
\author{
    {\textbf{Carlos Gomez}}\\
    {\small Universidad Mayor de San Simón, Facultad de Ciencias y Tecnología}\\
    {\small Cochabamba, Bolivia}\\
    {\small @carliros.g at gmail.com@}
    }
\date{}
\begin{document}
\maketitle

\begin{abstract}

%Este articulo es un resumen del desarrollo de un proyecto, en el cual se ha implementado
%un Navegador Web utilizando el lenguaje de programación funcional Haskell.

Este articulo describe el desarrollo de un Navegador Web, en cual se ha utilizado el lenguaje de 
programación funcional Haskell.\\

El desarrollo consiste, básicamente, en aplicar un conjunto de transformaciones a una entrada, hasta obtener
una salida renderizable para la pantalla de un computador.
\newline
La entrada se encuentra descrita en una versión simple de un lenguaje de marcado como HTML/XHTML
y las transformaciones principales que se aplican son: \textit{procesar el árbol del documento 
de entrada, procesar la estructura de formato de fase 1 y 2, y finalmente renderizar el resultado
obtenido.}\\

Como resultado del desarrollo, se ha obtenido un Navegador Web con soporte de un sub-conjunto de la
gramática de XHTML y CSS, y de 48 propiedades de CSS.\\

A pesar de que normalmente se utilizan, para el desarrollo de este tipo de programas,
lenguajes convencionales e imperativos, Haskell ha sido de bastante utilidad, beneficiando
al proyecto con varias de sus características, entre las más importantes: código modular,
funciones de alto-orden, evaluación no estricta y emparejamiento de patrones.\\


\textbf{Palabras clave:} Navegador Web (Web Browser), Programación Funcional, Haskell,
Renderización, XHTML, CSS.
\end{abstract}

\section{Introducción}
Un Navegador Web es un programa informático del lado del cliente, que se encarga de
renderizar documentos que pueden estar hospedados tanto en la Internet o en la misma
computadora\cite{sebesta}. Los actuales Navegadores Web (ej. Firefox, Google Chrome, Internet Explorer,
Opera, etc.) son programas gigantes, porque dan soporte a una amplia cantidad de funcionalidad
(ej. HTML, XHTML, CSS, DOM, JavaScript, Flash, etc.). El desarrollo de un proyecto gigante
(Navegador Web) normalmente tiene un alto costo de desarrollo, de manera que la elección del
lenguaje de programación para el desarrollo, es una decisión importante para el éxito del proyecto.\\

En los actuales Navegadores Web se ha utilizado lenguajes de programación imperativa (C++,
Java, C), lo cual demuestra que viendo el rendimiento y funcionalidad implementada, los lenguajes
de programación imperativa realizan un buen trabajo en el desarrollo de estos programas gigantes.
\newline
Por otro lado, los lenguajes de programación funcional (ej. Haskell) incorporan muchas de las innovaciones
recientes del diseño de lenguajes de programación\cite{haskell98}, de manera que pueden colaborar a reducir los
costos de desarrollo de un programa.\\

De esa manera, en este proyecto, se ha pretendido experimentar las capacidades/características, librerías y
herramientas del lenguaje de programación funcional Haskell en el desarrollo de un Navegador Web.\\

En las siguientes secciones de este documento, primeramente se describirá el desarrollo del proyecto, 
luego se mencionará los resultados obtenidos, conclusiones, limitaciones y finalmente se dará 
a conocer las recomendaciones para trabajos futuros.

\section{Desarrollo del Proyecto}

La principal tarea de un Navegador Web es mostrar un documento de texto en la pantalla de un computador. 
Esta tarea es conocida como la renderización o el proceso de renderización que sigue un conjunto de normas
o reglas definidas en la especificación de CSS.\\

El proceso de renderización definido en el proyecto, básicamente, es realizado aplicando un conjunto de transformaciones a la 
entrada, hasta obtener un formato visual en la pantalla. La siguiente figura muestra las principales
transformaciones, donde cada rectángulo representa una transformación junto con sus principales tareas.

\begin{figure}[H]
    \begin{center}
        \scalebox{0.3}{\includegraphics{graphics/transformTree.jpg}}
    \end{center}
    \caption{Transformaciones principales para renderización} \label{img:trans}
\end{figure}

En esta sección se describirá, a grandes rasgos, la forma en que se ha desarrollado la principal tarea de un
Navegador Web.
\newline
Para lo cual, primeramente se comentará sobre las principales herramientas y librerías utilizadas en el proceso
de desarrollo, luego se detallará varias estructuras, modelos y tipos de datos desarrollados para el proyecto, y 
finalmente se describirá en mas detalle el proceso de renderización.

\subsection{Principales Herramientas y Librerías}

Las principales herramientas y librerías utilizadas en el proceso de desarrollo del proyecto son:

\begin{itemize}
    \item \textbf{Librería uu-parsinglib\cite{uuplib}:} Es una librería EDSL (Embeded 
    Domain Specific Language) para Haskell que permite implementar el parser para la gramática 
    de un lenguaje a través de una descripción similar a la gramática concreta de un 
    lenguaje\cite{cp-tut,uuplib}. Con esta librería se ha implementado el parser para XHTML, 
    CSS y valores de propiedades.
    \item \textbf{Herramienta UUAGC\cite{uuagclib}:} Es una herramienta que genera código Haskell 
    a través de una descripción de gramática de atributos de un comportamiento. Se ha utilizado 
    esta herramienta para la especificación del comportamiento de la mayor parte del proyecto.
    \item \textbf{Librería WxHaskell\cite{wxhaskell}:} Es una librería para Haskell que permite 
    implementar la Interfaz Gráfica de Usuario (GUI) de un programa. Esta librería ha sido utilizada 
    para implementar toda la parte gráfica del proyecto.
    \item \textbf{Librería libcurl\cite{curl}:} Es una librería para Haskell que permite interactuar con los
    protocolos de red, tales como HTTP, File, FTP, etc. Esta librería ha permitido obtener
    todos los recursos de la Web (archivos HTML, archivos de Hojas de Estilo de CSS e
    imágenes) a través de una dirección URL.
    \item \textbf{Estructura Map:} La estructura Map es parte de la librería Containers\cite{} de Haskell. Esta
    estructura permite almacenar elementos de tipo clave-valor, y provee un conjunto de
    funciones eficientes para manipular los elementos almacenados. Esta estructura es
    utilizada para almacenar la lista de propiedades de CSS.
\end{itemize}

\subsection{Estructuras principales de transformación}

\subsubsection{Estructura NTree}
La estructura |NTree| es una estructura rosadelfa\cite{bird} que guarda la información de los elementos de HTML en los nodos.
Se tiene 2 tipos de nodos: |NTag|, que guarda el nombre, tipo(|replaced|) y atributos del elemento. 
El nodo |NText| que se utiliza para representar cualquier texto dentro de un elemento. A continuación se muestra los tipos de datos
que representan la estructura |NTree|, las cuales están descritas utilizando la herramienta UUAGC.

%\begin{ag}
{
\small
\begin{code}
DATA NTree
    | NTree Node ntrees: NTrees

TYPE NTrees = [NTree]

DATA Node
    | NTag   name       : String    
             replaced   : Bool       
             atribs     : {Map.Map String String}
    | NText  text     : String
\end{code}
%\end{ag}
}
\begin{center}Código UUAGC 1: Tipo de dato NTree (estructura rosadelfa)\end{center}

\subsubsection{Estructura de Formato de Fase 1}
Esta estructura es similar a la estructura |NTree|, la diferencia esta en que no utiliza nodos
para guardar la información. Además, esta estructura guarda información sobre el contexto de un
elemento, por ejemplo, si se tiene el elemento |div| de HTML, su contexto de formato seria bloque,
pero si fuera el elemento |span|, su contexto seria en linea.
\newline
Los elementos con contexto en bloque son acomodados verticalmente uno debajo del otro, pero los
elemento con contexto en linea, son acomodados horizontalmente uno seguido del otro.
A continuación se muestra los tipos de datos para la Estructura de Formato de Fase 1.

{
%\begin{ag}
\small
\begin{code}
DATA BoxTree
  | BoxContainer    name    : String
                    fcnxt   : {FormattingContext}
                    props   : {Map.Map String Property}
                    attrs   : {Map.Map String String}
                    bRepl   : Bool
                    boxes   : Boxes
  | BoxText     name    : String
                props   : {Map.Map String Property}
                attrs   : {Map.Map String String}
                text    : String

TYPE Boxes = [BoxTree]

DATA FormattingContext
  | InlineContext | BlockContext | NoContext
\end{code}
%\end{ag}
}
\begin{center}Código UUAGC 2: Tipo de dato FSTreeFase1 (Estructura de Formato de Fase 1)\end{center}

\subsubsection{Estructura de Formato de Fase 2}
De igual manera, esta estructura es similar a la anterior, porque almacena casi la misma información.
Sin embargo, a este nivel, los elementos se guardan de acuerdo al contexto de formato,
es decir, en lineas o bloques. Además, cada elemento puede ser separado en partes, y se utiliza 
el tipo |TypeContinuation| para indicar la parte a la que pertenece.

{
%\begin{ag}
\small
\begin{code}
DATA WindowTree
  | WindowContainer     name    : String
                        fcnxt   : {FormattingContext}
                        props   : {Map.Map String Property}
                        attrs   : {Map.Map String String}
                        tCont   : {TypeContinuation}
                        bRepl   : Bool
                        elem    : Element
  | WindowText  name    : String
                props   : {Map.Map String Property}
                attrs   : {Map.Map String String}
                tCont   : {TypeContinuation}
                text    : String

DATA TypeContinuation 
  | Full  | Init  | Medium | End

DATA Element
  | EWinds winds: WindowTrees
  | ELines lines: Lines
  | ENothing

TYPE WindowTrees = [WindowTree]

TYPE Lines       = [Line]

DATA Line
  | Line winds: WindowTrees
\end{code}
%\end{ag}
}
\begin{center}Código UUAGC 3: Tipo de dato FSTreeFase2 (Estructura de Formato de Fase 2)\end{center}


\subsection{Hojas de Estilo en Cascada (CSS)}
Uno de los documentos importantes para el proyecto fue la especificación de CSS\cite{css21}, la cual
provee varios modelos para renderización, un lenguaje para hojas de estilos y varias propiedades
de CSS.

\subsubsection{Modelo en Cascada}
Uno de los modelos de CSS es el de cascada, que define 3 tipos de usuarios (Origen) y 3 tipos de hojas 
de estilo (Tipo).

{
%\begin{ag}
\small
\begin{code}
DATA Origen
  | UserAgent | User | Author

DATA Tipo
  | HojaExterna | HojaInterna | EstiloAtributo
\end{code}
%\end{ag}
}
\begin{center}Código UUAGC 4: Tipos de datos para representar el modelo en cascada de CSS\end{center}

\subsubsection{Lenguaje para Hojas de Estilo}
CSS también provee un lenguaje para especificar las hojas de estilo.
A continuación se muestra los tipos de datos para representar el lenguaje para las hojas de estilo.

{
%\begin{ag}
\small
\begin{code}
TYPE HojaEstilo = [Regla]

TYPE Regla = (Tipo, Origen, Selector, Declaraciones)

DATA Selector
  |  SimpSelector    SSelector
  |  CompSelector    SSelector  operador: String    Selector

DATA SSelector
  |  TypeSelector    nombre: String     Atributos   MaybePseudo
  |  UnivSelector Atributos MaybePseudo

TYPE Atributos = [Atributo]

DATA Atributo
  |  AtribID      id: String
  |  AtribNombre  nombre: String
  |  AtribTipoOp  nombre, op, valor : String

TYPE MaybePseudo = MAYBE PseudoElemento

DATA PseudoElemento
  |  PseudoBefore   |  PseudoAfter

TYPE Declaraciones = [Declaracion]

DATA Declaracion 
  | Declaracion nombre: String Value importancia: Bool

DATA Value
  | PixelNumber   Float
  | Percentage    Float
  | KeyValue      String
  | KeyColor      rgb: {(Int,Int,Int)}
  ...
  | NotSpecified
\end{code}
%\end{ag}
}
\begin{center}Código UUAGC 5: Tipos de datos para el lenguaje de hojas de estilo\end{center}

\subsubsection{Propiedades de CSS}
Existe casi como 80 propiedades de CSS que se utilizan para la renderización
en la pantalla, las cuales se encuentran descritas en la especificación de CSS.
\newline
En el proyecto, se ha definido el tipo de dado |Property| para representar una propiedad de CSS.

{
%\begin{hs}
\small
\begin{code}
data Property  = Property   { name              :: String
                            , inherited         :: Bool
                            , initial           :: Value
                            , value             :: Parser Value
                            , propertyValue     :: PropertyValue
                            , fnComputedValue   :: FunctionComputed
                            , fnUsedValue       :: FunctionUsed }
\end{code}
%\end{hs}
}
\begin{center}Código Haskell 1: Tipo de dato Property para representar un propiedad de CSS\end{center}

El tipo de dato |Property| permite representar una propiedad de CSS casi de forma
plana y directa, porque permite detallar casi todos los valores que la especificación de
CSS requiere, incluyendo el parser y las funciones para procesar los valores |computed| y |used| 
de una propiedad.

\subsubsection{Valores de una Propiedad de CSS}
La especificación de CSS define 4 tipos de valores para un propiedad:

\begin{itemize}
    \item \textbf{SpecifiedValue:} corresponde al valor especificado en las
    hojas de estilo. Es calculado utilizando el algoritmo cascada de CSS.
    \item \textbf{ComputedValue:} es el valor listo para ser heredado por
    otras propiedades. Es calculado utilizando la función |fnComputedValue| (Código Haskell 1)
    de cada propiedad.
    \item \textbf{UsedValue:} es el valor sin ningún tipo de dependencias y listo para ser renderizado.
    Es calculado utilizando la función |fnUsedValue| (Código Haskell 1) de cada propiedad.
    \item \textbf{ActualValue:} es el valor que no tiene dependencias de ninguna librería.
    En el proyecto aun no se esta utilizando este valor.
\end{itemize}

Estos valores son representados en Haskell a través de tipo de dato |PropertyValue|:

{
%\begin{hs}
\small
\begin{code}
data PropertyValue
  = PropertyValue   { specifiedValue    :: Value
                    , computedValue     :: Value
                    , usedValue         :: Value
                    , actualValue       :: Value }
\end{code}
%\end{hs}
}
\begin{center}Código Haskell 2: Tipo de dato PropertyValue para representar los valores de una propiedad\end{center}

Los 4 valores de una propiedad son calculados en el proceso de renderización. Por ejemplo,
los valores |specified| y |computed| son calculados al procesar el |NTree| y el valor |used|
es calculado al procesar la estructura de formato de fase 1.

\subsubsection{Definición de Propiedades}
En el proyecto se da soporte a varias propiedades de CSS, que son definidas utilizando el
tipo de dato |Property|.
Por ejemplo, la forma de definir la propiedad \textit{border-top-color}
seria de la siguiente manera:

{
%\begin{hs}
\small
\begin{code}
bc = Property   {  name = "border-top-color"
                ,  inherited = False
                ,  initial = NotSpecified
                ,  value = pBorderColor
                , propertyValue = PropertyValue     {  specifiedValue   = NotSpecified
                                                    ,  computedValue    = NotSpecified
                                                    ,  usedValue        = NotSpecified
                                                    ,  actualValue      = NotSpecified }
                , fnComputedValue = computed_border_color
                , fnUsedValue     = used_asComputed 
                }
pBorderColor 
    = pColor <|> pKeyValues ["inherit"]
computed_border_color iamtheroot fatherProps locProps iamreplaced iamPseudo nm prop
    =  case specifiedValue prop of
        NotSpecified 
            -> specifiedValue (locProps `get` "color")
        KeyColor (r,g,b) 
            -> KeyColor (r,g,b)
\end{code}
%\end{hs}
}
\begin{center}Código Haskell 3: Ejemplo de definición de la propiedad \textit{border-top-color}\end{center}


\subsection{Diagrama de renderización}

La \pref{img:diag}, muestra el diagrama de renderización, que contiene las 3 principales
transformaciones de la \pref{img:trans}.\\

Este diagrama de renderización inicia con el circulo llamado `\textit{Program init}', el cual
representa la Interfaz Gráfica de Usuario (GUI) del programa.
\newline
A través del GUI se inicia el proceso de renderización, como también el proceso de redimensionamiento,
el cual no necesita realizar todos los pasos de renderización sino sólo los necesarios.\\ 

A continuación se describe las principales tareas del diagrama de renderización.

\begin{itemize}
    \item \textit{Obtener Documentos:} para renderizar documentos, primeramente se obtienen todos
    los documentos (archivos HTML) y recursos (hojas de estilo e imágenes) ya sea de la internet o 
    de la misma computadora. En esta parte, se
    utiliza la librería libcurl junto con la dirección URL del documento.
    \item \textit{Parser HTML:} luego se procede a parsear el documento obtenido y generar, como 
    resultado, una estructura rosadelfa (NTree) que represente el documento.
    \item \textit{Procesar NTree:} esta parte contiene varias tareas, principalmente se construye
    la lista de propiedades de CSS y se genera la estructura de formato de fase 1.
    \item \textit{Procesar Estructura de Formato de Fase 1:} en esta parte, básicamente se construyen
    líneas de elementos y se genera una estructura de formato de fase 2.
    \item \textit{Procesar Estructura de Formato de Fase 2:} en esta parte, se genera posiciones
    y dimensiones para la renderización de los elementos y también se genera una función de renderización 
    parcial de todos los elementos.
    \item \textit{Renderización:} es aquí donde se renderizan todas las propiedades de CSS
    de un elemento, por ejemplo en esta parte se dibujan los bordes, se asignan colores y se pinta 
    el texto.
\end{itemize}

\begin{figure}[H]
    \begin{center}
        \scalebox{0.375}{\includegraphics{graphics/diagr.jpg}}
    \end{center}
    \caption{Diagrama de renderización} \label{img:diag}
\end{figure}


\section{Resultados}
Como resultado, se ha obtenido un Navegador Web con Haskell denominado ``Simple San Simon
Functional Web Browser'', que tiene soporte para las siguientes características:

\begin{itemize}
    \item Soporte para trabajar con los protocolos HTTP y File.
    \item Soporte para un sub-conjunto de la gramática de XHTML y XML. Se ha desarrollado
    un parser genérico que permite reconocer cualquier nombre de etiqueta.
    \item Soporte para un sub-conjunto de la gramática para el lenguaje de hojas de estilos
    de CSS.
    \item Soporte para 48 propiedades de CSS, que incluye:
    \begin{itemize}
        \item Modificar la dimensión, posición, tipo y estilo de un elemento
        \item Modificar el estilo de un texto
        \item Listas
        \item Generación de contenidos 
    \end{itemize}
\end{itemize}

El GUI del proyecto permite modificar las hojas de estilo para |UserAgent| y |User|, y también
permite navegar sobre paginas ya visitadas.\\

Para más información, revisar: @http://hsbrowser.wordpress.com@.

\section{Conclusiones}
Se encontró que el lenguaje de programación funcional Haskell fue 
apropiado y maduro para el desarrollo de un Navegador Web.
Apropiado, porque varias partes de la implementación fueron expresadas de mejor manera 
utilizando mecanismos de la programación funcional. Y maduro, porque en muchos casos, 
simplemente se utilizó las librerías ya existentes para Haskell.\\

Sin embargo, también se ha tenido varias dificultades en la implementación de algunos
algoritmos, y algunas limitaciones de algunas librerías, las cuales se explican en la
sección de Limitaciones del Proyecto.

\subsection{Beneficios del lenguaje utilizado}
Al utilizar Haskell como lenguaje de desarrollo, el proyecto se ha beneficiado
con varias de sus características, entre ellas se tiene:

\begin{itemize}
        \item Forma rica de definir los tipos de datos. 
        Esto permite que el código sea fácil de entender y más expresivo. 
        \item Amplia Biblioteca de funciones de Haskell. 
        \item Varias formas de definir una función. Lo cual permite que el código sea 
        fácil de entender y expresivo.
        \item Aplicación parcial de funciones. Esta característica permitió construir funciones
        parcialmente definidas, de manera que fueron completadas en otro punto del proceso y solo
        cuando eran necesarias.
        \item Definición de módulos.
        Que permite que el código este organizado en módulos,
        donde cada modulo tiene funciones publicas para otros módulos.
\end{itemize}

\subsection{Beneficios de las herramientas y librerías}

Las Herramientas y Librerías utilizadas han jugado un rol importante en la simplificación
de la complejidad en el desarrollo del proyecto. A continuación se describe los beneficios
de las principales herramientas y librerías utilizadas:

\begin{itemize}
\item \textbf{Herramienta UUAGC}
\begin{itemize}
        \item Permite enfocarse en la resolución del problema.
        \item Código compacto (reglas de copiado de UUAGC).
        \item Generar código Haskell sólo de las partes que se necesita.
\end{itemize}

\item \textbf{Librería uu-parsingLib}
\begin{itemize}
        \item Permite que la gramática implementada sea robusta.
        \item Dar soporte a la ideología de implementar todo en Haskell.
\end{itemize}

\item \textbf{Librería wxHaskell}
\begin{itemize}
        \item Las variables de wxHaskell permitieron implementar el
        diagrama de renderización.
\end{itemize}
\end{itemize}

\section{Limitaciones del Proyecto}

Este proyecto corresponde simplemente a una pequeña parte de la amplia y compleja área de los
Navegadores Web.
En el proyecto se ha tenido varias limitaciones tanto en funcionalidad y librerías:

\begin{itemize}
    \item Limitaciones de funcionalidad: Por su complejidad, no se dio soporte a:
        \begin{itemize}
            \item Formularios, Tablas y Frames de HTML.
            \item Posicionamiento flotante, absoluto y fijo de CSS.
        \end{itemize}
    \item Limitaciones de la librería wxHaskell:
        \begin{itemize}
            \item En el sistema operativo Gnu/Linux, la librería wxHaskell no tiene
            soporte para el color transparente. 
            \item No se encontró una función de wxHaskell que permita saber
            si el cambio de la fuente de un texto tuvo éxito.
        \end{itemize}
\end{itemize}

A pesar de las limitaciones del proyecto, es apreciable y valórale como las características, 
librerías y herramientas de Haskell colaboraron a reducir los costos de desarrollo en el 
proyecto, permitiendo que el código sea modular, compacto y fácil de entender.

\section{Recomendaciones para Trabajos Futuros}

El trabajo presentado en este documento, puede ser extendido de varias maneras. 
A continuación se presenta algunas recomendaciones para trabajos futuros.

\begin{itemize}
        \item Parser de HTML/XHTML + DTD. Desarrollar un parser para HTML/XHTML que implemente
        el comportamiento definido por un DTD(Document Type Definition). 
        \item Extender el soporte para la especificación de CSS. Se puede dar soporte a:
                \begin{itemize}
                        \item Tablas
                        \item Posicionamiento flotante, absoluto y fijo
                        \item Más propiedades de CSS (sólo se implemento 48 de las 80 propiedades para la pantalla)
                \end{itemize}
        \item Delegar la tarea de dimensionamiento y posicionamiento a la librería gráfica, ya que actualmente
        este trabajo es realizado de manera manual.
        \item Optimizar los algoritmos de renderización del proyecto.
        \item Implementar JavaScript.
\end{itemize}



\bibliographystyle{plain}
\bibliography{ref}
\addcontentsline{toc}{chapter}{Referencias}

\end{document}
