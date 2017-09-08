
%include lhs2TeX.fmt
\chapter{Parser para \lmarcado} \label{chp:parsermarcado}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Introducción
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\section{Introducción}

%if showChanges
\color{blue}
%endif

En el anterior capítulo se mencionó que la primera tarea era entender y representar la entrada 
para el Navegador Web.
Como resultado, se definió la sintaxis concreta y abstracta para un \lmarcado\ (\pref{sec:lgenerico}), 
lo siguiente es reconocer un ejemplo particular descrito por la sintaxis concreta y representarlo
con la sintaxis abstracta. En otras palabras, se necesita un parser que reconozca la sintaxis concreta
para el lenguaje de marcado y genere como resultado la sintaxis abstracta del mismo.\\

No sería buena idea obligar al usuario a escribir ejemplos particulares de la
estructura \rosa\ directamente en \haskell. Si ése fuera el caso, no se tendría la necesidad de escribir 
un parser para la estructura \rosa.
Sin embargo, cuando el usuario escribe un documento con algún \lmarcado\ ni siquiera se da cuenta, 
ni le interesa, que se está usando una estructura \rosa.
Peor aún, el usuario es capaz de escribir cualquier cosa, pero menos algo que se sujete a un \lmarcado. 
\newline
En estos casos la librería \uuplib, que se utiliza para desarrollar el parser, ayuda a construir un
parser robusto, en el sentido de que la librería es capaz de aplicar correcciones en la entrada, de manera que 
siempre se obtenga entradas correctas.\\

En este capítulo se mostrará el desarrollo de un \parser\ que reconozca la sintaxis concreta de un \lmarcado\ genérico y
genere como resultado la sintaxis abstracta para el \lmarcado.
\newline
La sintaxis concreta y abstracta que se utilizará para el parser está descrita en \pref{sec:lgenerico} 
del \pref{chp:gramaticas}.\\

Se utilizará la librería \uuplib(versión 2.5.5) como herramienta para ``parsear'' la entrada. 
También se utilizará el módulo \emph{CombinadoresBasicos} del \pref{apd:combinadoresbasicos}.\\

En las siguientes secciones, se comenzará definiendo combinadores elementales para un \lmarcado y 
sucesivamente se desarrollará combinadores que permitan reconocer partes de la estructura, 
para luego reconocer todo un \lmarcado.

%if showChanges
\color{black}
%endif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Combinadores Elementales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Combinadores elementales}

\subsection{Parser para las Marcas o Etiquetas}

Se inicia esta sección escribiendo un parser para uno de los principales elementos de un \lmarcado: las marcas o etiquetas.

\begin{desc}
\small
\input{026-ejemplo-ejemplo005}
\caption{Ejemplo de HTML} \label{desc:exhtml1}
\end{desc}

En la \pref{desc:exhtml1} se puede distinguir 3 tipos de etiquetas: 
etiqueta de inicio \verb?<html>?, 
etiqueta de fin \verb?</body>?
y una etiqueta especial \verb?<img/>?.

Utilizando el módulo de |CombinadoresBasicos| del \pref{apd:combinadoresbasicos}, 
el \pref{lhc:etiquetaparser1} define un parser para cada una de las etiquetas:

\begin{hs}
\small
\begin{code}
pTagInicio :: Parser String
pTagInicio = pSimbolo "<" *> pPalabra <* pSimbolo ">"

pTagFin :: Parser String
pTagFin = pSimbolo "</" *> pPalabra <* pSimbolo ">"

pTagEspecial :: Parser String
pTagEspecial = pSimbolo "<" *> pPalabra <* pSimbolo "/>"
\end{code}
\caption{Parser para Etiquetas, versión 1} \label{lhc:etiquetaparser1}
\end{hs}

Seguidamente, se muestra algunos ejemplos para probar el parser para las etiquetas de inicio, 
fin y especiales:

\begin{desc}
\small
\input{041-ejemplo-ejemplo020}
\caption{Ejemplos de prueba para el parser de etiquetas}
\end{desc}

Como se puede ver, un error inesperado ocurrió en el último ejemplo de prueba. Aunque la librería \uuplib\ hizo
las correcciones correspondientes para devolver un resultado correcto, es algo que no debe ocurrir. Estos errores
se deben a que no se está considerando la existencia de espacios entre los símbolos y el nombre de la etiqueta.

