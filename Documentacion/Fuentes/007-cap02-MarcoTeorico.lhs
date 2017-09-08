
%include lhs2TeX.fmt
\chapter{Marco Teórico}

%\section{Introducción}

En el presente capítulo se presentará los conceptos generales a utilizar en el desarrollo del proyecto,
los cuales permitirán tener un buen soporte teórico para el entendimiento de la misma.

\section{Conceptos Generales}

\subsection{El Internet}

El |Internet| es una colección inmensa de equipos conectados a una red 
de comunicación \cite[cap.~1, pag.~3]{sebesta}. Los equipos conectados
pueden ser |routers|, |switches|, |hubs|, |impresoras|, |computadoras|, etc.
La comunicación entre estos equipos es realizada gracias a un conjunto 
de protocolos denominado \textit{TCP/IP}.\\

El Internet simplemente permite la comunicación entre equipos
al rededor del mundo, sin embargo, una tecnología que la hizo mucho más
útil fue la aparición de la \textit{World Wide Web (WWW)}.

\subsection{La WWW o Web}

La |World Wide Web (WWW)| o simplemente la |Web|, es sistema de acceso a
documentos que permite a cualquier usuario, conectado a la Internet a través de
una computadora, buscar y recuperar documentos de una computadora que hace el servicio
de almacenar esos documentos.

En otras palabras, existe un usuario que juega el papel de |cliente| que necesita
un documento. Y también existe un |servidor| que almacena todos los documentos
que un cliente puede requerir.\\

Según \cite{html4}, la Web provee de 3 mecanismos para permitir la comunicación entre
cliente-servidor:
    \begin{enumerate}
        \item URL, un esquema de nombramiento uniforme para la localización de recursos/documentos
              en la Web.
        \item HTTP, un protocolo para acceder a los recursos/documentos en la Web.
        \item HTML, un lenguaje de marcado con hipertexto para la navegación entre los recursos
              de la Web.
    \end{enumerate}

La comunicación entre cliente-servidor es realizada utilizando el protocolo |HTTP|
el cual se encarga de comunicarse con el servidor a través del conjunto de protocolos
TCP/IP y de devolver un resultado al cliente.

En realidad, el cliente puede ser cualquier dispositivo electrónico o software
que utiliza el protocolo |HTTP| para buscar o recuperar documentos. Por ejemplo, el Navegador Web
es el cliente más utilizado por un usuario para buscar o recuperar documentos de la Web.\\

Los documentos que un cliente puede requerir pueden ser de distintos tipos 
(texto, imágenes, etc), pero el más común es el |hipertexto|, el cual es simplemente 
texto que contiene enlaces a otros documentos. El formato de un documento |hipertexto|
está definido por un lenguaje de marcado como: HTML, XHTML.\\

En conclusión, la Web es una colección amplia de documentos, de los cuales algunos están
conectados con enlaces. Esos documentos, que son proveídos por un Servidor Web, 
son comúnmente accedidos con un Navegador Web.

\subsubsection{HTTP}
HTTP, significa |Hypertext Tansfer Protocol|, es el protocolo que permite la comunicación 
cliente-servidor para obtener documentos \cite{httpbook}. El protocolo HTTP interactúa con los protocolos 
TCP/IP para ejecutar las operaciones entre cliente-servidor.\\

Las operaciones que HTTP provee son:
\begin{itemize}
    \item GET: permite al cliente recuperar un documento del servidor.
    \item PUT: permite al cliente almacenar un documento en el servidor.
    \item DELETE: permite al cliente eliminar un documento del servidor.
    \item POST: permite al cliente enviar información a una aplicación del servidor.
    \item HEAD: permite al cliente enviar solo las cabeceras de la respuesta al servidor.
\end{itemize}

En la siguiente figura se muestra un ejemplo del proceso de obtener una imagen para un 
cliente desde un servidor:

\begin{figure}[H]
    \begin{center}
        \scalebox{0.3}{\includegraphics{060-figura-figura004.jpg}}
    \end{center}
    \caption{Proceso de obtener una imagen con HTTP, Fuente: ``HTTP, The definitive guide'' (Brian Totty, s.f., cap. 1)} 
    \label{img:httpProceso}
