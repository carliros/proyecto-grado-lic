
%include lhs2TeX.fmt

\begin{code}
*Parser> parseString pDigito "1"
'1'
*Parser> parseString pDigito "2"
'2'
*Parser> parseString pDigito "0"
'0'
*Parser> parseString pDigito "a"
-- >    Deleted  'a' at position (0,0) expecting isDigit
-- >    Inserted '0' at position (0,1) expecting isDigit
'0'
\end{code}