Entonces, para corregir el error, se puede decir que una etiqueta puede tener espacios en los lados internos
de los símbolos delimitadores. Así, se modifica el \pref{lhc:etiquetaparser1} de la siguiente manera:

\begin{hs}
\small
\begin{code}
pTagInicio :: Parser String
pTagInicio = pSimboloDer "<" *> pPalabra <* pSimboloIzq ">"

pTagFin :: Parser String
pTagFin = pSimbolo "<" *> pSimboloAmb "/" *> pPalabra <* pSimboloIzq ">"

pTagEspecial :: Parser String
pTagEspecial = pSimboloDer "<" *> pPalabra <* pSimboloAmb "/" <* pSimbolo ">"
\end{code}
\caption{Parser para Etiquetas en Haskell, versión 2}
\end{hs}

\subsection{Parser para el Texto}

Otro de los elementos importantes de un lenguaje de marcado es el texto. El texto puede estar entre
las etiquetas de inicio y fin. 

En un primer intento es posible decir que el parser podría reconocer sencillamente una lista de uno o más caracteres alfanuméricos. 
Pero no se estaría considerando los espacios y saltos de línea.

Luego se podría decir que no solo son los espacios y saltos de línea, sino que también pueden ser otros símbolos como \verb?+(),._ etc?. 
Pero la lista de símbolos a reconocer puede seguir creciendo.

Sin embargo, hay una excepción, el conjunto de símbolos no puede incluir los símbolos \verb?</>?, porque están reservados 
para construir una nueva etiqueta.
Entonces, el conjunto válido de símbolos es cualquier símbolo diferente a: \verb?</>?.

Utilizando el módulo de |CombinadoresBasicos| del \pref{apd:combinadoresbasicos}, su implementación podría ser así:

\begin{hs}
\small
\begin{code}
pTexto :: Parser String
pTexto = pTextoRestringido "</>"
\end{code}
\caption{Parser para un texto}
\end{hs}

Y finalmente se muestra una prueba para reconocer un texto cualquiera:

\begin{desc}
\small
\input{042-ejemplo-ejemplo021}
\caption{Ejemplo de prueba para el parser de un texto}
\end{desc}

\section{Atributos de un \lmarcado}

Continuando con la implementación de parsers, lo siguiente es implementar los atributos que la
etiqueta del lenguaje de marcado puede tener.

Recuerde que la estructura para guardar los atributos es:

\begin{hs}
\small
\begin{code}
type Atributos  = [(Nombre,Valor)]
type Nombre     = String
type Valor      = String
\end{code}
\caption{Tipos de datos para guardar los Atributos de una etiqueta}
\end{hs}