\end{figure}


\subsubsection{URL}
El URL, significa |Uniform Resource Locator|, es la dirección específica que un recurso
o documento tiene en el servidor.
Por ejemplo, la dirección URL de la imagen que se obtiene del servidor en la \pref{img:httpProceso}
es: \verb?www.joes-hardware.com/specials/saw-blade.gif?. Con esa dirección URL, el usuario puede obtener
la imagen desde el servidor.\\

El formato de una dirección URL es:

\begin{desc}
\small

\begin{verbatim}
<protocolo>://<usuario>:<contrasenia>@<equipo>
           :<puerto>/<dirección>:<parámetros>?<consulta>#<sección>
\end{verbatim}

\caption{Formato de una dirección URL} \label{desc:url}
\end{desc}

No todos los campos de la \pref{desc:url} son necesarios para la URL, pero
los más importantes son: protocolo, equipo y dirección. El campo |protocolo| puede
ser: HTTP, File, FTP, etc. El campo |equipo| puede ser una dirección IP o también
una dirección IP textual del equipo. Y finalmente el campo \textit{dirección}
corresponde a la dirección del documento que se quiere obtener en el servidor.

\subsection{Navegador Web}

Un Navegador Web es un programa informático que se encarga de renderizar documentos.
Los tipos de documentos que puede renderizar depende del soporte con el que se ha implementado,
pero los más comunes son: HTML, texto e imágenes.

En su forma más simple, un Navegador Web puede trabajar con el protocolo File y renderizar páginas Web
que se encuentran en la misma computadora donde se ejecuta el programa. Pero normalmente trabaja
con varios protocolos, por ejemplo: HTTP, FTP.
Cuando el Navegador Web trabaja con el protocolo HTTP, el Navegador Web juega el papel de cliente en la
comunicación cliente-servidor. El usuario requiere un documento, luego el Navegador Web interactúa con
el servidor para obtenerlo y finalmente renderizarlo para el usuario.

\section{HTML/XHTML}

HTML/XHTML son lenguajes de marcado que describen la forma y esquema de los documentos que serán 
mostrados por un Navegador Web \cite{sebesta}.

Los documentos descritos por un lenguaje de marcado están compuestos de elementos y contenido.
Los elementos son descritos por las etiquetas de HTML/XHTML, los cuales son utilizados para 
delimitar partes del contenido. Por ejemplo, el elemento de párrafo es descrito por una etiqueta
de inicio `\verb?<p>?' y una etiqueta de fin `\verb?</p>?', de manera que todo lo que está encerrado
dentro de las etiquetas llega a formar parte del contenido del elemento.\\

Las etiquetas para un elemento tienen un formato especial. La etiqueta de inicio está compuesto
por 2 símbolos (\verb?<>?) y el nombre de la etiqueta. Por ejemplo, la etiqueta de inicio para 
el elemento de HTML es: \verb?<html>?. A diferencia de la etiqueta de inicio, la etiqueta de 
fin está compuesto de 3 símbolos (\verb?</>?) y el nombre de la etiqueta; por ejemplo, la etiqueta
de fin para el elemento HTML es: \verb?</html>?.\\

Existen 2 formas de definir un elemento: \textit{normal} y \textit{especial}. La forma normal 
es utiliza una etiqueta de inicio y otra de fin. Sin embargo, la forma especial solo utiliza
una etiqueta especial de inicio, es decir, no tiene una etiqueta de fin, ni tampoco tiene
contenido. Las etiquetas de inicio especiales son definidos con 3 símbolos (\verb?</>?) y el
nombre de la etiqueta. Por ejemplo, la etiqueta especial para el elemento IMG es: \verb?<img />?.\\

Opcionalmente, los elementos pueden contener definiciones de atributos. Básicamente, los 
atributos proveen información adicional para el Navegador Web \cite{sebesta}. Por ejemplo, 
la \pref{desc:srcIMG} muestra que el atributo `src' del elemento IMG provee la dirección 
URL del contenido:

\begin{desc}
\small
\begin{verbatim}
<img src = "image.jpg" />
\end{verbatim}
\caption{Atributo `src' del elemento IMG} \label{desc:srcIMG}
\end{desc}

