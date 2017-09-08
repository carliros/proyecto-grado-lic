
%include lhs2TeX.fmt
%format "~=" = "\ensuremath{\symbol{34}\sim=\symbol{34}}"
%format ^^   = "\;"
\chapter{Parser para \css} \label{chp:parsercss}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Introducción
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\section{Introducción}
%if showChanges
\color{blue}
%endif

Al igual que para el capítulo del Parser para HTML (\pref{chp:parsermarcado}) también se necesita
desarrollar una parser para el lenguaje de hojas de estilos CSS. Este parser debe reconocer 
un ejemplo particular de la sintaxis concreta de CSS y generar una sintaxis abstracta del 
lenguaje de hojas de estilos CSS.\\

Entonces, en este capítulo se desarrollará un \parser\ que reconozca la sintaxis concreta del lenguaje
de hojas de estilo CSS y genere como resultado la sintaxis abstracta del mismo lenguaje.
La sintaxis concreta y abstracta (que se utilizará para el parser de CSS) está descrita en la \pref{sec:lcss}
del \pref{chp:gramaticas}.\\

Se utilizará la librería \uuplib(versión 2.5.5) como herramienta para ``parsear'' la entrada. 
También se utilizará el módulo \emph{CombinadoresBasicos} del \pref{apd:combinadoresbasicos}.\\

En las siguientes secciones del capítulo se desarrollará el parser de manera acumulativa, se inicia
desarrollando el parser para las reglas de estilo, luego para los distintos tipos de selectores y finalmente 
para las declaraciones de estilos.

%if showChanges
\color{black}
%endif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinadores para hojas de estilo y Reglas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Combinadores para \hest\ y Reglas} \label{sec:phojasestilo}

Se inicia esta sección escribiendo los combinadores para las \hest.\\

Las \hest\ son sencillamente una lista de Reglas que pueden pertenecer a un determinado
tipo y origen. Pero, no existe una sintaxis para reconocer el tipo y origen.

La información de tipo y origen es determinada de acuerdo al contexto en que es utilizado.
Por ejemplo, si se quiere definir una |Hoja de estilos| con el usuario (origen) |User|,
el tipo de la hoja de estilos siempre será |Externo|, porque no hay forma de definir
una hoja de estilos |Interna| o de |Atributos|. Este es el mismo caso cuando se quiere
definir hojas de estilo con el usuario (origen) |UserAgent|.

Entonces, el único usuario que puede definir hojas de estilo en cualquiera de los 3 tipos es
|Author|. Más adelante (\pref{sec:cssParserInterfaces}) se mostrará las funciones que permitan
definir las hojas de estilo de acuerdo al contexto.

Por ahora, simplemente se necesita saber que para reconocer una hoja de estilo se debe recibir
2 parámetros: tipo y origen.

\begin{hs}
\small
\begin{code}
pHojaEstilo :: Tipo -> Origen -> Parser HojaEstilo
pHojaEstilo tp org = pList (pRegla tp org)
\end{code}
\end{hs}

Las hojas de estilo son simplemente una lista de reglas, donde los parámetros que recibe para su parser
no le son importantes, de manera que son nuevamente enviados, como argumentos, al parser para reconocer
una regla.

Entonces el parser para reconocer una |Regla| recibe 2 parámetros. Además, su parser
está compuesto por selectores y seguido de declaraciones, las cuales están agrupadas entre llaves.
La forma en que se guarda una |Regla|, según la \gabstracta, es usando una tupla de 4: 
el tipo, origen, selectores y declaraciones.

\begin{hs}
\small
\begin{code}
pRegla :: Tipo -> Origen -> Parser Regla
pRegla tp org = (,,,)  tp  org  <$>  pSelectores   <*    pSimboloAmb  "{"
                                                                <*> pDeclaraciones
                                                   <*    pSimboloAmb  "}"
\end{code}
\end{hs}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinadores para Selectores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Combinadores para Selectores}

Los Selectores son una lista de uno o más Selectores separados por comas. 

\begin{listing}
\begin{code}
pSelectores = pList1Sep_ng (pSimboloAmb ",") pSelector
\end{code}
\end{listing}

