
%include lhs2TeX.fmt

\begin{code}
margin-left   width    margin-right   accion 
   auto       auto         auto       margin-left = margin-right = 0, y se utiliza
                                      la ecuacion para width
   auto       auto         ----       se hace margin-left = 0, y se utiliza
                                      la ecuacion para width
   auto       ----         auto       se utiliza la ecuacion y la cantidad
                                      obtenida se divide entre los ambos margenes
   auto       ----         ----       se utiliza la ecuacion
   ----       auto         auto       se hace margin-right = 0, y se utiliza la
                                      ecuacion para width
   ----       auto         ----       se utiliza la ecuacion
   ----       ----         auto       se utiliza la ucuacion
   ----       ----         ----       overconstrained, se obliga a utilizar la 
                                      ecuacion para margin-right 
\end{code}
