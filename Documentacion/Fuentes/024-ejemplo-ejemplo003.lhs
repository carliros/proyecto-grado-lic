
%include lhs2TeX.fmt

\begin{code}
Pal ::= epsilon
     |  `a'
     |  `b'
     |  `c'
     |  `a' Pal `a'
     |  `b' Pal `b'
     |  `c' Pal `c'
\end{code}