Para implementar el parser para |Selector|, primeramente se realizara el parser/combinador para
los atributos y Pseudo-Selectores.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinadores para atributos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Combinadores para atributos}

La sintaxis concreta para los atributos (\pref{desc:gcss}) define 4 tipos de atributos: Atributo ID, 
atributo clase, atributo nombre y atributo operador. Pero en la sintaxis abstracta (\pref{lhc:attr})
sólo define los tipo de datos para 3 de ellos. Esto es así, porque el atributo clase
es representado a través del tipo de dato para del atributo operador, donde su nombre es `class' y 
su operador es `$\sim=$'.\\

A continuación se muestra el parser para los atributos:

\begin{hs}
\small
\begin{code}
pAtributo :: Parser Atributo
pAtributo   =      AtribID                     <$ pSimbolo "#" <*> pPalabra
            <|>    AtribNombre                 <$ pSimboloDer "[" 
                                                        <*> pPalabra 
                                               <* pSimboloIzq "]"
            <|>    AtribTipoOp "class" "~="    <$ pSimbolo "." <*> pPalabra
            <|>    AtribTipoOp                 <$ pSimboloDer "[" 
                                                        <*> pPalabra 
                                                        <*> pTipoOp 
                                                        <*> pSimpleString
                                               <* pSimboloIzq "]"

pTipoOp :: Parser String
pTipoOp = pSimboloAmb "=" <|> pSimboloAmb "~="
\end{code}
\end{hs}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinadores para pseudo-selectores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Combinadores para pseudo-selectores}

Los pseudo-selectores son opcionales y pueden estar declarados al final de un selector simple.
Pero existe un caso especial donde el pseudo-selector no puede ser opcional, esto es
cuando todos los demás campos de un selector simple no están presentes, si eso ocurre, el pseudo-selector
no puede ser opcional.\\

Para su implementación se construye dos versiones de un pseudo-selector. Uno que es opcional y otro que no puede
ser opcional.

\begin{hs}
\small
\begin{code}
pMaybePseudo :: Parser Pseudo
pMaybePseudo =  pMaybe pPseudoElemento

pMaybeJustPseudo :: Parser Pseudo
pMaybeJustPseudo = Just <$> pPseudoElemento

pPseudoElemento :: Parser PseudoElemento
pPseudoElemento  =    PseudoBefore    <$ pSimbolo ":" <* pToken "before"
                 <|>  PseudoAfter     <$ pSimbolo ":" <* pToken "after"
\end{code}
\end{hs}

El parser |pMaybePseudo| puede ser opcional y el parser |pMaybeJustPseudo| no puede ser
opcional.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinadores para selector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Combinadores para selector}

Ahora que se tiene el parser para las partes de un selector, se definirá el combinador
para un selector simple.\\

