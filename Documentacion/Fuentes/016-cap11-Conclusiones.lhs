
%include lhs2TeX.fmt

\chapter{Conclusiones y Recomendaciones} \label{chp:conclusiones}

%\section{Introducción}

% logre hacer el browser? que problemas tuve globalmente? lo funcional ayudo?

El objetivo general que se ha propuesto para este proyecto fue: \textit{Desarrollar un Navegador Web con el lenguaje 
de programación funcional Haskell}.\\

Los objetivos específicos que se persiguieron durante el desarrollo de este proyecto fueron:

\begin{itemize}
    \item \textit{Desarrollar el módulo de comunicación entre el Navegador Web y los Protocolos HTTP y modelo TCP/IP.}
    \item \textit{Desarrollar un intérprete de la información HTML.}
    \item \textit{Desarrollar los algoritmos que nos permitirán mostrar la información en la pantalla del Navegador Web.}
    \item \textit{Desarrollar la Interfaz Gráfica de Usuario (GUI).}
    \item \textit{Desarrollar un módulo  que de soporte a CSS (Style Sheet Cascade).}
\end{itemize}

Indirectamente, también se pretendió experimentar las capacidades del lenguaje funcional Haskell y sus herramientas
en el desarrollo de un Navegador Web.\\

Al final de todo este trabajo y como una conclusión general, se encontró que el lenguaje de programación funcional 
Haskell fue apropiado y maduro para el desarrollo de un Navegador Web. Fue apropiado porque varias partes de la implementación
fueron expresadas de mejor manera utilizando mecanismos de la programación funcional, y fue maduro porque en muchos casos
no se ha implementado nuevas librerías, sino simplemente se ha utilizado las ya existentes en el lenguaje.

Además, las herramientas y librerías utilizadas han jugado un rol importante en la simplificación de la 
complejidad en el desarrollo del proyecto.\\

A pesar de que normalmente se utilizan, para el desarrollo de este tipo de programas, lenguajes convencionales e imperativos,
Haskell ha sido de bastante utilidad, beneficiando al proyecto con varias de sus características, entre las más importantes: 
código modular, funciones de alto-orden, evaluación no estricta y emparejamiento de patrones.

Sin embargo, también se ha tenido varias dificultades en la implementación de algunos algoritmos, y 
algunas limitaciones de algunas librerías.\\






En las siguientes secciones se describirá todos estos puntos en más detalle.

\section{Presentación del proyecto}

Se ha desarrollado un Navegador Web con Haskell, el cual lleva por nombre: 
\textbf{Simple San Simon Functional Web Browser (3S-WebBrowser)}
en honor al nombre de la Universidad donde se inició el desarrollo y al paradigma utilizado
en el proyecto.

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{079-figura-figura022.jpg}}
\end{center}
\caption{Logotipo de 3S-WebBrowser} \label{img:logo}
\end{figure}

