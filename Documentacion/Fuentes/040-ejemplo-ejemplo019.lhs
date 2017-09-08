
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pListSep espacios palabra) "carlos"
["carlos"]
*ParsersBasicos> parseString (pListSep espacios palabra) "carlos  gomez"
["carlos","gomez"]
*ParsersBasicos> parseString (pList1Sep (pSym ',') natural) "1"
["1"]
*ParsersBasicos> parseString (pList1Sep (pSym ',') natural) "1,2,3,4,5"
["1","2","3","4","5"]
\end{code}