Un Selector Simple puede ser de dos tipos: |TypeSelector| que tiene un nombre o |UnivSelector|
identificado por el caracter `|*|' el cual no tiene nombre. En ambos casos se puede tener una 
lista de atributos y un pseudo-selector opcional.\\

El Selector Universal es un caso especial, porque puede tener directamente una lista de atributos y 
un pseudo-selector opcional. O también puede no tener ninguna lista de atributos, pero si o si 
un pseudo-selector no opcional:

\begin{hs}
\small
\begin{code}
pSSelector :: Parser SSelector
pSSelector 
    =       TypeSelector        <$>     pPalabra        <*>     pList   pAtributo  <*>       pMaybePseudo
    <|>     UnivSelector        <$      pSimbolo "*"    <*>     pList   pAtributo  <*>       pMaybePseudo
    <|>     UnivSelector        <$>                             pList1  pAtributo  <*>       pMaybePseudo
    <|>     UnivSelector []     <$>                                                          pMaybeJustPseudo
\end{code}
\end{hs}

Continuando con el parser para el selector, la \gconcreta\ indica que se tiene 2 tipos de selectores: uno simple y otro compuesto. 
El simple es el parser para |SSelector|, pero el compuesto es una lista de |SSelector| separados por operadores.

\begin{hs}
\small
\begin{code}
pSelector :: Parser Selector
pSelector   =       SimpSelector    <$>     pSSelector
            <|>     CompSelector    <$>     pSSelector <*> pOperador <*> pSelector
\end{code}
\end{hs}

El operador del selector compuesto debe reconocer los caracteres |>|, |+| y |' '|.
Reconocer el caracter de espacio es un caso especial, porque en primer lugar, puede ser una lista de 
al menos un espacio acompañado de caracteres como: \textit{nueva linea, retornos de carro o tabuladores}.
En segundo lugar, puede no haber un espacio, pero debe al menos tener un caracter de \textit{nueva
linea, retorno de carro o tabulador}.

\begin{hs}
\small
\begin{code}
pOperador :: Parser String
pOperador = pSimboloAmb ">" <|> pSimboloAmb "+" <|> pEspacioEspecial

pEspacioEspecial :: Parser String
pEspacioEspecial    
    =     " "   <$  stuff   <*  pList1  (pSym ' ') <*   stuff
    <|>   " "   <$  stuff1  <*  pList   (pSym ' ') <*   stuff
    where   stuff   = pList     (pAnySym "\t\r\n")
            stuff1  = pList1    (pAnySym "\t\r\n")
\end{code}
\end{hs}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinadores para declaraciones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Combinadores para Declaraciones}

Las declaraciones de CSS son una lista de declaraciones separadas por el símbolo `;',
cada declaración consiste en la asignación de uno o más valores a una o más propiedades.
Por ejemplo, cuando la declaración es simple, se asigna un sólo valor a una propiedad;
pero cuando se trata de una propiedad |shorthand|, se asigna varios valores a varias 
propiedades.

Es por eso que |pDeclaracion| debe devolver una lista de |Declaraciones| y que una vez reconocidas, deben 
concatenarse para obtener una simple lista de declaraciones y no una lista de listas de declaraciones.

\begin{hs}
\small
\begin{code}
pDeclaraciones :: Parser Declaraciones
pDeclaraciones = concat <$> pList1Sep_ng (pSimboloAmb ";") pDeclaracion
\end{code}
\end{hs}

Para facilitar la construcción de una |Declaracion|, se definirá la función |construirDeclaracion|,
que construye una declaración simple. Esta función recibirá, como argumento, una tupla donde el primer valor 
será el nombre de la propiedad y el segundo valor será un parser para sus valores y devolverá
una lista con un elemento (la declaración reconocida):

\begin{hs}
\small
\begin{code}
construirDeclaracion :: (String, Parser Value) -> Parser Declaraciones
construirDeclaracion (nm,pValor)
    =       (\nm vl imp -> [Declaracion nm vl imp]) 
    <$>     pToken nm <* pSimboloAmb ":" <*> pValor <*> pImportancia

pImportancia :: Parser Importancia
pImportancia = (True <$ pSimboloAmb "!" <* pToken "important") `opt` False
\end{code}
\end{hs}

Con ayuda de la función |construirDeclaracion| se puede implementar el parser para \newline
|pDeclaracion|:

\begin{hs}
\small
\begin{code}
pDeclaracion :: Parser Declaracion
pDeclaracion 
	=  construirDeclaracion
		  ( "display"
		  , pValoresClave ["inline", "block", "list-item", "none", "inherit"])
   <|> ...
\end{code}
\end{hs}

En la definición de |pDeclaracion| se debe especificar todas las declaraciones de las propiedades de CSS 
que se implementará en el proyecto. 
Sería sencillo si sólo fueran 10 o 20 propiedades, pero en realidad son más de 40 propiedades a las que se dará
soporte.
Dejarlo todo en un mismo módulo es voluminoso y propenso a errores, de manera que se ha optado por separarlos 
en distintos módulos.\\

El hecho de separarlos en distintos módulos implica tener una lista externa de parsers para las propiedades de CSS
y que la lista externa debe recibirse como un argumento en el parser para 
|pDeclaraciones|. En otras palabras, implica que se debe modificar el parser desarrollado hasta ahora.\\

