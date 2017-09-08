
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pReturn (:'0':[]) <*> pNumero ) "1"
"10"
*ParsersBasicos> parseString (pReturn (:'0':[]) <*> pNumero ) "2"
"20"
*ParsersBasicos> parseString (pReturn (:'0':[]) <*> pNumero ) "3"
"30"
\end{code}
