
%include lhs2TeX.fmt 

\begin{code}
Marcado ::= `<' Identificador Atributo* `>'  Elemento*  `<' `/' Identificador `>'
         |  `<' Identificador Atributo* `/' `>'
Elemento ::= Marcado
          |  Texto
Atributo ::= Identificador `=' Valor
Valor ::= `"' ContenidoAtributoValor `"'
Identificador ::= AlphaNum+
Valor ::= AlphaNum+ | ` ' | `\t' | `\r'
Texto ::= ...   Cualquier texto excepto ``<>/''
AlphaNum ::= Alpha 
          |  Num
Alpha ::= `a' | `b' | `c' | .. | `z'
        | `A' | `B' | `C' | .. | `Z'
Num ::= `0' | `1' | .. | `9'
\end{code}