Para la nueva modificación se ha decidido crear un módulo denominado |BasicCssParser| para almacenar los combinadores 
comunes para los valores de propiedades CSS.
También se ha creado otro módulo denominado |PropiedadesCSS| para guardar la lista de propiedades de CSS a las que se dará 
soporte. Los elementos de esta lista serán por ahora tuplas de 2 valores, donde el primer valor contendrá el nombre 
de la propiedad y el segundo será el parser que reconoce los valores para la propiedad.\\

Para construir una lista de declaraciones se usara la función |construirDeclaracion|:

\begin{hs}
\small
\begin{code}
lista_valor_parser :: [Parser Declaraciones]
lista_valor_parser =  map construirDeclaracion cssPropiedades
\end{code}
\end{hs}


Antes de describir los nuevos módulos mencionados, se verá como cambia el parser desarrollado hasta ahora para las
declaraciones y funciones relacionadas.\\

El parser para |pDeclaraciones| ahora recibe una lista de declaraciones de CSS,
donde cada declaración devuelve otra vez una lista de declaraciones.
Lo único que queda por hacer, es combinar todos los elementos de la lista con el combinador alternativo
de la libreria \uuplib\ \verb?<|>?:

\begin{hs}
\small
\begin{code}
pDeclaraciones :: [Parser Declaraciones] -> Parser Declaraciones
pDeclaraciones pDeclaracion 
    = concat <$> pList1Sep_ng (pSimboloAmb ";") (foldr (<|>) pFail pDeclaracion)
\end{code}
\end{hs}

Este cambio afecta a las funciones relacionadas con |pDeclaraciones|, de manera que |pRegla| y |pHojaEstilo|
deben recibir un parámetro más, la lista de declaraciones:

\begin{hs}
\small
\begin{code}
pHojaEstilo :: Tipo -> Origen -> [Parser Declaraciones] -> Parser HojaEstilo
pHojaEstilo tp org props = pList (pRegla tp org props)

pRegla :: Tipo -> Origen -> [(String,Parser Valor)] -> Parser Regla
pRegla tp org props     =       (,,,) tp org 
                        <$>     pSelectores     <*  pSimboloAmb "{"
                                                        <*> pDeclaraciones props
                                                <*  pSimboloAmb "}"
\end{code}
\end{hs}

\subsection{Separando Propiedades \acss}

En esta sub-sección se describirá los módulos |BasicCssParser| y |PropiedadesCSS|. 

\subsubsection{Módulo BasicCssParser} \label{sec:basicCSS}
Los valores comunes que se puede encontrar en un valor de una propiedad de CSS son: 

\begin{itemize}

\item \textbf{Valores Clave.} Lo más básico es reconocer una palabra clave. Luego se puede usar la misma
función para reconocer un |ValorClave| y usarlo para reconocer una lista de valores clave. 

\begin{hs}
\small
\begin{code}
pPalabraClave :: String -> Parser String
pPalabraClave = pToken

pValorClave :: String -> Parser Valor
pValorClave str = ValorClave <$> pPalabraClave str

pValoresClave :: [String] -> Parser Valor
pValoresClave = pAny pValorClave
\end{code}
\end{hs}

\item \textbf{Valores Length.} Estos combinadores construyen números \textit{pixel, point y em}. Se tiene dos variaciones:
uno que puede ser positivo o negativo, y el otro que sólo puede ser positivo.

\begin{hs}
\small
\begin{code}
pLength     =       NumeroPixel     <$>     pNumeroFloat <* pToken "px"
            <|>     NumeroPoint     <$>     pNumeroFloat <* pToken "pt"
            <|>     NumeroEm        <$>     pNumeroFloat <* pToken "em"

pLengthPos  =       NumeroPixel     <$>     pNumeroFloatPos <* pToken "px"
            <|>     NumeroPoint     <$>     pNumeroFloatPos <* pToken "pt"
            <|>     NumeroEm        <$>     pNumeroFloatPos <* pToken "em"
\end{code}
\end{hs}

\item \textbf{Valores Porcentajes.} Se construye números porcentajes de dos tipos: que pueden ser positivos o negativos, 
o solamente positivos.

