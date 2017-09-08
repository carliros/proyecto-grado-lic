
%include lhs2TeX.fmt

\begin{code}
*Parser> parseString (pNombreTag "html") "html"
"html"
*Parser> parseString (pNombreTag "html") "body"
-- >    Deleted  'b' at position (0,0) expecting "html"
-- >    Deleted  'o' at position (0,1) expecting "html"
-- >    Deleted  'd' at position (0,2) expecting "html"
-- >    Deleted  'y' at position (0,3) expecting "html"
-- >    Inserted "html" at position (0,4) expecting "html"
"html"
\end{code}
