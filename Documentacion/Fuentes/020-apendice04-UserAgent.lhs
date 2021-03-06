
%include uuagc.fmt

\chapter{Hoja de Estilo para UserAgent}

En este apéndice encontraras la hoja de estilo para el usuario |UserAgent|, que es utilizada
por el Navegador Web como la hoja de estilo por defecto para renderizar un documento.

\section{Hoja de Estilo}

\small
\begin{verbatim}
html, address, blockquote, body, dd, div,
dl, dt, fieldset, form, frame, frameset,
h1, h2, h3, h4, h5, h6, noframes,
ol, p, ul, center, dir, hr, menu, pre { display: block}

li { display: list-item }

head { display: none }

body { margin: 8px }

h1 { font-size: 2em
   ; margin: .67em 0px
   }

h2 { font-size: 1.5em
   ; margin: .75em 0px
   }

h3 { font-size: 1.17em
   ; margin: .83em 0px
   }

h4, p, blockquote, ul, fieldset, form,ol, dl, dir,menu { margin: 1.12em 0px }

h5 { font-size: .83em
   ; margin: 1.5em 0px
   }

h6 { font-size: .75em
   ; margin: 1.67em 0px
   }

h1, h2, h3, h4, h5, h6, b, strong {font-weight: bold }

blockquote { margin-left: 40px
           ; margin-right: 40px 
           }

i, cite, em, var, address {font-style: italic }

pre, tt, code, kbd, samp {font-family: monospace }

pre {white-space: pre }

big {font-size: 1.17em }

small, sub, sup {font-size: .83em }

sub {vertical-align: sub }
sup {vertical-align: super }

s, strike, del {text-decoration: line-through }

ol, ul, dir,menu, dd {margin-left: 40px }

ol {list-style-type: decimal }

ol ul, ul ol,ul ul, ol ol { margin-top: 0px
                          ; margin-bottom: 0px
                          }

u, ins {text-decoration: underline }

br:before { content: "\A"
          ; white-space: pre-line 
          }

center {text-align: center }

a {text-decoration: underline }
\end{verbatim}