\begin{hs}
\small
\begin{code}
pPorcentage 
    = Porcentage <$> pNumeroFloat <* pSimbolo "%"

pPorcentagePos 
    = Porcentage <$> pNumeroFloatPos <* pSimbolo "%"
\end{code}
\end{hs}

\item \textbf{Colores Claves.} El valor |ColorClave| recibe una tupla de 3 enteros, que representan los valores RGB.
Estos valores pueden presentarse en 3 distintas formas:

\begin{hs}
\small
\begin{code}
pColor = pColorComun <|> pColorHexadecimal <|> pColorFuncion
\end{code}
\end{hs}

\begin{itemize}

\item Los colores comunes están definidos a través de palabras claves, los cuales son reescritos
en sus valores RGB correspondientes.

\begin{hs}
\small
\begin{code}
pColorComun 
    =   ColorClave (0x80, 0x00, 0x00)   <$  pPalabraClave "maroon"
   <|>  ColorClave (0xff, 0x00, 0x00)   <$  pPalabraClave "red" 
   <|>  ColorClave (0xff, 0xa5, 0x00)   <$  pPalabraClave "orange"
   <|>  ColorClave (0xff, 0xff, 0x00)   <$  pPalabraClave "yellow"
   ....
\end{code}
\end{hs}

\item Los colores hexadecimales pueden presentarse de dos formas: pueden contener 3 caracteres
o 6 caracteres. Si son de 3 caracteres, cada caracter hexadecimal se repite y se lo convierte
a un entero para formar los valores RGB. Pero si son de 6 caracteres, se agrupa cada 2 caracteres
para convertirlos a un número entero para los valores RGB.\\

El combinador |pSimpleHex| se usa cuando son de 3 caracteres y |pDoubleHex| cuando son 
de 6 caracteres.\\

\begin{hs}
\small
\begin{code}
pSimpleHex = (\h -> "0x" ++ [h,h])       <$> pHex
pDoubleHex = (\h1 h2 -> "0x" ++ [h1,h2]) <$> pHex <*> pHex
\end{code}
\end{hs}

Las dos formas de color hexadecimal pueden ser implementadas se la siguiente manera:\\

\begin{hs}
\small
\begin{code}
pColorHexadecimal 
    =    (\r g b -> ColorClave (r, g, b))
            <$ pSimbolo "#" <*> pSimpleHex <*> pSimpleHex <*> pSimpleHex
    <|>  (\r g b -> ColorClave (r, g, b))
            <$ pSimbolo "#" <*> pDoubleHex <*> pDoubleHex <*> pDoubleHex
\end{code}
\end{hs}

\item Por último, color función que tiene la siguiente forma |rgb(r,g,b)|,
donde los valores RGB pueden ser números o porcentajes. Si es un número, debe estar en un 
rango de [0,255] y si es porcentaje, debe estar entre [0,100]. La función
|fixedRange| del combinador |pNumeroColor| se encarga de controlar el rango:\\

\begin{hs}
\small
\begin{code}
pColorFuncion 
    =  (\r g b -> ColorClave (r,g,b))
            <$ pPalabraClave "rgb"  <*  pSimboloAmb "(" <*> pNumeroColor
                                    <*  pSimboloAmb "," <*> pNumeroColor
                                    <*  pSimboloAmb "," <*> pNumeroColor
                                    <*  pSimboloAmb ")"

pNumeroColor  =    fixedRange 0 255     <$>  pEnteroPos
              <|>  fixedRange 0 100     <$>  pEnteroPos <* pSimbolo "%"		
    where   fixedRange start end val
                =  if val < start  then start
                                   else  if val > end  then end
                                                       else val
\end{code}
\end{hs}

\end{itemize}

\end{itemize}

\subsubsection{Módulo PropiedadesCSS} \label{sec:props_css}
En este módulo se especifica la lista de propiedades de \acss\ a las que se dará soporte en el proyecto.
La forma de especificar es una lista de tuplas de 2 valores: el primero guarda el nombre de la propiedad
y el segundo el parser para reconocer el valor de la propiedad.\\