El formato para especificar un atributo es: nombre del atributo, símbolo
`=' y contenido del atributo encerrado entre comillas.

\subsection{DTD}

Un DTD (|Document Type Definition|) define la estructura del documento para un lenguaje de marcado 
específico. Por ejemplo, HTML define 3 tipos de DTD:
    \begin{itemize}
        \item Strict
        \item Transitional
        \item Framed
    \end{itemize}


De manera general, el DTD para HTML/XHTML define varios grupos de elementos de los cuales los más 
importantes son: |inline| y |block|.
Los elementos |inline| son los que se renderizan horizontalmente uno seguido del otro; pero los de
|block| se renderizan verticalmente uno debajo del otro.
Por ejemplo, algunos elementos |block| son: |p, h1-h6, div, blockquote, etc|. De la misma manera, 
algunos elementos |inline| son: |big, small, em, img, etc|.

Otros grupos de elementos |inline| que define el DTD son: |fontstyle| (tt, i, b, big, small), 
|phrase| (em, strong, q, etc.), |special| (a, img, br).

\subsection{Árbol del documento}
El árbol del documento es una representación abstracta en forma de árbol de la información
que puede ser renderizada en un Navegador Web.

Por ejemplo, en la \pref{img:fightml} se muestra el árbol del documento de la \pref{desc:exhtml},
donde |text| representa el contenido de un elemento que contiene solo texto:

\begin{desc}
\small
\begin{verbatim}
<html>
    <head> 
        <style>
            p {color: red}
        </style>
    </head>
    <body>
        <p> texto1 </p>
        <p> texto2 </p>
    </body>
</html>
\end{verbatim}
\caption{Ejemplo de HTML} \label{desc:exhtml}
\end{desc}


\begin{figure}[H]
\begin{center}
    \scalebox{0.6}{\includegraphics{061-figura-figura004.jpg}}
\end{center}
\caption{Árbol del documento} \label{img:fightml}
\end{figure}

\section{La especificación de CSS} \label{sec:espCSS}

La especificación de CSS (|Cascading StyleSheet|) provee 3 cosas importantes:
    \begin{itemize}
        \item Modelo y Comportamiento para la renderización de un documento
        \item Lenguaje para hojas de estilo
        \item Propiedades de CSS
    \end{itemize}

\subsection{Modelo y Comportamiento}

A continuación se presenta los distintos modelos que la especificación de 
CSS define:

\subsubsection{Modelo en Cascada} \label{sec:mcascada}

La especificación de CSS define el modelo en Cascada, la cual permite definir las
hojas de estilo de 3 formas (o niveles) y por 3 tipos de usuario diferentes,
los cuales determinan el origen de donde proviene la hoja de estilo.\\


Las 3 formas de definición son:
\begin{enumerate}
    \item |Declaraciones de Estilo|.- Las declaraciones de estilo pueden encontrarse
    en el atributo `|style|' de un elemento. En el siguiente ejemplo se muestra
    las declaraciones de estilo del elemento |span|:
\begin{desc}
\small
\begin{verbatim}
    <span style = "font-size: 12pt; font-style: italic"> 
        contenido del elemento span
    </span>
\end{verbatim}
\caption{Declaraciones de Estilo en un atributo}
\end{desc}

    \item |Hojas de Estilo Internas|.- Las hojas de estilo son especificadas dentro (|interna|)
    del documento que se va a renderizar. Se utiliza el elemento |style| para especificar
    las hojas de estilo. En el siguiente ejemplo se muestra las hojas de estilo internas
    de un documento de HTML:
\begin{desc}
\small
\begin{verbatim}
<html>
    <head>
        <style>
            span { font-size: 12pt
                 ; font-style: italic
                 }
        </style>
    </head>
    <body>
        <p> 
            Esto es un <span>ejemplo</span>
            de hoja de estilo <span>interna.</span>
    </body>