Según la \gconcreta, un atributo es simplemente un identificador seguido de un 
símbolo `=' y una cadena delimitada por comillas dobles.

%if showChanges
\color{blue}
%endif
Y una lista de atributos son los mismos atributos separados por caracteres 
especiales tales como \textit{salto de línea, tabulador y espacio.}\\

El \pref{lhc:patributo} muestra la implementación para los atributos:
%if showChanges
\color{black}
%endif

\begin{hs}
\small
\begin{code}
pAtributo :: Parser (String, String)
pAtributo = (,) <$> pPalabra <* pSimboloAmb "=" <*> pValor

pValor :: Parser String
pValor = pDeLimitadoCon (pSym '"') (pTextoRestringido "\"")

pAtributos :: Parser [(String,String)]
pAtributos = pListSep_ng pInutil1 pAtributo
\end{code}
\caption{Parser para atributos} \label{lhc:patributo}
\end{hs}

\section{Parser para la Estructura \rosa}

Hasta esta parte ya se sabe reconocer elementos básicos de la estructura |Rosadelfa|, lo siguiente
es construir el parser para toda la estructura \rosa.

Para simplificar el desarrollo de esta parte, se definirá una nueva estructura \rosa\ más sencilla que no incluya
atributos.\\

Los tipos de datos para la nueva estructura |Rosadelfa| simple (sin atributos) son:

%if showChanges
\color{blue}
%endif

\begin{hs}
\small
\begin{code}
data SRosa = SimpleRosa SNodo [SRosa]
    deriving Show

data SNodo
    =   SimpleTag   String
    |   SimpleTexto String
    deriving Show
\end{code}
\caption{Tipos de datos para la estructura \rosa\ simple} \label{lhc:rosa2}
\end{hs}

%if showChanges
\color{black}
%endif

La única restricción para escribir el parser del \pref{lhc:rosa2} es que el nombre de la etiqueta de inicio debe ser el mismo
que el nombre de la etiqueta final. Imagínese si fueran nombres diferentes, no se sabría con que nombre identificar la etiqueta.
Pero si los nombres son diferentes, se puede devolver un error o hacer algo al respecto.

También se debe considerar que existe 3 formas de crear una estructura \rosa, la más sencilla es que puede ser simplemente texto.
La otra es que puede ser una etiqueta especial sin ramificaciones, como el |img|. Y el último puede ser una etiqueta normal (inicio y fin)
y con ramificaciones que pueden volver a ser cualquiera de las 3 opciones.\\

A continuación se muestra la implementación de la primera versión:

\begin{hs}
\small
\begin{code}
pSimpleRosa :: Parser SRosa
pSimpleRosa 
    =    rosaTag   <$>  pTagInicio
                          <*> pList_ng pSimpleRosa <*>
                        pTagFin
    <|>  espeTag   <$>  pTagEspecial
    <|>  rosaText  <$>  pTexto

rosaTag :: String -> [SRosa] -> String -> SRosa
rosaTag tinicio tags tfin
    =  if tinicio == tfin
       then SimpleRosa (SimpleTag tinicio) tags
       else error "Nombres diferentes."

espeTag :: String -> SRosa
espeTag tag = rosaTag tag [] tag

rosaText :: String -> SRosa
rosaText str = SimpleRosa (SimpleTexto str) []
\end{code}
\caption{Parser para la estructura Rosadelfa simple} \label{lhc:parserrosa1}
\end{hs}

También se muestra algunos ejemplos de prueba:

\begin{desc}
\small
\input{043-ejemplo-ejemplo022}
\caption{Ejemplos de prueba del parser para la estructura Rosadelfa simple}
\end{desc}

Hasta aquí todo parece estar bien, pero solo hasta que se ve el siguiente error:

\begin{desc}
\small
\input{044-ejemplo-ejemplo023}
\caption{Error generado cuando las etiquetas son diferentes} \label{desc:errorDesc}
\end{desc}

El resultado de la \pref{desc:errorDesc} es correcto, pero no el deseado. Porque al principio del capítulo
se mencionó que la librería \uuplib hace correcciones. Pero el anterior código no muestra ninguna
corrección.
En realidad la librería no tiene nada que corregir, porque quien genera la excepción es el código que se ha 
escrito y no el de la librería. Sin embargo, no es el resultado deseado.\\

Algo que se puede hacer en la función |tagRosa| del \pref{lhc:parserrosa1} es que si las etiquetas son diferentes, 
se podría devolver un tipo de dato |SRosa| con la primera etiqueta, pero obviando la segunda:

\begin{hs}
\small
\begin{code}
rosaTag2 :: String -> [SRosa] -> String -> SRosa
rosaTag2 tinicio tags tfin
    = if tinicio == tfin
      then SimpleRosa (SimpleTag tinicio) tags
      else SimpleRosa (SimpleTag tinicio) tags
\end{code}
\caption{Segunda versión para la función |tagRosa|}
\end{hs}

Haciendo la última corrección en el código, ya de nada sirve hacer una comparación 
entre etiquetas, porque su código es el mismo. Entonces, esta solución no es buena, aunque es válida.\\

Sería interesante si se pudiera hacerle responsable a la librería \uuplib\ de la corrección de la entrada.
Pero antes se necesita entender mejor la forma en que la librería \uuplib hace las correcciones.

\subsection{Las correcciones que realiza la librería \textit{uu-parsinglib}}

Para entender la forma en que la librería las correcciones, considere
el siguiente |parser| que reconoce caracteres dígitos:

\begin{hs}
\small
\begin{code}
pDigito :: Parser Char
pDigito = pSym(isDigit, "isDigit", '0')
\end{code}
\end{hs}

A continuación se muestra algunos ejemplo de prueba para el |parser| de dígitos:

\begin{desc}
\small
\input{045-ejemplo-ejemplo024}
\caption{Ejemplos de prueba para el parser de dígitos}
\end{desc}

El primer parámetro de |pSym| es una función booleana\footnote{Que devuelve un resultado de tipo |Bool| (|False|, |True|)}
que determina que carácter será aceptado,
el segundo y tercer parámetro están relacionados con la corrección de errores. Por ejemplo, la última prueba
a |pDigito|, indica (primer mensaje) que se borró el carácter 'a` (\verb?Deleted 'a'?) porque no se logro satisfacer
la función |isDigit|. En la segunda, se indica que se insertó el carácter '0` (\verb?Inserted '0'?) porque 
es el carácter por defecto del parser.

