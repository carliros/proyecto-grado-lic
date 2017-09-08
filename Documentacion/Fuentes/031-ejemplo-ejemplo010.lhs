
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pReturn 'a') ""
'a'
*ParsersBasicos> parseString (pReturn 'a') "b"
-- >    The token 'b' was not consumed by the parsing process.
'a'
*ParsersBasicos> parseString (pReturn 'a') "a"
-- >    The token 'a' was not consumed by the parsing process.
'a'
\end{code}
