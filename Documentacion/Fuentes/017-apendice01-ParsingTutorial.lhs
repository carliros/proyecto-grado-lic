
%include lhs2TeX.fmt

\chapter{Tutorial para la librería uu-parsinglib} \label{apd:combinadoresbasicos}

En este apéndice encontraras un tutorial para el manejo de la librería \uuplib, el cual está
en base al Curso de Compiladores de la Universidad de Utrecht\cite[cap.~2]{ipl}, como también en el reporte 
técnico de \cite{cp-tut}.\\

Además, como una aplicación del tutorial, se desarrollará un módulo de combinadores elementales o básicos.

\section{Librería \uuplib}
La librería \uuplib\ es una herramienta \textbf{EDSL\footnote{EDSL: Embeded Domain Specific Language}} para \haskell\ 
que permite procesar una entrada a través de una descripción similar a la \gconcreta\ del lenguaje que se 
quiere procesar.\\

Entre los beneficios que \uuplib\ ofrece, se tiene:
\begin{itemize}
    \item Usar el mismo mecanismo de abstracción, tipado y nombrado de \haskell.
    \item Crear |parsers| al vuelo o en tiempo de ejecución del programa.
    \item No depender de otros programas separados para generar el parser. Hacer todo en \haskell.
    \item Usar el mismo formalismo para describir scanners y parsers.
    \item Usar el mismo formalismo para describir funciones semánticas y parsers.
    \item Trabajar con versiones limitadas de gramáticas infinitas.
\end{itemize}

Otro de los beneficios que tiene la librería es el de corregir los errores en la entrada, así el
resultado que devuelva el \parser\ estará de acuerdo a la gramática del lenguaje.

\section{Módulo \parser\ e Interfaces} \label{sec:modp}

En esta sección se define el módulo para los combinadores básicos, junto con las funciones básicas 
para que se puedan probar los ejemplos de las siguientes secciones.\\

Junto con la definición el módulo se debe importar las librerías que se va a utilizar, por ejemplo: la librería 
\uuplib\ y la librería |Data.Char|:

\begin{hs}
\small
\begin{code}
module CombinadoresBasicos where

import Text.ParserCombinators.UU
import Data.Char
\end{code}
\caption{Módulo CombinadoresBasicos}
\end{hs}

Luego se continúa con la definición de la función |parseIO|, que llama a la función 
principal |parse| de \uuplib. 

La función |parse| se encarga de parsear la entrada con el parser que recibe como argumento:

\begin{hs}
\small
\begin{code}
parseIO :: Parser a -> [Char] -> IO a
parseIO p input 
    = do  let (res,err) = parse ((,) <$> p <*> pEnd) (listToStr input (0,0))
          show_errors err
          return res
\end{code}
\caption{Función |parseIO|}
\end{hs}

También se define 2 funciones que faciliten el procesamiento de |String| y Archivos:

\begin{hs}
\small
\begin{code}
parseString :: Parser a -> [Char] -> IO a
parseString = parseIO

parseFile :: Parser a -> FilePath -> Paser a
parseFile p file = do  input <- readFile file
                       parseString p input
\end{code}
\caption{Función parseString y parseFile}
\end{hs}

\section{Combinadores de Parsers básicos}

Antes de describir los combinadores básicos se debe conocer algunas ideas básicas sobre 
los combinadores de parsers:

