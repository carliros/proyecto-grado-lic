
%include lhs2TeX.fmt

\begin{code}
*Parser> parseString pTagInicio "<html>"
"html"
*Parser> parseString pTagInicio "<h1>"
"h1"
*Parser> parseString pTagFin "</body>"
"body"
*Parser> parseString pTagEspecial "<img/>"
"img"
*Parser> parseString pTagInicio "< div >"
-- >    Deleted  ' ' at position (0,1) expecting isAlphaNum
-- >    Deleted  ' ' at position (0,5) expecting one of [isAlphaNum, '>']
"div"
\end{code}