</html>
\end{verbatim}
\caption{Ejemplo de Hojas de Estilo Internas}
\end{desc}

    \item |Hojas de Estilo Externas|.- Las hojas de estilo se encuentran en un archivo externo, 
    pero son especificadas en el documento a renderizar a través del elemento |link|.
    El siguiente ejemplo ilustra la forma de especificar las hojas de estilo externas:
\begin{desc}
\small
\begin{verbatim}
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="estilo.css"/>
    </head>
    <body>
        <p> 
            Esto es un <span>ejemplo</span>
            de hoja de estilo <span>interna.</span>
    </body>
</html>
\end{verbatim}
\caption{Ejemplo de Hojas de Estilo Externas}
\end{desc}
\end{enumerate}

Además de las 3 formas de definición de hojas de estilo, también existe 3 tipos 
de usuarios que pueden definir hojas de estilo en alguna de las 3 formas:
\begin{enumerate}
    \item |Author|. Hace referencia al creador del documento a renderizarse, el cual
    puede definir hojas estilos en cualquiera de las 3 formas.
    \item |User|. Hace referencia al usuario que interactua con el documento a través de un
    Navegador Web. Este tipo de usuario solo puede definir una hoja de estilo externa,
    la cual afectará la renderización final del documento en el Navegador Web.
    \item |User Agent|. Se refiere al Navegador Web. El Navegador Web tiene una hoja
    de estilo la cual es utilizada cuando los otros usuarios no definen una hoja de estilo.
\end{enumerate}

\subsubsection{Modelo de Procesamiento}

La especificación de CSS define un posible modelo de procesamiento de documentos que podría
ser adoptado por un Navegador Web. A continuación se muestra la secuencia de pasos que define
el modelo:

\begin{enumerate}
    \item Parsear el documento fuente y crear el árbol del documento.
    \item Identificar el tipo de media destino. Para el proyecto, el tipo de media siempre
    será la pantalla, porque los documentos son renderizados en la pantalla.
    \item Recuperar todas las hojas de estilo asociados con el documento y que son especificados
    para el tipo de media destino.
    \item Para cada elemento del árbol del documento, asignar un valor a cada propiedad que es
    aplicable al tipo de media destino.
    \item Generar la estructura de formato desde el árbol del documento.
    \item Convertir la estructura de formato al tipo de media destino. Para el proyecto, esto 
    implica renderizar la estructura de formato en la pantalla.
\end{enumerate}

\subsubsection{Algoritmo en Cascada para la asignación de valores a propiedades} \label{sec:acascada}

La especificación de CSS también define un algoritmo para la asignación de un valor
a una propiedad de CSS. El algoritmo es especificado como una secuencia de pasos:

\begin{enumerate}
    \item Encontrar las declaraciones de estilo que aplican al elemento y propiedad en cuestión.
    Las declaraciones aplican si el selector empareja con el elemento en cuestión.

    \item Ordenar la lista de declaraciones de acuerdo a la importancia (|normal| o |important|)
    y usuario (|Author, User, UserAgent|) en forma ascendente:
    \begin{enumerate}
        \item Declaraciones |UserAgent|
        \item Declaraciones |Normal| de |User|
        \item Declaraciones |Normal| de |Author|
        \item Declaraciones |Important| de |Author|
        \item Declaraciones |Important| de |User|
    \end{enumerate}

    \item Ordenar todas las declaraciones que tienen la misma importancia y usuario de acuerdo a la
    especificidad del selector.

    La especificidad de un selector es un número de 4 dígitos: |abcd|, donde |a=1, b=c=d=0| si se trata 
    de una declaración de estilo, caso contrario |a=0|, |b| es igual a la cantidad de atributos |ID|
    que aparecen en el selector, |c| es la cantidad de atributos diferentes a |ID|, y |d| es el 
    número de nombres de elementos que aparecen en el selector.

    \item Si aún no se puede determinar que declaración se va a utilizar, entonces se ordena de acuerdo
    al orden en que han sido especificados en la hoja de estilos fuente. El último que ha sido especificado
    es el que se selecciona.