\begin{itemize}
    \item Cada `No Terminal' de la gramática corresponde a un \parser.
    \item Cada \parser es representado por una función \haskell.
    \item Las funciones especiales (también llamadas combinadores) combinan |parsers| 
          en nuevos |parsers|.
    \item Los |parsers| son ciudadanos de primera clase, de manera que pueden ser pasados como argumentos,
          y ser devueltos como resultados. Como consecuencia, el lenguaje de la Gramática Libre de Contexto
          (ejemplo BNF) es extendido con los mecanismos convencionales de abstracción de \haskell.
    \item Como los |parsers| están escritos en \haskell, se benefician gratuitamente de la revisión 
          de tipos de \haskell para las funciones semánticas.
\end{itemize}

\subsection{pSym}

|pSym| es una de las funciones más básicas de \uuplib. Esta función permite construir un
\parser que reconozca el parámetro que tiene como argumento.\\

|pSym| tiene 3 formas de utilización: reconocer un caracter simple, reconocer un rango de
caracteres, y reconocer un caracter a través de una función.

\subsubsection{Reconocer un caracter}

Si se envía un caracter a la función |pSym|, este reconocerá el argumento que recibe.

Por ejemplo, en una sesión de \verb?ghc-interactivo? (|ghci CombinadoresBasicos.hs|) se puede hacer:

\begin{desc}
\small
\input{028-ejemplo-ejemplo007}
\caption{Ejemplo sencillo con |pSym|}
\end{desc}

Si se envía una entrada incorrecta a |pSym|, la librería corregirá la entrada:

\begin{desc}
\small
\input{029-ejemplo-ejemplo008}
\caption{Ejemplo de corrección de errores con |pSym|}
\end{desc}

\subsubsection{Reconocer un rango de caracteres}

La segunda forma de |pSym| es reconocer una rango de caracteres. La forma es |pSym(x,y)|,
donde el rango está dado por: [x,y].\\

Por ejemplo, si se quiere reconocer un dígito:

\begin{desc}
\small
\input{030-ejemplo-ejemplo009}
\caption{Ejemplo para reconocer un rango de caracteres con |pSym|}
\end{desc}

Con esta forma es posible reconocer algunos símbolos básicos de una gramática. 

Por ejemplo:

\begin{hs}
\small
\begin{code}
pNumero             :: Parser Char
pNumero             = pSym('0','9')

pMinuscula          :: Parser Char
pMinuscula          = pSym('a','z')

pMayuscula          :: Parser Char
pMayuscula          = pSym('A','Z')

pHexadecimalChar    :: Parser Char
pHexadecimalChar    = pSym('a','f')
\end{code}
\caption{Ejemplos de combinadores simples, versión 1} \label{lhc:ex1}
\end{hs}

\subsubsection{Reconocer un caracter a través de una función}

Esta última forma generaliza las dos anteriores formas. |pSym| recibe 3 parámetros, una función
de tipo |Char -> Bool| que se encarga de reconocer un caracter, una cadena de descripción de la función
y un caracter por defecto, que es usado en caso de encontrar errores.\\

Como ejemplo se reescribirá las funciones que se definió en \pref{lhc:ex1}:

\begin{hs}
\small
\begin{code}
pNumero2        :: Parser Char
pNumero2        = pSym(isDigit, "digito", '0')

pMinuscula2     :: Parser Char
pMinuscula2     = pSym(isLower, "minuscula",'a')

pMayuscula2     :: Parser Char
pMayuscula2     = pSym(isUpper, "mayuscula", 'A')

pHexadecimal    :: Parser Char
pHexadecimal    = pSym(isHexDigit, "hexadecimal", 'a')
\end{code}
\caption{Ejemplos de combinadores simples, versión 2} \label{lhc:ex2}
\end{hs}

\subsection{pReturn}
|pReturn| es un \parser\ especial que reconoce la cadena vacía y retorna el símbolo que
recibe como argumento.\\

Ejemplo:
\begin{desc}
\small
\input{031-ejemplo-ejemplo010}
\caption{Ejemplos con |pReturn|}
\end{desc}

Note que el único caso en que no devuelve errores es cuando se le envía una cadena vacía.

\subsection{\verb?<|>?}
El combinador \verb?<|>?, llamado ``combinador alternativo'', tiene la función de combinar 2 o más producciones
en un nuevo parser que reconozca todas las alternativas. 

Este combinador es similar a la función |case of| de \haskell, donde todas las alternativas devuelven 
un determinado tipo de resultado.
De la misma manera, todas las alternativas de este combinador deben tener un mismo tipo.\\

Una aplicación sencilla del combinador \verb?<|>? es cuando se quiere reconocer letras mayúsculas
y minúsculas:

\begin{hs}
\small
\begin{code}
pLetra :: Parser Char
pLetra = pMinuscula <|> pMayuscula
\end{code}
\caption{Ejemplos sencillos}
\end{hs}

\subsection{pFail}
El combinador |pFail| es un combinador especial que siempre falla sin importar la entrada que tenga. 
Por ejemplo:

\begin{desc}
\small
\input{032-ejemplo-ejemplo011}
\caption{Ejemplo de error con |pFail|}
\end{desc}

Una aplicación importante es cuando se tiene al combinador |pFail| como una de las alternativas de \verb?<|>?, 
en ese caso siempre se prefiere revisar las otras alternativas diferentes a |pFail|. Por ejemplo:

\begin{desc}
\small
\input{033-ejemplo-ejemplo012}
\caption{Ejemplo de aplicación de |pFail|}
\end{desc}

\subsection{\verb?<*>?}
El combinador \verb?<*>?, llamado ``combinador de composición secuencial'', combina 2 parsers en uno nuevo. 
La forma de combinar los 2 parsers es aplicando el resultado del primer parser al resultado del segundo.

Por ejemplo, se quiere reconocer un número y añadirle un cero después de reconocerlo:

\begin{desc}
\small
\input{034-ejemplo-ejemplo013}
\caption{Ejemplo con el combinador secuencial}
\end{desc}

En el ejemplo se tiene un primer parser |pNumero| que retorna un caracter número, y un segundo parser |pReturn| 
que devuelve una función que está esperando un caracter para añadirlo junto con un cero a una lista. Así, el resultado del
primer parser se aplica al resultado del segundo parser.\\

Vea que el primer parser es el que está más a la derecha, porque \verb?<*>? tiene una asociación hacia
la derecha, lo que permite usar más de dos parsers sin tener que agruparlos entre paréntesis.\\

Otro ejemplo: se quiere reconocer una letra mayúscula, un número y una letra minúscula. Y agruparlos en una tri-tupla:

\begin{desc}
\small
\input{035-ejemplo-ejemplo014}
\caption{Ejemplo con el combinador secuencial}
\end{desc}

\subsection{\verb?<<|>?}

El combinador \verb?<<|>? es un combinador especial alternativo, este combinador siempre que puede,
da preferencia al parser que se encuentra en el lado izquierdo, y no hace nada con la alternativa
que se encuentra en el lado derecho. Siempre que puede significa encontrar un resultado válido.

En caso de no encontrar un resultado en el lado izquierdo, revisará el lado derecho.\\

Se puede reescribir este combinador para la función opcional `opt':

