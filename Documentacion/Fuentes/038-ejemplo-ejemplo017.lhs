
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (length <$> pList (pSym ' ')) "   "
3
*ParsersBasicos> parseString (length <$> pList (pSym ' ')) "      "
6
*ParsersBasicos> parseString (length <$> pList (pSym ' ')) ""
0
*ParsersBasicos> parseString (length <$> pList (pSym ' ')) " "
1
\end{code}