Entonces, el segundo parámetro determina el nombre de lo que se está esperando (String)
y el tercero es el carácter por defecto que se insertará en caso de errores.\\

Por ejemplo, si se cambia el parser para |pDigito = pSym(isDigit, "digito", '9')|, entonces 
se insertará un |9| en vez de un |0| y el mensaje será ``digito'' y no ``isDigit'':

\begin{desc}
\small
\input{046-ejemplo-ejemplo025}
\caption{Ejemplo de prueba para el parser de dígitos}
\end{desc}

Entonces, las correcciones de la librería \uuplib se realizan mediante las funciones que determinan los valores que
se está esperando en la entrada. Así, si la entrada no es correcta, se inserta o elimina valores para que sea correcta.\\

Existen varias formas de reconocer un carácter simple, por ejemplo:

\begin{hs}
\small
\begin{code}
pa'  = pSym (=='a', "letra a", 'a')
pa   = pSym 'a'
\end{code}
\end{hs}

En la última definición, ambas versiones hacen lo mismo.
De la misma forma, si se quiere reconocer una lista de caracteres, se puede definir el combinador |pToken|:

\begin{hs}
\small
\begin{code}
pal   = pToken "carlos"

pToken []       = pReturn []
pToken (a:as)   = (:) <$> pSym a <*> pToken as
\end{code}
\end{hs}

El combinador |pToken|, la cual no es necesario redefinirla porque se encuentra dentro de la 
librería, reconoce una lista de símbolos con el combinador |pSym|. 

Entonces, la función |pSym| es una de las funciones principales de la librería. 
Se puede decir que las demás funciones de la librería trabajan en base a |pSym|.\\

Ahora, todo esto tiene sentido cuando se crea un \parser que reconozca un conjunto de caracteres, por ejemplo el nombre
de una etiqueta. De manera que la librería se encargue de reconocer el nombre de una etiqueta y si no lo encuentra, 
aplique correcciones en la entrada. Esta función puede ser definida de la siguiente manera:

\begin{hs}
\small
\begin{code}
pNombreTag :: String -> Parser String
pNombreTag = pToken
\end{code}
\caption{Parser para el nombre de una etiqueta en Haskell} \label{lhc:pNombreTag}
\end{hs}

\vspace{1cm}

A continuación se muestra un ejemplo de prueba para el parser del \pref{lhc:pNombreTag}:

\begin{desc}
\small
\input{047-ejemplo-ejemplo026}
\caption{Ejemplo de prueba para el parser |pNombreTag|}
\end{desc}

Entonces, si se envía a |pNombreTag "html"| una entrada incorrecta, la librería realizará las correcciones necesarias hasta 
obtener lo que se desea.\\

Con todo esto, es posible decirle a la librería que se está esperando ciertos nombres de etiquetas y si no los encuentra
que aplique correcciones.
Pero para aplicar la idea anterior, se necesita conocer al menos el nombre de la etiqueta que se desea esperar. Es decir, se necesita 
obtener el nombre de la etiqueta de inicio, para luego decirle a la librería que se está esperando una etiqueta final con el
mismo nombre.

Se necesita algo como lo siguiente:

\begin{desc}
\small
\input{048-ejemplo-ejemplo027}
\caption{Ejemplo Ideal para el parser de elementos} \label{lst:uulet}
\end{desc}

El código que se acaba de mostrar es incorrecto porque no se tiene acceso a 
la información de parsing intermedia.
Pero la librería \uuplib provee la interfaz monádica para resolver este problema.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Interface Monódica para uu-parsinglib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\subsection{Interfaz Monádica de \uuplib}

Una extensión interesante que permite tener éxito con el anterior problema es utilizar la interfaz monádica de \uuplib.\\

La interfaz monádica permite acceder a la información que se está revisando en el proceso. 
De manera que es posible utilizar esta información para redirigir el proceso de parsing.

Por ejemplo, si se quiere construir una pequeña función para construir etiquetas para un lenguaje de marcado, primeramente se define
una función que recibe el nombre de una etiqueta y su cuerpo, luego se podría usar la interfaz monádica de Haskell
para guardar el nombre de la etiqueta inicio y fin para usarlos luego en la construcción de la etiqueta.
Su implementación podría ser de la siguiente manera:

