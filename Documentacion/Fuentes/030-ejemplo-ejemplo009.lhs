
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pSym('0','9')) "2"
'2'
*ParsersBasicos> parseString (pSym('0','9')) "9"
'9'
*ParsersBasicos> parseString (pSym('0','9')) "a"
-- >    Deleted  'a' at position (0,0) expecting '0'..'9'
-- >    Inserted '0' at position (0,1) expecting '0'..'9'
'0'
\end{code}