\begin{desc}
\small
\input{036-ejemplo-ejemplo015}
\caption{Ejemplo con el combinador especial alternativo}
\end{desc}

\section{Combinadores Derivados}

En esta sección se describirá algunos de los combinadores derivados. Para una descripción
detallada, se puede revisar la documentación de librería que corresponde a `Derived'.

\subsection{Combinadores derivados simples}
En base a los combinadores de la anterior sección, la librería define nuevos combinadores
para facilitar su manejo y tener una mejor expresividad:

\begin{desc}
\small
\input{037-ejemplo-ejemplo016}
\caption{Definición de combinadores derivados}
\end{desc}

\subsection{Combinadores Secuenciales}

\subsubsection{pList, pList1, pListSep, pList1Sep}
Estos combinadores permiten reconocer una lista de símbolos especificados por un parser.\\

Por ejemplo, se puede usar |pList| para reconocer una lista de \emph{cero o más} espacios, y devolver
como resultado el número de espacios que se ha reconocido:

\begin{desc}
\small
\input{038-ejemplo-ejemplo017}
\caption{Ejemplos con |pList|}
\end{desc}

La otra variante de |pList| es |pList1|, este combinador reconoce una lista de \emph{uno o más}
símbolos (de ahí su nombre |pList1|), mientras que |pList| reconoce una lista de \emph{cero o más} símbolos.\\

Con estos nuevos combinadores se puede reconocer palabras, números y otras secuencias de símbolos:

\begin{hs}
\small
\begin{code}
palabra     :: Parser String
palabra     = pList1 pLetra

natural     :: Parser String
natural     = pList1 pNumero

espacios    :: Parser String
espacios    = pList1 (pSym ' ')
\end{code}
\caption{Combinadores para lista de símbolos} \label{lhc:basiccomb}
\end{hs}

A continuación se muestra algunos ejemplos para los combinadores del \pref{lhc:basiccomb}:

\begin{desc}
\small
\input{039-ejemplo-ejemplo018}
\caption{Ejemplos para los combinadores definidos en \pref{lhc:basiccomb}}
\end{desc}

Si se quiere reconocer una lista de palabras separadas por espacios, o una lista de números
separados por comas, entonces se puede utilizar los combinadores |pListSep| para reconocer una 
lista de \emph{cero o más} símbolos o |pList1Sep| para reconocer una lista de \emph{uno o más } símbolos.\\

Ambos combinadores reciben un parser para el separador y otro para el símbolo a reconocer. Al construir el 
resultado estos desechan el separador y sólo consideran el símbolo.

Por ejemplo:

\begin{desc}
\small
\input{040-ejemplo-ejemplo019}
\caption{Ejemplos de combinadores con |pListSep| y |pList1Sep|}
\end{desc}

\section{Módulo de Combinadores Elementales}\label{sec:parsersbasicos}

En la sección \ref{sec:modp} se ha definido el módulo e interfaces para comunicarse con la librería, en esta
sección se definirá los combinadores básicos.\\

\subsection{pInutil}

Se comienza con la definición de un combinador que es muy utilizado.
Es común encontrar en las gramáticas símbolos que no son necesarios (es decir inútiles), por ejemplo: espacios, saltos de 
línea, retornos de carro, tabs.\\

En algunos casos puede no haber alguno de estos, para ello se define |pInutil|, pero en otros casos debe al menos
existir uno de ellos, para esos casos se define |pInutil1|.

\begin{hs}
\small
\begin{code}
pInutil     :: Parser String
pInutil     = pList (pAnySym " \n\r\t")

pInutil1    :: Parser String
pInutil1    = pList1 (pAnySym " \n\r\t")
\end{code}
\caption{Combinadores elementales}
\end{hs}

\subsection{pSimbolo y variaciones}
Otra de las tareas comunes es el de reconocer un símbolo compuesto de uno o más caracteres, así como 
en el caso de |pSimbolo|.\\

También puede darse el caso de que se quiera reconocer un símbolo que por el lado derecho, izquierdo
o ambos tiene caracteres inútiles. En esos casos, se desecha los caracteres inútiles y sólo se devuelve
el símbolo reconocido.

\begin{hs}
\small
\begin{code}
pSimbolo    :: String -> Parser String
pSimbolo    = pToken

pSimboloIzq :: String -> Parser String
pSimboloIzq str = pInutil *> pToken str

pSimboloDer :: String -> Parser String
pSimboloDer str = pToken str <* pInutil

pSimboloAmb :: String -> Parser String
pSimboloAmb str = pInutil *> pToken str <* pInutil
\end{code}
\caption{Combinadores elementales, símbolos}
\end{hs}

\subsection{Dígitos, Hexadecimales y Números}

Entre los otros combinadores básicos están los de dígitos y hexadecimales. Estos están definidos con 
|pDigitChar| y |pHex|.\\

En algunos casos se necesita reconocer el signo de un número positivo o negativo, en otros casos sólo
se necesita reconocer el signo de un número positivo.

Pero en ambos casos reconocer el signo es opcional, es por eso que se utiliza el combinador |pMaybe|
para reconocer el signo de un número.

\begin{hs}
\small
\begin{code}
pDigitoChar :: Parser Char
pDigitoChar = pSym(isDigit, "digito", '0')

pHex :: Parser Char
pHex = pSym(isHexDigit, "digito hexadecimal", 'a')

pSigno :: Parser (Maybe Char)
pSigno =  pMaybe (pSym '+' <|> pSym '-')

pSignoMas :: Parser (Maybe Char)
pSignoMas = pMaybe (pSym '+')
\end{code}
\caption{Combinadores elementales, básicos}
\end{hs}

Reconocer un número implica convertir una cadena en el tipo correcto que se necesita (|Int| o |Float|).
La conversión es realizada utilizando la función polimórfica |read|. Se envía la cadena
que se quiere convertir y la función |read| devuelve el número en el tipo deseado. 

El número puede tener un signo, si el signo es negativo, se multiplica el número
por -1, y si es positivo o si no tiene signo se multiplica por 1.

\begin{hs}
\small
\begin{code}
toFloat :: Maybe Char -> String -> Float
toFloat sg str = signo sg * numero
    where  numero = read str
           signo = maybe 1 valorSigno
           valorSigno '+' = 1
           valorSigno '-' = -1

toInt :: Maybe Char -> String -> Int
toInt sg str = signo sg * numero
    where  numero = read str
           signo = maybe 1 valorSigno
           valorSigno '+' = 1
           valorSigno '-' = -1
\end{code}
\caption{Combinadores elementales, funciones}
\end{hs}

Entonces, para reconocer un número entero, se reconoce un signo opcional seguido de una lista
de uno o más caracteres dígitos. En el caso de querer reconocer un número positivo, se reconoce
un signo positivo opcional seguido de la lista de caracteres dígitos:

\begin{hs}
\small
\begin{code}
pEntero :: Parser Int
pEntero     = toInt <$> pSigno <*> pList1 pDigitoChar

pEnteroPos :: Parser Int
pEnteroPos  = toInt <$> pSignoMas <*> pList1 pDigitoChar
\end{code}
\caption{Combinadores elementales, números}
\end{hs}

Para reconocer un número |float| se debe distinguir 3 formas en que un número |float| se puede presentar:

\begin{itemize}
    \item |Digitos|: Un número float puede ser simplemente una lista de dígitos.
    \item |Con punto en medio|: Un número float puede tener un punto en medio de los dígitos. Ejemplo: \emph{123.45}
    \item |Con punto al inicio|: Un número float puede comenzar con un punto y luego los dígitos. Ejemplo: \emph{.125}
          que se considera como si fuera \emph{0.125}
\end{itemize}

En las 3 formas, el signo que viene al principio es opcional.

\begin{hs}
\small
\begin{code}
pNumeroFloat :: Parser Float
pNumeroFloat 
    =    toFloat  <$> pSigno <*> pList1 pDigitoChar
    <|>  (\sg n1 d n2 -> toFloat sg (n1  ++ [d] ++ n2)) 
                  <$> pSigno <*> pList1 pDigitoChar   <*> nums
    <|>  (\sg    d n2 -> toFloat sg ("0" ++ [d] ++ n2)) 
                  <$> pSigno                          <*> nums
    where nums = pSym '.'  <*> pList1 pDigitoChar

pNumeroFloatPos :: Parser Float
pNumeroFloatPos 
    =    toFloat  <$> pSignoMas <*> pList1 pDigitoChar
    <|>  (\sg n1 d n2 -> toFloat sg (n1  ++ [d] ++ n2)) 
                  <$> pSignoMas <*> pList1 pDigitoChar   <*> nums
    <|>  (\sg    d n2 -> toFloat sg ("0" ++ [d] ++ n2)) 
                  <$> pSignoMas                          <*> nums
    where nums = pSym '.'  <*> pList1 pDigitoChar

\end{code}
\caption{Combinadores elementales, números}
\end{hs}

\subsection{Combinadores para texto}

El combinador básico para un texto es reconocer un caracter alfanumérico, así como |pAlphaNum|.

Luego se puede reconocer una palabra con |pPalabra|.

\begin{hs}
\small
\begin{code}
pAlphaNum :: Parser Char
pAlphaNum = pSym(isAlphaNum, "alpha num", 'a')

pPalabra :: Parser String
pPalabra = pList1 pAlphaNum
\end{code}
\caption{Combinadores elementales, palabras}
\end{hs}

En muchos casos se necesita reconocer un texto donde se quiere restringir caracteres no deseados. Así, se ha 
definido el combinador |pTextoRestringido|, que restringe la lista de caracteres que recibe como argumento.

\begin{hs}
\small
\begin{code}
pTextoRestringido :: String -> Parser String
pTextoRestringido deny = pList1 (pSym(fcmp, text, ' '))
    where  fcmp = not . (`elem` deny)
           text = "diferente a " ++ show deny

pHTMLTexto :: Parser String
pHTMLTexto = pTextoRestringido "</>"
\end{code}
\caption{Combinadores elementales, textos} \label{lhc:prest}
\end{hs}

Como ejemplo se ha definido el combinador |pHTMLTexto| del \pref{lhc:prest} que restringe los caracteres `\verb?</>?'.

