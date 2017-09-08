
%include lhs2TeX.fmt
\chapter{Introducción General}

El presente documento contiene la descripción de la implementación de un Navegador Web con Haskell.\\

Desde sus inicios el Internet ha sido muy prometedora, permitiendo la comunicación entre computadoras 
al rededor del mundo. Sin embargo, la Internet ha sido aun más exitosa con la creación de un Sistema 
de Acceso a Documentos, la WWW (World Wide Web) o Web.\\

De ahí en adelante han adquirido un cierto grado de importancia los Navegadores Web (Web Browsers) y 
Servidores Web.  

De manera que, los documentos almacenados en los Servidores Web son requeridos por los Navegadores Web.\\

Los Navegadores Web\cite[p.~7]{sebesta}, llamados así porque permiten al usuario navegar por la Web o buscar alguna información 
almacenada en el servidor, son programas que se ejecutan en la máquina del cliente, los cuales actúan como 
intermediarios entre la comunicación del usuario y los servidores de páginas Web.\\

Los actuales Navegadores Web, tales como Firefox, Internet Explorer, Opera,  Safari, Chrome, son programas 
muy sofisticados que están implementados en lenguajes |imperativos|; denominados así debido a que 
consisten de una secuencia de comandos estrictamente ejecutados uno después del otro\cite{introHaskell}.\\

Dada la variedad de versiones para tecnologías y estándares Web tanto para HTML, CSS (Cascading Style Sheet), 
DOM (Document Object Model) y JavaScript, los navegadores Web deben estar implementados con un alto nivel 
de modularidad, código mantenible y fácil de comprender.\\

Sin lugar a dudas, estas características existen en los lenguajes imperativos. Sin embargo, el costo de 
implementar una aplicación con esas características es elevado tanto en tiempo de desarrollo como en el 
de mantenimiento.\\

Tener una aplicación con un costo elevado puede afectar directamente a la cantidad de código que se escribe 
y al tamaño en bytes de la aplicación. También puede dificultar el mantenimiento a la aplicación,
dado que las actividades de mantenimiento implican mejorar los productos de software, adaptarlos a nuevos ambientes, 
y corregir problemas\cite[cap.~9, p.~334]{ingsoft}; es necesario comprender bien el código, incluso si se tiene una documentación.

También afecta al costo económico de desarrollo, pues a pesar de que la mayoría de los Navegadores Web son 
de distribución gratuita, éstos demandan un alto esfuerzo en su desarrollo.\\

Haskell, según \cite[p.~3]{haskell98}, es un Lenguaje de Programación Funcional puro, con evaluación perezosa y de propósito general
que incorpora muchas de las innovaciones recientes del diseño de lenguajes de programación.

Haskell provee funciones de alto-orden, semántica no estricta, tipado polimórfico estático, tipos de
datos algebraicos definidos por el usuario, emparejamiento de patrones, listas por comprensión,
un sistema modular, un sistema monádico I/O, y un conjunto rico de tipos de datos primitivos que incluyen
listas, arrays, números enteros de precisión fija y arbitraria, y números de punto flotante.

También se puede observar que Haskell ha crecido y madurado lo necesario como para 
hacer aplicaciones no sólo en el ámbito académico, sino también comercial \cite{hcar, hackage}.\\

Es por ello que con el presente proyecto se pretende experimentar las capacidades de Haskell mediante el desarrollo 
de un Navegador Web.\\

A continuación se describe los objetivos, el alcance, la justificación y descripción general del proyecto.

\section{Objetivos}

\subsection{Objetivo General}
Desarrollar un Navegador Web con el lenguaje de programación funcional Haskell.

\subsection{Objetivos Específicos}

\begin{enumerate}
    \item Desarrollar el módulo de comunicación entre el Navegador Web y los Protocolos HTTP y modelo TCP/IP.
    \item Desarrollar un intérprete de la información HTML.
    \item Desarrollar los algoritmos que nos permitirán mostrar la información en la pantalla del Navegador Web.
    \item Desarrollar la Interfaz Gráfica de Usuario (GUI).
    \item Desarrollar un módulo  que de soporte a CSS (Style Sheet Cascade).
