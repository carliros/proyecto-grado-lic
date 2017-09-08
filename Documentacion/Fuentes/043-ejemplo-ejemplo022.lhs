
%include lhs2TeX.fmt

\begin{code}
*Parser> parseString pSimpleRosa "Ejemplo 1: El Saludo\n"
SimpleRosa (SimpleTexto "Ejemplo 1: El Saludo\n") []
*Parser> parseString pSimpleRosa "< img />"
SimpleRosa (SimpleTag "img") []
*Parser> parseString pSimpleRosa "<p><img /> Esto es un texto </p>"
SimpleRosa (SimpleTag "p") [SimpleRosa (SimpleTag "img") []
                           ,SimpleRosa (SimpleTexto " Esto es un texto ") []
                           ]
\end{code}
