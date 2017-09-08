
\documentclass[11pt]{report}

% my packages
%include polycode.fmt

\usepackage[left=3.5cm,top=2.5cm,right=2.5cm,bottom=2.5cm]{geometry}
\usepackage[utf8]{inputenc}
\usepackage[spanish]{babel}
\usepackage{graphics}
\usepackage{relsize}
\usepackage{color}
\usepackage{latexsym}
\usepackage{float}
\usepackage{prettyref}
\usepackage{xspace}
\usepackage{fancyhdr}
%\usepackage[pdftex,bookmarks=true,colorlinks=false]{hyperref}
%\usepackage{bookmark}
\usepackage{apacite}
\pagestyle{fancy}
\lhead{}
\chead{}
\rhead{\slshape \small \rightmark}
\lfoot{}
\cfoot{\small \thepage}
\rfoot{}

\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}


\newcommand{\pref}[1]{\prettyref{#1}}
\newrefformat{lst}{Código~\ref{#1}}
\newrefformat{lhc}{Código~Haskell~\ref{#1}}
\newrefformat{lac}{Código~UUAGC~\ref{#1}}
\newrefformat{desc}{Descripción~\ref{#1}}
\newrefformat{sec}{Sección~\ref{#1},~página~\pageref{#1}}
\newrefformat{apd}{Apéndice~\ref{#1}}
\newrefformat{chp}{Capítulo~\ref{#1}}
\newrefformat{img}{Figura~\ref{#1}}

\newfloat{listing}{H}{ltg}
\floatname{listing}{Código}

\newfloat{hs}{H}{lhc}
\floatname{hs}{Código Haskell}

\newfloat{ag}{H}{lac}
\floatname{ag}{Código UUAGC}

\floatstyle{ruler}
\newfloat{desc}{H}{ldt}
\floatname{desc}{Descripción}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% special names
\newcommand {\html}{\emph{HTML}\xspace}                                 % HTML
\newcommand {\xml}{\emph{XML}\xspace}                                   % XML
\newcommand {\haskell}{\emph{Haskell}\xspace}                           % Haskell
\newcommand {\hxt}{\emph{HXT}\footnote{Haskell Xml Toolbox}\xspace}     % HXT
\newcommand {\uuplib}{\emph{uu-parsinglib}\xspace}                      % uu-parsinglib
\newcommand {\uuagc}{\emph{uuagc}\xspace}				                % uuagc
\newcommand {\wxhaskell}{\emph{WxHaskell}\xspace}		                % wxhaskell
\newcommand {\libcurl}{\emph{libcurl}\xspace}		                    % libcurl
\newcommand {\gd}{\emph{GD}\xspace}		                                % gd
\newcommand {\tagsoup}{\emph{TagSoup}\xspace}		                    % tagsoup
%\newcommand {\url}{\emph{URL}\xspace}		                            % url
\newcommand {\parser}{\emph{Parser}\xspace}                             % Parser
\newcommand {\browser}{\emph{Navegador Web}\xspace}                     % Browser

\newcommand {\gconcreta}{\emph{Sintaxis Concreta}\xspace}
\newcommand {\gabstracta}{\emph{Sintaxis Abstracta}\xspace}
\newcommand {\bnf}{\textbf{BNF}\xspace}
\newcommand {\ebnf}{\textbf{EBNF}\xspace}

\newcommand {\rosa}{\emph{Rosadelfa}\xspace} 
\newcommand {\lmarcado}{\emph{Lenguaje de Marcado}\xspace}
\newcommand {\dtd}{\emph{DTD}\xspace} 

\newcommand {\css}{\emph{Cascading Style Sheets (CSS)}\xspace} 
\newcommand {\cssc}{\emph{Hojas de Estilo en Cascada}\xspace}
\newcommand {\acss}{\emph{CSS}\xspace}
\newcommand {\hest}{\emph{Hojas de Estilo}\xspace}


% keywords definitions for each chapter
\newcommand {\fstkey}[1]{\emph{#1}\xspace}      % First  Chapter key according to the importance.
\newcommand {\sndkey}[1]{\emph{#1}\xspace}      % Second Chapter key
\newcommand {\thdkey}[1]{\emph{#1}\xspace}      % Thrid  Chapter key
\newcommand {\fthkey}[1]{\emph{#1}\xspace}      % Fourth Chapter key

\newcommand {\keywd}[1]{\emph{#1}\xspace}       % Fourth Chapter key


% special text
\newcommand {\ask}[1]{\emph{?'#1?}\xspace}      % ask

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\title{ \huge{Desarrollo de un Navegador Web con Haskell} \\
%		\normalsize{Tercer Borrador}
%      }\pagenumbering{roman} \setcounter{page}{1}
%\author{Carlos Gomez}

%%%%%%% only for compilation %%%%%%%%%
%\includeonly{002-caratula-Caratula
%            ,003-dedicatoria-Dedicatoria
%            ,004-agradecimientos-Agradecimientos
%            ,005-resumen-Resumen
%            ,006-cap01-Introduccion
%            ,007-cap02-MarcoTeorico
%            ,008-cap03-Gramaticas
%            ,009-cap04-ParsingHtml
%            ,010-cap05-ParsingCss
%            ,011-cap06-AsignacionDeValoresAPropiedades
%            ,012-cap07-EstructuraFormato
%            ,013-cap08-PropiedadesCss
%            ,014-cap09-CssBoxModel
%            ,015-cap10-Gui
%            ,016-cap11-Conclusiones
%            ,017-apendice01-ParsingTutorial
%            ,018-apendice02-AGTutorial
%            ,019-apendice03-Map
%            ,020-apendice04-UserAgent
%            }


%\BookmarkAtEnd{%
%    \bookmarksetup{startatroot}%
%    \bookmark[named=LastPage, level=0]{End/Last page}%
%    \bookmark[named=FirstPage, level=1]{First page}%
%}

%\bookmark[rellevel=1,keeplevel,dest=fig]{A figure}



\begin{document}

\include{002-caratula-Caratula}

\pagenumbering{roman} \setcounter{page}{1}
\include{003-dedicatoria-Dedicatoria}
\newpage

\include{004-agradecimientos-Agradecimientos}
\newpage

\include{005-resumen-Resumen}
\newpage

\addcontentsline{toc}{chapter}{Índice General}
\tableofcontents

\newpage
\addcontentsline{toc}{chapter}{Índice de códigos Haskell}
\listof{hs}{Índice de códigos Haskell}

\newpage
\addcontentsline{toc}{chapter}{Índice de códigos UUAGC}
\listof{ag}{Índice de códigos UUAGC}

\newpage
\addcontentsline{toc}{chapter}{Índice de descripciones}
\listof{desc}{Índice de descripciones}

\newpage
\addcontentsline{toc}{chapter}{Índice de figuras}
\listoffigures

% chapters
\cleardoublepage
\pagenumbering{arabic} \setcounter{page}{1}
\include{006-cap01-Introduccion}
\include{007-cap02-MarcoTeorico}
\include{008-cap03-Gramaticas}
\include{009-cap04-ParsingHtml}
\include{010-cap05-ParsingCss}
\include{011-cap06-AsignacionDeValoresAPropiedades}
\include{012-cap07-EstructuraFormato}
\include{013-cap08-PropiedadesCss}
\include{014-cap09-CssBoxModel}
\include{015-cap10-Gui}
\include{016-cap11-Conclusiones}

% apendices
\appendix
\include{017-apendice01-ParsingTutorial}
\include{018-apendice02-AGTutorial}
\include{019-apendice03-Map}
\include{020-apendice04-UserAgent}

\bibliographystyle{apacite}
\bibliography{021-bib-Bibliografia}

\end{document}