\end{enumerate}

\section{Alcance}
Dada la cantidad de versiones de código HTML, XHTML y CSS para el desarrollo, sólo se tomará
en cuenta un subconjunto de las versiones estándar.
Asimismo, no se considerará los DTD (Document Type Definition) de HTML/XHTML.

Finalmente, tampoco se tomará en cuenta las extensiones (plugins) de un Navegador Web
tanto de Java (soporte para Applets de JVM) como de Flash (Flash Player) entre otros.

\section{Justificación}

El desarrollo de este proyecto mostrará cómo las características de la programación funcional pueden colaborar  
a reducir los costos de desarrollo y mantenimiento, permitiendo un código compacto, modular y fácil de entender.

\section{Descripción General}

El proceso general para renderizar una página puede ser descrito a través de la \pref{img:gprocess}.

\begin{figure}[H]
\begin{center}
    \scalebox{0.5}{\includegraphics{059-figura-figura003.png}}
\end{center}
\caption{Proceso general de renderización} \label{img:gprocess}
\end{figure}

\subsection{Obteniendo entradas}

Para renderizar una página Web, lo primero que se realiza es obtener la página Web que se quiere
renderizar.\\

Esto se realiza utilizando la dirección |URL| de la página Web y proveyendo el |URL| a la librería \libcurl, 
la cual se encarga de comunicarse con el protocolo y devolver un |String| con el contenido de la página Web.

Por otra parte, si el documento contiene imágenes o archivos de hojas de estilo, entonces también se obtienen esos
recursos utilizando la librería \libcurl.\\

En la \pref{sec:download} se describe detalladamente el proceso de descargar recursos de la Web.



\subsection{Parseando el Documento}

Lo siguiente es analizar la entrada sintácticamente para obtener el árbol de sintaxis abstracta.

Para realizar el análisis sintáctico se utiliza la librería \uuplib. El lector interesado en un tutorial
simple para la librería \uuplib puede revisar el \pref{apd:combinadoresbasicos}.\\

En el capítulo 3, 4 y 5 se describe el proceso de análisis sintáctico.

\subsection{Formateando la Estructura}

Para formatear la estructura, se sigue el siguiente proceso:

\begin{enumerate}
    \item Una vez que se tiene el |NTree|(resultado del análisis sintáctico), se obtienen todas las declaraciones de estilos y 
          luego se asigna un valor a cada propiedad de CSS.\\

          El \pref{chp:pselector} describe esta parte del proyecto.
    \item Luego se genera la estructura de formato. El procesamiento de la estructura de formato
          se ha dividido en 2 fases:
        \begin{itemize}
            \item La primera fase, se encarga principalmente de 2 cosas:
                \begin{itemize}
                    \item Generar líneas de |boxes| dependientes de un ancho.
                    \item Concretizar los valores de algunas propiedades que dependen de otros valores 
                          (por ejemplo, porcentajes que dependen del ancho del contenedor).
                \end{itemize}
            \item La segunda fase, se encarga de generar ventanas (|Window|) con su respectiva posición, 
                  dimensión, funciones de eventos y propiedades de CSS renderizables.
        \end{itemize}

        El \pref{chp:eformato} describe en detalle cada parte del proceso de formatear la estructura
        de fase 1 y 2.
\end{enumerate}

Para formatear la estructura se hace uso de la herramienta \uuagc, el lector interesado en un tutorial simple
para la herramienta \uuagc puede revisar el \pref{apd:agtutorial}.

\subsection{Renderizando la Estructura de Formato}

La renderización consiste en pintar o dibujar el texto e imágenes con las propiedades de CSS especificadas
para cada ventana o |box|.

El Capítulo 8, 9 y 10 describen este proceso.