\begin{hs}
\small
\begin{code}
crearITag :: String -> IO String
crearITag tag = return ("<" ++ tag ++ ">")

crearFTag :: String -> IO String
crearFTag tag = return ("</" ++ tag ++ ">")


tagged :: String -> String -> IO String
tagged tag cuerpo = do  tag1 <- crearITag tag
                        tag2 <- crearFTag tag
                        return (tag1 ++ cuerpo ++ tag2)
\end{code}
\caption{Ejemplo simple utilizando mónadas}
\end{hs}

Vea que la notación \textbf{do} se parece a la notación \textbf{let~in} de \haskell, 
básicamente, porque se está creando variables dentro la notación |do|, las cuales 
son utilizadas posteriormente para construir una etiqueta.\\

Se puede utilizar la misma idea para construir el parser para etiquetas. Por ejemplo,
se puede usar variables para almacenar el resultado de un parser y luego usarlas para redirigir 
el proceso de parsing.

A continuación se muestra la implementación de parser para etiquetas utilizando la interfaz monádica
de \uuplib:

\begin{hs}
\small
\begin{code}
pFinalTag :: String -> Parser String
pFinalTag tag = pSimbolo "<" *> pSimboloAmb '/' *> pToken tag <* pSimboloIzq '>'

pMTag :: Parser SRosa
pMTag  =    do  itag    <- pTagInicio2
                rami    <- pList_ng pMTag
                ftag    <- pFinalTag itag
                return (rosaTag itag rami ftag)
       <|>  rosaText <$> pTexto
\end{code}
\caption{Ejemplo con Interfaz Monádica} \label{lhc:pMTag}
\end{hs}

En el \pref{lhc:pMTag} se ha definido el combinador |pFinalTag| que reconoce una determinada etiqueta (|String|) con el parámetro que
recibe. Este combinador es el que se encarga de corregir la entrada en caso de errores.

También se tiene la función |pMTag| que hace uso de la interfaz monádica, el cual crea una variable para 
guardar la etiqueta de inicio y enviarlo a |pFinalTag| para construir la estructura final correcta.\\


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Versión Final
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Parser final para la estructura \rosa\ y sus optimizaciones}

Antes de mostrar la versión final del \parser\ \rosa\ que se ha desarrollado, se corregirá un error
que se produce en el parser del \pref{lhc:pMTag}, lo cual puede considerarse como una optimización
al parser que se ha definido.\\

Si se añade soporte para etiquetas especiales al parser del \pref{lhc:pMTag}, entonces se tendría:

\begin{hs}
\small
\begin{code}
pMTag2 :: Parser SRosa
pMTag2  =    do  itag    <- pTagInicio2
                 rami    <- pList_ng pMTag
                 ftag    <- pFinalTag itag
                 return (rosaTag itag rami ftag)
        <|>  espeTag   <$> pTagEspecial2
        <|>  rosaText  <$> pTexto
\end{code}
\caption{Ejemplo con Interfaz Monádica y etiquetas especiales} \label{lhc:pMTag2}
\end{hs}

Luego, si se prueba el parser del \pref{lhc:pMTag2} con un ejemplo, entonces se produce 
el siguiente error:

\begin{desc}
\small
\input{023-ejemplo-ejemplo002}
\caption{Error que produce el parser del \pref{lhc:pMTag2}} \label{desc:error}
\end{desc}

Para corregir el error de la \pref{desc:error} se ha convenido en optimizar la definición del parser 
con una factorización de las partes comunes de |pTagInicio2| y |pTagEspecial2|.

\subsection{Optimizaciones}

Hay una pequeña optimización que se puede hacer al código. Fíjese en detalle lo que las siguientes 
definiciones de parsers tienen en común:

\begin{hs}
\small
\begin{code}
pTagInicio :: Parser String
pTagInicio      = pSimboloDer "<"   *> pPalabra                     <* pSimboloIzq  ">"

pTagEspecial :: Parser String
pTagEspecial    = pSimboloDer "<"   *> pPalabra <* pSimboloAmb "/"  <* pSimbolo     ">"
\end{code}
\caption{Parser semi comunes}
\end{hs}

