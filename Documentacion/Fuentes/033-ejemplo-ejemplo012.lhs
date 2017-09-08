
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pFail <|> pSym 'a') "a"
'a'
\end{code}
