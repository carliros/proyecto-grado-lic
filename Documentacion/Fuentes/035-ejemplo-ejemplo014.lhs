
%include lhs2TeX.fmt

\begin{code}
*ParsersBasicos> parseString (pReturn (,,)  <*> pMayuscula 
                                            <*> pNumero 
                                            <*> pMinuscula) "A2a"
('A','2','a')
*ParsersBasicos> parseString (pReturn (,,)  <*> pMayuscula 
                                            <*> pNumero 
                                            <*> pMinuscula) "B2b"
('B','2','b')
*ParsersBasicos> parseString (pReturn (,,)  <*> pMayuscula 
                                            <*> pNumero 
                                            <*> pMinuscula) "C3a"
('C','3','a')
\end{code}