Se puede decir que ambos parsers tienen algo en común, básicamente esto es: 
\newline
|pSimboloDer "<" *> pPalabra|.
No es buena idea permitir repetir libremente lo que tiene en común, porque podría ser la causa del error
ya que habría más consumo de memoria y procesamiento innecesario.\\

Por lo tanto, se podría optimizar lo siguiente:

\begin{hs}
\small
\begin{code}
pSimpleRosa :: Parser SRosa
pSimpleRosa 
    =   rosaTag  <$>    pTagInicio
                            <*> pList_ng pSimpleRosa <*>
                        pTagFin 
   <|>  espeTag  <$> pTagEspecial
   <|>  rosaText <$> pTexto
\end{code}
\caption{Parser Rosadelfa con 3 alternativas}
\end{hs}

Fíjese que se tiene 3 alternativas. Si se separa la versión común, se puede obtener una nueva versión 
con sólo 2 alternativas:

\begin{hs}
\small
\begin{code}
pSimpleRosa2 :: Parser SRosa
pSimpleRosa2 
    =   rosaTag2    <$>    pComunTagInicio <*> pRestoTagInicio
   <|>  rosaText    <$>    pTexto

pComunTagInicio :: Parser String
pComunTagInicio = pSimboloDer "<" *> pPalabra

pRestoTagInicio :: Parser [SRosa]
pRestoTagInicio =   id  <$>  pList_ng pSimpleRosa <* pTagFin
               <|>  []  <$   pSimboloAmb "/" *> pSimbolo ">"
\end{code}
\caption{Parser Rosadelfa con 2 alternativas}
\end{hs}

Otra forma de optimizar podría ser haciendo uso de la interfaz monádica. Esta forma es la que 
se utilizó en la versión final del \parser\ \rosa.

\subsection{Versión Final}
En está versión se añadirá la parte de los atributos y se hará la versión monádica
de la optimización.\\

Primeramente se define las funciones constructoras de estructuras \rosa. Una para el
texto y otra para las etiquetas (que recibe el nombre de la etiqueta, sus atributos y el cuerpo de la etiqueta).

\begin{hs}
\small
\begin{code}
rosaTexto :: String -> ArbolRosa
rosaTexto str = ArbolRosa (NTexto str) []

rosaTagged :: String -> [(String,String)] -> [ArbolRosa] -> ArbolRosa
rosaTagged nm ats rms = ArbolRosa (NTag nm ats) rms
\end{code}
\caption{Parser para \rosa, funciones constructoras}
\end{hs}

Un \parser\ para la estructura \rosa\ es básicamente un texto o un |tagged| (una etiqueta normal 
o una etiqueta especial):

\begin{hs}
\small
\begin{code}
pRosadelfa :: Parser ArbolRosa
pRosadelfa  =       pRosaTagged 
            <|>     pRosaTexto

pRosaTexto :: Parser ArbolRosa
pRosaTexto  = rosaTexto  <$> pTexto
\end{code}
\caption{Parser para \rosa, elementos básicos}
\end{hs}

Para implementar la versión optimizada, se debe separar la etiqueta de inicio en parte común
y la parte restante.
Luego se debe preguntar a la parte restante, si es una etiqueta especial o una etiqueta normal
y se continua reconociendo la parte que falta. Si la parte restante es una etiqueta especial, 
entonces significa que no tiene cuerpo y se devuelve una lista vacía, caso contrario
se debe procesar el cuerpo seguido de la etiqueta final.

\begin{hs}
\small
\begin{code}
pRosaTagged :: Parser ArbolRosa
pRosaTagged 
    = do    (itag,mp)  <- pComunTag
            bool       <- pRestoTagInicio
            ramif      <-   if bool 
                            then return []
                            else pList_ng pRosadelfa <* pFinalTag itag
            return (rosaTagged itag mp ramif)

pComunTag :: Parser (String,[(String,String)])
pComunTag = (,) <$ pSimboloDer '<' <*> pPalabra2 <* pInutil <*> pAtributos

pRestoTagInicio :: Parser Bool
pRestoTagInicio     =       False <$ pSimboloIzq '>'
                    <|>     True  <$ pSimbolo '/' <* pSym '>'

pFinalTag :: String -> Parser String
pFinalTag tag = pSym '<' *> pSimbolo '/' *> pToken tag <* pSimboloIzq '>'
\end{code}
\caption{Parser para \rosa, versión monádica}
\end{hs}

Note que se esta integrando el combinador para atributos en la parte común de la etiqueta.