En la \pref{img:logo} se muestra el logotipo del proyecto. También se tiene una página Web
que contiene información actualizada del proyecto (\url{http://hsbrowser.wordpress.com}).

\subsection{Soporte de HTML/XHTML/XML}

El proyecto desarrollado tiene soporte para un subconjunto de la gramática del lenguaje HTML, XHTML y XML.
El parser genérico del proyecto le permite reconocer cualquier etiqueta, con la única restricción
de que el nombre de la etiqueta de inicio sea el mismo que la etiqueta final.\\

Gracias a CSS, el proyecto tiene soporte para:
\begin{itemize}
    \item Modificar las características de un elemento (box)
        \begin{itemize}
            \item Dimensiones
            \item Colores
            \item Estilos
            \item Tipo de |box| (|block|, |inline|)
            \item Posiciones
        \end{itemize}
    \item Modificar el estilo del texto
        \begin{itemize}
            \item Fuente
            \item Color
            \item Tamaño
            \item Estilo
            \item Transformaciones
        \end{itemize}
    \item Listas
    \item Generación de contenidos
\end{itemize}

%Sin embargo, a pesar de reconocer cualquier etiqueta, el proyecto no tiene soporte para los 
%formularios de HTML, tablas, ni tampoco frames de HTML. No se tiene soporte de esas características 
%por la complejidad y tiempo de desarrollo que llevaría realizarlas.

\subsection{Soporte de estilos de CSS} \label{sec:props}

El proyecto desarrollado también tiene soporte para un subconjunto de la gramática de CSS.\\

Se tiene soporte para 48 propiedades de CSS (sin incluir las propiedades |shorthand|): \textit{
\newline
display, margin-top, margin-bottom, margin-right, margin-left, padding-top, padding-right, 
\newline 
padding-bottom, padding-left, border-top-width, border-right-width, border-bottom-width, 
\newline 
border-left-width, border-top-color, border-right-color, border-bottom-color, border-left-color, 
\newline
border-top-style, border-right-style, border-bottom-style,
border-left-style, font-size, font-weight, font-style, font-family, position, top, right, bottom, left, float, color, 
width, height, line-height, vertical-align, content, counter-increment, counter-reset, quotes, list-style-position,
list-style-type, background-color, text-indent, text-align, text-decoration, text-transform, white-space}.\\

El GUI del proyecto permite modificar las hojas de estilo para los usuarios |User| y |UserAgent|.

\subsection{Otras características}

\begin{itemize}
    \item El proyecto desarrollado tiene soporte para trabajar con los protocolos HTTP y File.
    \item El GUI permite la navegación entre páginas Web visitadas.
\end{itemize}


%\section{Revisión de Objetivos}
%
%\subsection{Primer objetivo específico}
%El primer objetivo específico fue: \textit{Desarrollar un módulo de comunicación entre el Navegador Web y los protocolos de
%comunicación HTTP y modelo TCP/IP.}\\
%
%Para el logro de ello se ha utilizado la librería |libcurl| para Haskell. Esta librería ha sido más que suficiente 
%para el proyecto ya que ha provisto la funcionalidad básica para interactuar con los protocolos HTTP y File.\\
%
%Además de esta librería, también se ha utilizado otras librerías para el tratamiento de imágenes y direcciones 
%URL, |gd|, |tagsoup| y |url|.
%
%\subsection{Segundo objetivo específico}
%El segundo objetivo específico fue: \textit{Desarrollar un intérprete de la información HTML.}\\
%
%Para cumplir este objetivo se ha desarrollado un lenguaje de marcado genérico. Este lenguaje
%abarca un sub-conjunto de la gramática de HTML, XHTML y XML.
%
%Para implementar esta parte del proyecto se ha utilizado la librería |uu-parsinlib|. Ésta ha sido de bastante 
%utilidad porque ha permitido que la gramática del lenguaje implementado sea robusta ante errores.\\
%
%En este proyecto no se dio soporte completo a ninguno de los lenguajes de HTML o XHTML, pero se desarrollo un lenguaje
%de marcado genérico que dé soporte a un sub-conjunto de la gramática de estos lenguajes.
%
%Una de las principales diferencias entre el lenguaje genérico desarrollado en el proyecto y el lenguaje HTML o XHTML 
%está en la forma de especificar la gramática del lenguaje. HTML y XHTML utilizan un formalismo denominado |Document Type
%Definition (DTD)| para definir la gramática de sus lenguajes. 
%
%En este proyecto no se dio soporte para |DTD|. Sin embargo, se podría realizar un parser para |DTD| que genere otro
%parser para el documento que está definiendo el |DTD|. De esta manera se puede disponer de un parser mucho más genérico 
%y completo que el desarrollado en el proyecto.
%
%\subsection{Tercer Objetivo específico}
%
%El tercer objetivo específico fue: \textit{Desarrollar los algoritmos que nos permitirán mostrar la información 
%en la pantalla del Navegador Web.}\\
%
%La especificación de CSS define la mayor parte del comportamiento de como 
%se debe mostrar la información en la pantalla. 
%
%En el proyecto desarrollado no se implementó todo el comportamiento definido por CSS, esto por razones 
%de complejidad y tiempo de desarrollo. Solo se dio soporte al comportamiento básico de un Navegador Web, 
%listas y generación de contenidos.
%
%Por ejemplo, no se implementó todos los posicionamientos definidos por CSS, solo se dio soporte para el posicionamiento 
%estático o |normal flow| y para el posicionamiento relativo. 
%Tampoco se dio soporte para mostrar tablas, ni formularios de HTML en la pantalla del Navegador Web.\\
%
%En gran parte del proyecto se ha utilizado la herramienta |uuagc|. Esta herramienta ha permitido
%simplificar la descripción la semántica o comportamiento del Navegador Web, de manera que en muchas ocasiones
%ha permitido reducir la cantidad de código evitando las repeticiones para enfocarse en las partes importantes.
%
%\subsection{Cuarto Objetivo específico}
%
%El cuarto objetivo específico fue: \textit{Desarrollar la Interfaz Gráfica de Usuario (GUI).}\\
%
%En el proyecto se ha desarrollado una interfaz gráfica de usuario con la librería |WxHaskell|. El GUI desarrollado
%integra todos los módulos desarrollados en el proyecto y provee de una funcionalidad básica para la interacción
%entre el usuario y la página Web.
%
%\subsection{Quinto Objetivo específico}
%
%El quinto objetivo específico fue: \textit{Desarrollar un módulo  que dé soporte a CSS (Style Sheet Cascade).}\\
%
%Este objetivo, se constituye uno de los objetivos más importantes del proyecto porque
%gracias a éste es posible mostrar la información en la pantalla del Navegador Web.\\
%
%En el proyecto, al igual que para el segundo objetivo, se ha desarrollado un intérprete de la información de CSS.
%Este interprete cubre un sub-conjunto de la gramática del lenguaje de CSS.\\
%
%También se ha dado soporte para 48 propiedades de CSS, los cuales están especificados en \pref{sec:props}. 

\section{El lenguaje de programación utilizado}
% codigo modular, funciones de alto-orden, evaluacion no estricta y emparejamiento de patrones.

En el desarrollo de los actuales Navegadores Web (Firefox, Chrome, Internet Explorer) se utilizó lenguajes
imperativos (C, C$++$, Java), sin embargo, en este proyecto se utilizó el lenguaje de programación funcional
Haskell.\\

Haskell es un lenguaje de programación poderoso que puede beneficiar al programador y proyecto con sus
características. 
A continuación se mostrará las características más importantes de Haskell que beneficiaron al proyecto.

\subsection{Datatypes de Haskell}

La forma rica de definir los |datatypes| de Haskell ha permitido que algunos de los tipos de datos del proyecto
sean expresados de mejor manera. Por ejemplo, el tipo de dato |Property| (\pref{sec:tprop}), que se describe a
continuación:

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
\end{code}
\end{hs}

El tipo de dato |Property| refleja lo que la especificación de CSS define. Por ejemplo, la especificación indica
que una propiedad debe tener un nombre, valor inicial, parser para sus valores, etc. Los mecanismos de Haskell
permitieron expresar la especificación de la propiedad casi de forma plana y directa.\\

En la definición de |Property| se utiliza funciones (|fsComputedValue| y |fnUsedValue|), las cuales actúan
como cualquier otro tipo de dato. Esto permite que la definición de una instancia para |Property| sea bastante
expresivo, de manera que el programador debe especificar una función que no es evaluada al momento de la definición,
sino cuando el proyecto lo requiera.

\subsection{Biblioteca de funciones de Haskell}

Haskell dispone de una amplia biblioteca de funciones que pueden ser usadas para implementar
distintos tipos de comportamientos.

Por ejemplo, se ha utilizado varias de las funciones de listas de Haskell para implementar 
la propiedad \textit{white-space} (\pref{sec:wspace}).\\

También se ha utilizado las funciones de la estructura |Map| para representar la lista
de propiedades de CSS de un elemento.

\subsection{Definición de funciones de Haskell}

Haskell provee varias formas de definir una misma función. Muchas veces, la definición en cierta forma, 
es más simple y expresiva que las otras.

Este es el caso de la definición de la función |doComputedValue| (\pref{sec:computed}), donde se utilizó 
la definición por emparejamiento de patrones (|pattern matching|), que resulto ser más expresiva y simple.

\subsection{Aplicación parcial de funciones}
En Haskell, cualquier función que tiene 2 o más argumentos, puede ser parcialmente aplicado a uno o más
argumentos, lo cual es una forma poderosa de construir funciones como resultados \cite{thompson}.\\

Esta característica es utilizada en dos partes del proyecto: Generación de ventanas renderizables desde
la estructura de formato de fase 2 (\pref{sec:genVenRend}) y en la función |goToURL| (\pref{sec:rendPW}) que es utilizada
para implementar la función |onClick| (\pref{lhc:onClick}).

\subsection{Modularidad}

Haskell permite definir módulos en los que se agrupa tipos de datos y funciones. Cada módulo permite
definir funciones y tipos que estén disponibles para su uso en otros módulos.

En el proyecto, se ha definido varios módulos con su respectiva funcionalidad, lo cual ha permitido
que el código del proyecto sea más organizado.


%\begin{itemize}
%    \item La forma rica de definir los datatypes en Haskell.
%          Esto ha permitido que algunos de los datatypes del proyecto sean expresados de mejor manera.
%          Por ejemplo, el tipo de dato |Property| ha sido implementado utilizando funciones en la definición
%          del |datatype|. Esto aprovecha la característica donde la funciones de Haskell son ciudadanos de
%          primera clase, es decir, que las funciones pueden ser usados en cualquier lugar donde los tipos
%          normales pueden ser usados.
%    \item La extensa biblioteca de funciones de Haskell disponibles para su uso. Esto ha beneficiado al proyecto
%          en la implementaciones de algunos comportamientos con la simple utilización de esa amplia biblioteca
%          de funciones de Haskell. Un ejemplo clave para esta parte es la implementación de la propiedad 
%          \textit{white-space} de CSS. Esta propiedad ha sido implementada utilizando funciones de listas
%          sobre el tipo de dato |String|.
%    \item La forma de definir una misma función de varias maneras. Muchas veces, definir una función de cierta
%          forma tiene más ventajas que su definición en otras formas. En el proyecto, la forma de definición
%          de emparejamiento de patrones (|pattern matching|) ha sido en muchos casos, más ventajosa que las
%          otras formas.
%    \item La evaluación perezosa o no estricta de Haskell. Esta característica también ha beneficiado al proyecto
%          permitiendo que el código sea más expresivo y simple.
%    \item Modularidad, esta característica no solo ha permitido agrupar las funciones y código del proyecto en
%          partes, sino también ha permitido definir las funciones principales del proyecto que son públicas para 
%          otros módulos.
%\end{itemize}

\section{Las herramientas y librerías utilizadas}

Las herramientas y librerías utilizadas han jugado un rol importante en la simplificación de la complejidad
en el desarrollo del proyecto.\\

A continuación de describe las principales herramientas y librerías utilizadas.

\subsection{Librería \uuplib}

La librería \textit{uu-parsinglib} fue utilizada para implementar los analizadores sintácticos del lenguaje de marcado 
genérico y lenguaje de estilos de CSS.\\

Uno de los principales beneficios que la librería ha provisto al proyecto fue el hacer que la gramática implementada sea 
robusta, es decir, que se puedan hacer correcciones en la entrada si esta es incorrecta.

Otro de los beneficios de la librería, es que no se dependió de otra herramienta en la que se tenga que utilizar 
otra sintaxis, sino más bien, se utilizó el mismo lenguaje Haskell para implementar el analizador sintáctico.

\subsection{Herramienta UUAGC}

También se ha utilizado la herramienta UUAGC para la mayor parte de la descripción de la semántica del proyecto.\\

Esta herramienta ha sido beneficiosa para el proyecto, porqué en primer lugar, permite expresar las computaciones
haciendo un movimiento de información a través del árbol de la gramática. Esto permite enfocarse en la resolución del
problema, es decir en la computación, la cual es expresada con código Haskell.

Entre los otros beneficios están: generar sólo las partes que se necesita para el proyecto. Por ejemplo si sólo se necesita 
las funciones semánticas, es posible generar sólo las funciones semánticas y no los tipos de datos (En la \pref{sec:genhaskell}
se muestra la forma de generar código Haskell desde UUAGC).

La herramienta también brinda la posibilidad de evitar código repetitivo a través de las 
reglas de copiado de la herramienta. Esto ha permitido que el código del proyecto sea compacto. 

Finalmente, la herramienta también permite dividir el código en varios archivos, de manera que cada archivo represente 
una parte específica.

\subsection{Librería WxHaskell}

Otra de las librerías principales que se utilizó en el proyecto fue |WxHaskell|, que permitió implementar
toda la parte gráfica del proyecto y modelar el proceso de renderización (\pref{sec:procR}) utilizando 
variables de |WxHaskell| para almacenar el resultado de partes que no requieren reprocesamiento.\\

Esta librería presentó algunas limitaciones en la implementación, las cuales se muestran a continuación.

\begin{itemize}
    \item |WxHaskell| no tiene soporte para el color transparente en la plataforma Gnu/Linux. 
    Esto afectó en la implementación de la propiedad \textit{background-color}.
    \item |WxHaskell| es una librería para Haskell que utiliza la librería |WxWidgets|, una librería gráfica
    para C$++$. Sin embargo, |WxHaskell| no provee toda la funcionalidad de \newline |WxWidgets| y en algunos casos,
    el mapeo de funciones se hizo de manera incorrecta. Por ejemplo, en |WxWidgets| la función |wxFont::SetFaceName|
    retorna un valor |Bool| como resultado de ejecutar la función, pero en |WxHaskell|, la misma función (|fontSetFaceName|)
    no retorna nada. Esto ha puesto limites en la implementación, porque no se pudo saber la existencia
    de una fuente de texto.
\end{itemize}

\section{Limitaciones del proyecto}

El proyecto presentado en este documento corresponde simplemente a una pequeña parte de la amplia y 
compleja área de los Navegadores Web.
\newline
Los actuales Navegadores Web, son eficientes en el trabajo que realizan, dando soporte a un amplio 
conjunto de documentos e implementando una gran cantidad de funcionalidad.\\

En este proyecto sólo se ha considerado un subconjunto de las versiones estándar de HTML/XHTML y CSS.
Por ejemplo, no se dio soporte a formularios, tablas, ni |frames| de HTML. Tampoco se implementó todo
el comportamiento definido por la especificación de CSS, sólo se implementó el posicionamiento
estático (|normal flow|) y relativo (No se implementó el posicionamiento flotante, ni absoluto).
Finalmente, sólo se dio soporte a 48 propiedades de CSS.\\

Los algoritmos para acomodar los elementos en la pantalla, fueron desarrollados
manualmente, es decir sin utilizar mecanismos de la librería gráfica, lo cual afecta el tiempo
de renderización y redimensionamiento de páginas Web.\\

A pesar de las limitaciones del proyecto, es apreciable y valorable como las características, librerías y herramientas
de Haskell colaboraron a reducir los costos de desarrollo en el proyecto, permitiendo que el código sea modular,
compacto y fácil de entender.

\section{Recomendaciones para trabajos futuros}

El presente trabajo presentado en este documento, puede ser extendido de varias maneras. 
A continuación se presenta algunas recomendaciones para trabajos futuros.

\begin{itemize}
    \item \textbf{Dar soporte completo al parser de HTML/XHTML, considerando las descripciones de un DTD 
    (\textit{Document Type Defintion}).} Básicamente, se puede implementar de 2 formas: (a) escribir un
    parser para DTD que genere otro parser para HTML/XHTML, (b) implementar el parser de HTML/XHTML respetando
    las reglas de un DTD.

    \item \textbf{Extender el soporte para la especificación de CSS.} Esto implica dar soporte a tablas y 
    posicionamientos (flotante y absoluto). Además, se debe dar soporte para más propiedades de CSS (Existe como 
    80 propiedades de CSS para la renderización en la pantalla, de las cuales sólo se implementó 48).

    \item \textbf{Delegar la tarea de dimensionamiento y posicionamiento a la librería gráfica.}
    Actualmente el dimensionamiento y posicionamiento es realizado de forma manual (se calcula las dimensiones y 
    posiciones manualmente para cada box), lo cual causa el consumo de mucho tiempo en el redimensionamiento. Si la librería
    gráfica haría este trabajo, el redimensionamiento sería eficiente.

    \item \textbf{Mejorar la implementación del algoritmo para la asignación de valores a las propiedades.}
    Para esta parte, se puede considerar el árbol lexicográfico para las reglas de CSS del Navegador Web Firefox 
    (\pref{sec:firefox}).

    \item \textbf{Implementar Javascript.} La mayoría de los actuales Navegadores Web tienen soporte para Javascript.
    La implementación implicaría desarrollar un parser para Javascript, y un motor de ejecución de código Javascript.
\end{itemize}