\end{enumerate}

\subsubsection{Modelo de valores para las propiedades de CSS} \label{sec:mvalores}

CSS define 4 tipos de valores para cada propiedad de CSS:
\begin{itemize}
    \item \textit{specified-value}: Corresponde al valor especificado en las hojas de estilo. 
    El algoritmo en Cascada (\pref{sec:acascada}) se encarga de asignar un valor para este campo
    de la propiedad.
    \item \textit{computed-value}: Es un valor preparado para ser heredado por otras
    propiedades o elementos.
    \item \textit{used-value}: Se constituye en el valor que no tiene dependencias de otras propiedades de CSS.
    Por ejemplo, es aquí donde un valor con porcentaje es convertido a un valor concreto, es decir a un
    valor que no tiene porcentaje.
    \item \textit{actual-value}: Corresponde al valor sin ningún tipo de limitaciones.
    Por ejemplo, si por motivos de la librería gráfica, el Navegador Web no tiene soporte para una
    característica, entonces el valor para este campo de la propiedad es reemplazado por un valor
    por defecto.

    El \textit{actual-value} es el valor utilizado por un Navegador Web para la renderización.
\end{itemize}



\subsubsection{Modelo Box de CSS} \label{sec:mbox}

La especificación de CSS define el modelo Box, el cual es utilizado para representar todos los elementos
que se renderizan en el Navegador Web. Un Box es una caja rectangular compuesto de 4 áreas:

\begin{figure}[H]
    \begin{center}
        \scalebox{0.4}{\includegraphics{062-figura-figura005.png}}
    \end{center}
    \caption{Modelo Box de CSS}
\end{figure}

\begin{itemize}
    \item \verb?Content-Box?. Es el área donde se renderiza el contenido del |box|, éste puede ser
                              una imagen o también un texto. Sus dimensiones están fijadas por
                              las propiedades |width| y |height| de CSS.
    \item \verb?Padding-Box?. Es la distancia opcional que separa el \verb?content-box? del borde. La distancia
                              de separación es controlada por el conjunto de propiedades de |padding|.
    \item \verb?Border-Box?. Es el área opcional que representa el borde del |box|.
                             El ancho del \textit{Border-Box} es fijado por el conjunto de propiedades de |border|.
    \item \verb?Margin-Box?. Es el área opcional que representa el margen externo del |box|. 
                             El ancho del \textit{Margin-Box} es fijado por el conjunto de propiedades de |margin|.
\end{itemize}


\subsection{Lenguaje para hojas de estilos}

CSS también provee un lenguaje para describir las hojas de estilos de un documento que va a ser renderizado 
en un Navegador Web.

El capítulo 4 de la especificación de CSS \cite{css21} define la sintaxis y tipos de datos básicos del
lenguaje para las hojas de estilos de CSS.

\subsection{Propiedades de CSS} \label{sec:mprops}

Las propiedades de CSS se encargan de guiar la renderización de un documento en un Navegador Web.
CSS ha creado como 98 propiedades, que se aplican a distintos tipos de media destino. Por ejemplo,
para el tipo de media |visual| o |pantalla|, CSS ha definido como 76 propiedades.\\

Cada propiedad de CSS tiene un nombre, sintaxis para sus valores, un valor por defecto,
un conjunto de elementos a los cuales se aplica la propiedad, un campo para especificar
si la propiedad es heredable, un campo para indicar la forma de procesar los valores que
tienen porcentajes, un campo para indicar el tipo de media destino, y finalmente un campo
para indicar la forma de procesar el \textit{computed-value} de una propiedad.

Por ejemplo, a continuación se presenta la descripción de la propiedad \textit{font-size} de CSS:

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
\caption{Propiedad font-size de CSS, Fuente: Especificación de CSS}
\end{desc}

\section{Haskell}

Haskell, según \cite[p.~3]{haskell98}, es un Lenguaje de Programación Funcional puro, con evaluación perezosa 
y de propósito general que incorpora muchas de las innovaciones recientes del diseño de lenguajes de 
programación.\\

