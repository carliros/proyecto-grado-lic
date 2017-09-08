
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pSym 'a') "b"
-- >    Deleted  'b' at position (0,0) expecting 'a'
-- >    Inserted 'a' at position (0,1) expecting 'a'
'a'
\end{code}