A medida que se vaya avanzando con el desarrollo de proyecto se aumentará la lista de propiedades a las que 
se dará soporte y se hará la lista más completa. Por ahora se mostrará sólo un ejemplo de como podría ser esta lista:

\begin{listing}
\begin{code}
cssPropiedades
    = [ ("display"              , display       )
      , ("position"             , position      )
      , ("top"                  , offset_value  )
      , ("right"                , offset_value  )
      , ("bottom"               , offset_value  )
      , ("left"                 , offset_value  )
      , ("float"                , float         )
      ]

display 
    = pValoresClave [ "inline", "block", "list-item", "none", "inherit"]

position 
    = pValoresClave [ "static", "relative", "absolute", "fixed", "inherit"]

offset_value    
    =       pLength 
    <|>     pPorcentagePos
    <|>     pValoresClave ["auto", "inherit"]

float 
    = pValoresClave [ "left", "right", "none", "inherit"]
\end{code}
\end{listing}

%if showChanges
\color{blue}
%endif

\section{Interfaces para el parser de CSS} \label{sec:cssParserInterfaces}

%if showChanges
\color{black}
%endif

En la \pref{sec:phojasestilo} se mencionó que las \hest\ son sencillamente una lista de Reglas que 
pueden pertenecer a un determinado tipo y origen. Pero, no existe una sintaxis para reconocer 
el tipo y origen, porque son determinados de acuerdo al contexto en que son utilizados.

Entonces, se definirán funciones interfaces las cuales serán llamadas en el 
contexto adecuado. Estas funciones deben comunicarse con el parser de las hojas de estilo y manejar 
valores de tipo y origen que sean adecuados al contexto.\\

En el \pref{lhc:fparser1} se define las funciones |parseUserAgent y parseUser| para el usuario
|UserAgent| y |User| de manera correspondiente, 
estas funciones, así como se había mencionado, sólo soportan el tipo de origen |HojaExterna|. 
Las demás funciones que se han definido en el \pref{lhc:fparser1} y \pref{lhc:fparser2} son
para el usuario |Author|, el cual puede definir hojas de estilo en los distintos 3 tipos de hojas de estilo.

\begin{hs}
\small
\begin{code}
parseUserAgent input
    =   parseString (pHojaEstilo HojaExterna UserAgent lista_valor_parser) input

parseUser input
    =   parseString (pHojaEstilo HojaExterna User lista_valor_parser) input

parseHojaInterna input
    =   parseString (pHojaEstilo HojaInterna Author lista_valor_parser) input

parseHojaExterna input
    =   parseString (pHojaEstilo HojaExterna Author lista_valor_parser) input
\end{code}
\caption{Funciones interfaces para el parser de CSS, parte 1} \label{lhc:fparser1}
\end{hs}

Las funciones definidas en \pref{lhc:fparser1} son todas similares, el único que difiere es la función
para el estilo |Atributo|, que está definida en el \pref{lhc:fparser2}. El estilo de un atributo se
encuentra en el atributo |style| de una etiqueta.

La restricción para esta parte es, que no se puede tener selectores, sólo se puede tener declaraciones de estilos. 
Así, los estilos que se encuentren en el atributo se aplican directamente a la etiqueta donde han sido declarados. 
Es decir, que su selector siempre será un |SelectorSimple| el cual estaría compuesto solamente del nombre de 
la etiqueta.\\

Entonces, para construir un estilo atributo, se necesita recibir el nombre de la etiqueta y la entrada. Luego 
se obtiene las declaraciones con la entrada y se construye un selector simple con el nombre de la etiqueta. 
Finalmente se construye la regla de estilo atributo con el usuario |Author| y los datos obtenidos:

\begin{hs}
\small
\begin{code}
parseEstiloAtributo tag input
    =  do   decls <- parseString (pDeclaraciones lista_valor_parser) input
            let sel = SimpSelector (TypeSelector tag [] Nothing)
            return (EstiloAtributo, Author, [sel], decls)
\end{code}
\caption{Funciones interfaces para el parser de CSS, parte 2} \label{lhc:fparser2}
\end{hs}