Haskell provee funciones de alto-orden, semántica no estricta, tipado polimórfico estático, tipos de
datos algebraicos definidos por el usuario, emparejamiento de patrones, listas por comprensión,
un sistema modular, un sistema monádico I/O, y un conjunto rico de tipos de datos primitivos que incluyen
listas, arrays, números enteros de precisión fija y arbitraria, y números de punto flotante.\\

Existe una amplia cantidad de librerías y herramientas para Haskell. Sin embargo, 3 de las principales
librerías y herramientas que se utiliza en el proyecto son:
\begin{itemize}
    \item Librería \textit{uu-parsinglib}\cite{uuplib}. Es una librería para Haskell que permite
    describir la gramática de un lenguaje. Ésta es utilizada para el analizador sintáctico 
    (Parser) del proyecto.
    En el \pref{apd:combinadoresbasicos} se tiene un tutorial básico para la utilización de la librería.
    \item Herramienta |UUAGC|\cite{uuagclib}. Es una herramienta que genera código Haskell a través de una 
    descripción de gramática de atributos del comportamiento. 
    Ésta es utiliza para la especificación del comportamiento de la
    mayor parte del proyecto. Se tiene un tutorial básico en el \pref{apd:agtutorial}.
    \item Librería |WxHaskell|\cite{wxhaskell}. Es una librería para Haskell que permite implementar
    la Interfaz Gráfica de Usuario de un programa. Ésta es utilizada para implementar la parte gráfica 
    del proyecto.
\end{itemize}

\section{Trabajos relacionados}

Uno de los documentos importantes para el proyecto es la especificación de CSS (\pref{sec:espCSS}), 
la cual detalla los aspectos más relevantes para la implementación de un Navegador Web. 

Sin embargo, no se encontró muchos documentos técnicos sobre la forma de implementación de la especificación
de CSS en los Navegadores Web actuales (Internet Explorer, Chrome).

\subsection{Firefox} \label{sec:firefox}

En la página de |David Baron| (Ingeniero en Desarrollo de Software de Firefox y miembro del W3C) se encontró
algunos vídeos y documentos técnicos que describen partes generales y algunas partes concretas sobre 
Firefox, uno de los Navegadores Web actuales que tiene varios años de desarrollo.\\

La forma de procesamiento de hojas de estilos de Firefox es realizada de forma optimizada, Firefox construye
un árbol lexicográfico de las reglas de estilo, lo cual sería interesante implementar en el proyecto.

\subsection{WWWBrowser}

También se encontró un proyecto de un Navegador Web (WWWWBrowser) implementado con Haskell utilizando la
librería gráfica |Fudgets| (Carlsson y Hallgren).\\

El proyecto WWWBrowser fue implementado por los años 90 y dio soporte para las versiones 2 y 3.2 de HTML
(actualmente HTML se encuentra en la versión 4 y queriendo avanzar a la versión 5).
Implementó la mayor parte de HTML incluyendo imágenes,
tablas y formularios. Utilizaron la librería |uuparsing| de la Universidad de Utrecht para el parser de
HTML y también utilizaron programación paralela para el cargado de múltiples imágenes.\\

Algo interesante del proyecto WWBrowser es que la renderización de un documento fue realizada utilizando
mecanismos de acomodación (|layout|) de la librería Fudget, es decir, que el posicionamiento y redimensionamiento
no fue realizado de forma manual, sino con las propias funciones de la librería |Fudgets|.

\subsection{HXT}

Existen varias librerías para Haskell que trabajan con XML/HTML, entre ellas, una de las más utilizadas
es la librería HXT (Haskell Xml Toolbox).\\

HXT tiene soporte para XML/HTML/XHTML y DTD. Su parser está implementado utilizando la librería |parsec|
de Haskell, también utiliza la librería |Arrow| para la implementación de la funcionalidad que provee
la librería.
\newline
Uno de los aspectos importantes de la librería HXT es su estructura |NTree| la cual utiliza varios tipos 
de nodos para almacenar varios tipos de información que es reconocida por el parser.

