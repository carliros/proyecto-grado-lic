
%include lhs2TeX.fmt

\begin{code}
HojaEstilo :: Regla*
Regla ::= Selectores `{' Declaraciones `}'
Selectores ::= Selector
            |  Selector (`,' Selector)+
Selector ::= Simple_Selector
          |  Simple_Selector Operador Selector
Simple_Selector ::= Nombre_Selector Atributo* Pseudo?
                 |                  Atributo+ Pseudo?
                 |                            Pseudo
Nombre_Selector ::= Identificador
                 |  `*'
Operador ::= ` ' | `>' | `+'
Atributo ::= `#' Identificador
          |  `.' Identificador
          |  `[' Identificador `]'
          |  `[' Identificador OperadorAT ValorAT `]'
OperadorAT ::= `~=' | `='
ValorAT ::= Cadena
Pseudo ::= `:' ``before''
        |  `:' ``after''
Declaraciones ::= Declaracion
               |  Declaracion (`;' Declaracion)+
Declaracion ::= Identificador `:' ValorPropiedad
ValorPropiedad ::= Numero`px'
                |  Numero`em'
                |  Numero`pt'
                |  Numero`%'
                |  PalabraReservada
                |  Cadena
                |  Lista ValorPropiedad*
Identificador ::= AlphaNum+
AlphaNum ::= Alpha 
          |  Num
Alpha ::= `a' | `b' | `c' | .. | `z'
        | `A' | `B' | `C' | .. | `Z'
Num ::= `0' | `1' | .. | `9'
Cadena ::= `'' ContenidoCadena1 `''
         | `"' ContenidoCadena2 `"'
ContentidoCadena1 ::= ... Cualquier texto excepto `''
ContentidoCadena2 ::= ... Cualquier texto excepto `"'
\end{code}
