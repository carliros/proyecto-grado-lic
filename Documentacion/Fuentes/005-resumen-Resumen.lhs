
%include lhs2TeX.fmt

\chapter*{Resumen}
\addcontentsline{toc}{chapter}{Resumen}

\thispagestyle{empty}

%%% An approach to writing a thesis abstract
%%% ========================================
%%% Begin by identifying in a sentence the main purpose of the thesis.
%%%
%%% Then write answers to each of these questions:
%%%
%%% 1.- What is the problem or question that the work addresses?
%%% 2.- Why is it important?
%%% 3.- How was the investigation undertaken?
%%% 4.- What was found and what does it mean?
%%%
%%% You should find the answers to questions 1 and 2 in your Introduction; 
%%% the answer to question 3 will be a summary of your Methods; 
%%% and the answer to question 4 will summarise your Results, Discussion and Conclusion.

%En este proyecto se ha desarrollado un Navegador Web con el lenguaje de programacion 
%funcional Haskell.\\

El desarrollo de un Navegador Web funcional es un proyecto gigante, porque se debe desarrollar
varios módulos, dar soporte a varias versiones de HTML/CSS e implementar gran cantidad de funcionalidad.
\newline
Los actuales Navegadores Web, tales como Firefox, Internet Explorer, Chrome, Safari, son programas muy
sofisticados, con más de 10 años de desarrollo y madurez.
Estos han sido desarrollados con lenguajes de programación \textit{imperativos}. En el desarrollo de estos programas
se necesita que el código sea modular, fácil de comprender, expresivo, mantenible, flexible a cambios, eficiente, etc.\\

En este proyecto se ha desarrollado un Navegador Web con \textit{Haskell}, un lenguaje de programación \textit{funcional}, que incorpora
muchas de las innovaciones recientes del diseño de lenguajes de programación. 
Se ha implementado un sub-conjunto de la gramática de HTML y CSS, se dio soporte a 48 propiedades de CSS.
\newline
En el desarrollo se ha utilizado varias herramientas y librerías de Haskell. Por ejemplo:

\begin{itemize}
    \item[-] El parser de HTML y CSS fue desarrollado utilizando la librería \textit{uu-parsinglib}, la cual ha beneficiado con 
    un código simple, fácil de entender, expresivo y sobre todo robusto.
    \item[-] Para la mayor parte del comportamiento de HTML y CSS, se ha utilizado la herramienta \textit{UUAGC}. 
    Esta herramienta ha permitido que se escriba un código simple, comprensible y compacto.
    \item[-] También se ha utilizado la librería \textit{WxHaskell} para el desarrollo de la interfaz gráfica de usuario 
    y renderización de páginas Web.
    \item[-] Por último, se ha utilizado la librería \textit{libcurl} para descargar recursos de la Web.
\end{itemize}

En conclusión, se encontró que el lenguaje de programación funcional Haskell es apropiado y maduro para el desarrollo
de un Navegador Web.
Las herramientas y librerías utilizadas han jugado un rol importante en la simplificación de la complejidad en 
el desarrollo del proyecto.\\

A pesar de que normalmente se utilizan, para el desarrollo de este tipo de programas, lenguajes convencionales e imperativos,
Haskell ha sido de bastante utilidad, beneficiando al proyecto con varias de sus características, entre las más importantes: 
código modular, funciones de alto-orden, evaluación no estricta y emparejamiento de patrones.




\clearpage
