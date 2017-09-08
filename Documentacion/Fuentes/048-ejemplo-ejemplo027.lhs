
%include lhs2TeX.fmt

\begin{code}
pSimpleRosa 
    =  let nombreTagInicio = pTagInicio2
           ramificaciones  = pList_ng pSimpleRosa
           nombreTagFinal  = pNombreTag nombreTagInicio
       in rosaTag nombreTagInicio ramificaciones nombreTagFinal
\end{code}