\subsection{Combinadores para Strings}

Por último, se define los combinadores para reconocer |Strings|. Un |String| puede presentarse de dos formas distintas: 
encerradas entre comillas simples, o encerradas entre comillas dobles. 

Además se tiene 2 tipos de Strings: una simple que contiene sólo texto, y otra compleja que puede tener cualquier 
caracter excepto el de salto de línea y el caracter que se utiliza para limitarlo.\\

Para esto, se ha definido un combinador |pDeLimitarCon| que recibe el parser para el delimitador y el parser para
el contenido. 

En la definición del combinador |pDeLimitarCon| se está utilizando el combinador |pPacked|, que tiene 3 
parámetros, los primeros 2 son los delimitadores, y el 3ro es el parser para el contenido.

\begin{hs}
\small
\begin{code}
pDeLimitarCon :: Parser a -> Parser b -> Parser b
pDeLimitarCon d c = pPacked d d c

pSimpleString  =    pDeLimitarCon (pSym '\"') pPalabra
               <|>  pDeLimitarCon (pSym '\'') pPalabra

pComplexString  =    pDeLimitarCon (pSym '\"') (pTextoRestringido "\"\n")
                <|>  pDeLimitarCon (pSym '\'') (pTextoRestringido "\'\n")
\end{code}
\caption{Combinadores elementales, delimitadores}
\end{hs}

