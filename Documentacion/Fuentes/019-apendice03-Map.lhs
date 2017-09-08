
%include uuagc.fmt

\chapter{Documentación de la librería Map} \label{apd:map}

En este apéndice se mostrará la documentación de la librería |Map| de Haskell.
Sólo se mostrará las funciones que son relevantes al proyecto. 
La versión original, que se encuentra en el idioma Ingles, está en la siguiente dirección URL:

\url{http://haskell.org/ghc/docs/7.0-latest/html/libraries/containers-0.4.0.0/}

\url{Data-Map.html}\\

Este apéndice sólo es una transcripción de la versión en Ingles, de las partes más relevantes
de la documentación de la librería.


\section{Descripción}

Una implementación eficiente de maps de claves a valores (diccionarios).

Como que los nombres de las funciones (pero no del tipo) pueden entrar en conflicto con los nombres del Preludio de Haskell,
este modulo es normalmente importado de manera renombrada (qualified), por ejemplo

\begin{hs}
\small
\begin{code}
  import Data.Map (Map)
  import qualified Data.Map as Map
\end{code}
\end{hs}

La implementación de |Map| está basado en un árbol binario de tamaño balanceado (o árboles de balance limitado), que 
está descrito en:\\

\textit{Stephen Adams, ``Efficient sets: a balancing act'', Journal of Functional Programming 3(4):553-562, October 1993, 
\url{http://www.swiss.ai.mit.edu/$~$adams/BB/}}.

\textit{J. Nievergelt and E.M. Reingold, ``Binary search trees of bounded balance'', SIAM journal of computing 2(1), March 1973.}\\

Vea que la implementación es de preferencia-por-izquierda, es decir que los elementos de un primer argumento son preferidos ante el
segundo, por ejemplo en |union| o |insert|.
Los comentarios contienen el tiempo de complejidad en notación Big-O (\url{http://en.wikipedia.org/wiki}
\newline
\url{/Big\_O\_notation}).

\section{El tipo Map}

\begin{hs}
\small
\begin{code}
data Map k a
\end{code}
\end{hs}

Un |Map| de claves `k' a valores `a'.

\section{Operadores}

\subsection{|(!) :: Ord k => Map k a -> k -> a|}

|O(log n).| Encontrar el valor de una clave. Se lanza un error cuando el elemento se encuentra.
\begin{hs}
\small
\begin{code}
 fromList [(5,'a'), (3,'b')] ! 1        Error: el elemento no esta en el map
 fromList [(5,'a'), (3,'b')] ! 5 == 'a'
\end{code}
\end{hs}

\subsection{|(\\) :: Ord k => Map k a -> Map k b -> Map k a|}
Lo mismo que la operación de diferencia.


\section{Consulta}

\subsection{|null :: Map k a -> Bool|}

|O(1).| ¿Esta el map vacío?
\begin{hs}
\small
\begin{code}
Data.Map.null (empty)               ==  True
Data.Map.null (singleton 1 'a')     ==  False
\end{code}
\end{hs}

\subsection{|size :: Map k a -> Int|}

|O(1).| El número de elementos en el map.
\begin{hs}
\small
\begin{code}
size empty                                      ==  0
size (singleton 1 'a')                          ==  1
size (fromList([(1,'a'), (2,'c'), (3,'b')]))    ==  3
\end{code}
\end{hs}

\subsection{|member :: Ord k => k -> Map k a -> Bool|}

|O(log n).| ¿Es la clave miembro del map?, también vea |notMember|.
\begin{hs}
\small
\begin{code}
member 5 (fromList [(5,'a'), (3,'b')])     ==  True
member 1 (fromList [(5,'a'), (3,'b')])     ==  False
\end{code}
\end{hs}

\subsection{|notMember :: Ord k => k -> Map k a -> Bool|}

|O(log n).| ¿No es clave miembro del map?, también vea |member|.
\begin{hs}
\small
\begin{code}
notMember 5 (fromList [(5,'a'), (3,'b')])  ==  False
notMember 1 (fromList [(5,'a'), (3,'b')])  ==  True
\end{code}
\end{hs}

\subsection{|lookup :: Ord k => k -> Map k a -> Maybe a|}

|O(log n).| Buscar el valor de una clave en el map.
La función retornará el correspondiente valor como (|Just value|), o |Nothing| si la clave no se encuentra en el map.\\

Un ejemplo del uso de |lookup|:
\begin{hs}
\small
\begin{code}
import Prelude hiding (lookup)
import Data.Map

employeeDept        = fromList([("John","Sales"), ("Bob","IT")])
deptCountry         = fromList([("IT","USA"), ("Sales","France")])
countryCurrency     = fromList([("USA", "Dollar"), ("France", "Euro")])

employeeCurrency :: String -> Maybe String
employeeCurrency name 
    =  do  dept <- lookup name employeeDept
           country <- lookup dept deptCountry
           lookup country countryCurrency

main = do   putStrLn $ "John's currency: " ++ (show (employeeCurrency "John"))
            putStrLn $ "Pete's currency: " ++ (show (employeeCurrency "Pete"))
\end{code}
\end{hs}

A continuación se muestra el resultado:
\begin{hs}
\small
\begin{code}
John's currency :   Just "Euro"
Pete's currency :   Nothing
\end{code}
\end{hs}

\subsection{|findWithDefault :: Ord k => a -> k -> Map k a -> a|}

|O(log n).| La expresión (|findWithDefault def k map|) retorna el valor de la clave `k' o retorna
el valor por defecto `def' cuando la clave no está en el map.
\begin{hs}
\small
\begin{code}
findWithDefault 'x' 1 (fromList [(5,'a'), (3,'b')])    ==  'x'
findWithDefault 'x' 5 (fromList [(5,'a'), (3,'b')])    ==  'a'
\end{code}
\end{hs}


\section{Construcción}

\subsection{|empty :: Map k a|}

|O(1).| El map vacío.
\begin{hs}
\small
\begin{code}
empty      == fromList []
size empty == 0
\end{code}
\end{hs}

\subsection{|singleton :: k -> a -> Map k a|}

|O(1).| Un map con sólo un elemento.
\begin{hs}
\small
\begin{code}
singleton 1 'a'         == fromList [(1, 'a')]
size (singleton 1 'a')  == 1
\end{code}
\end{hs}

\subsection{Insertar}

\subsubsection{|insert :: Ord k => k -> a -> Map k a -> Map k a|}

|O(log n).| Insertar una nueva clave y valor en el map. Si la clave está presente en el map, 
el valor asociado es reemplazado con el valor recibido. |insert| es equivalente a |insertWith const|.
\begin{hs}
\small
\begin{code}
insert 5 'x' (fromList [(5,'a'), (3,'b')])  ==  fromList [(3, 'b'), (5, 'x')]
insert 7 'x' (fromList [(5,'a'), (3,'b')])  ==  fromList [(3, 'b'), (5, 'a'), (7, 'x')]
insert 5 'x' empty                          ==  singleton 5 'x'
\end{code}
\end{hs}

\subsubsection{|insertWith :: Ord k => (a -> a -> a) -> k -> a -> Map k a -> Map k a|}

|O(log n).| Insertar con una función, que combina el nuevo y antiguo valor.
\newline
|insertWith f key value mp| insertará la tupla |(key, value)| en `mp' si la clave `key'
no existe en el map. Si la clave existe, la función insertará la tupla
|(key, f new_value old_value)|.
\begin{hs}
\small
\begin{code}
insertWith (++) 5 "xxx" (fromList [(5,"a"), (3,"b")])   ==  fromList [(3, "b"), (5, "xxxa")]
insertWith (++) 7 "xxx" (fromList [(5,"a"), (3,"b")])   ==  fromList [(3, "b"), (5, "a"), (7, "xxx")]
insertWith (++) 5 "xxx" empty                           ==  singleton 5 "xxx"
\end{code}
\end{hs}

\subsubsection{|insertWithKey :: Ord k => (k -> a -> a -> a) -> k -> a -> Map k a -> Map k a|}

|O(log n).| Insertar con una función, se combina la clave, nuevo valor y antiguo valor.

|insertWithKey f key value mp| insertará la tupla |(key, value)| en el `mp' if la clave
no se encuentra en el map. Si la clave existe, la función insertará la tupla \newline
|(key,f key new_value old_value)|. Vea que la clave pasada a `f' es la misma clave pasada a 
|insertWithKey|.
\begin{hs}
\small
\begin{code}
let f key new_value old_value = (show key) ++ ":" ++ new_value ++ "|" ++ old_value
insertWithKey f 5 "xxx" (fromList [(5,"a"), (3,"b")])   
    ==  fromList [(3, "b"), (5, "5:xxx|a")]
insertWithKey f 7 "xxx" (fromList [(5,"a"), (3,"b")])   
    ==  fromList [(3, "b"), (5, "a"), (7, "xxx")]
insertWithKey f 5 "xxx" empty                           
    ==  singleton 5 "xxx"
\end{code}
\end{hs}

\subsection{Eliminar/Actualizar}

\subsubsection{|delete :: Ord k => k -> Map k a -> Map k a|}

|O(log n).| Elimina una clave y su valor del map. Cuando la clave no es un miembro del map,
el map original es retornado.
\begin{hs}
\small
\begin{code}
delete 5 (fromList [(5,"a"), (3,"b")])  ==  singleton 3 "b"
delete 7 (fromList [(5,"a"), (3,"b")])  ==  fromList [(3, "b"), (5, "a")]
delete 5 empty                          ==  empty
\end{code}
\end{hs}

\subsubsection{|adjust :: Ord k => (a -> a) -> k -> Map k a -> Map k a|}

|O(log n).| Actualizar el valor de una clave específica con el resultado de la función proveída.
Cuando la clave no es miembro del map, el map original es devuelto.
\begin{hs}
\small
\begin{code}
adjust ("new " ++) 5 (fromList [(5,"a"), (3,"b")])  ==  fromList [(3, "b"), (5, "new a")]
adjust ("new " ++) 7 (fromList [(5,"a"), (3,"b")])  ==  fromList [(3, "b"), (5, "a")]
adjust ("new " ++) 7 empty                          ==  empty
\end{code}
\end{hs}

\subsubsection{|adjustWithKey :: Ord k => (k -> a -> a) -> k -> Map k a -> Map k a|}

|O(log n).| Ajustar el valor de  una clave específica. Cuando la clave no es un miembro del map,
el map original es devuelto.
\begin{hs}
\small
\begin{code}
let f key x = (show key) ++ ":new " ++ x
adjustWithKey f 5 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "5:new a")]
adjustWithKey f 7 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "a")]
adjustWithKey f 7 empty                         == empty
\end{code}
\end{hs}

\subsubsection{|update :: Ord k => (a -> Maybe a) -> k -> Map k a -> Map k a|}

|O(log n).| La expresíon (|update f k map|) actualiza el valor de `x' en `k' (si esta en el map).
If (|f x|) es |Nothing|, el elemento es eliminado. Si es (|Just y|), la clave `k' es cambiada al nuevo valor `y'.
\begin{hs}
\small
\begin{code}
let f x = if x == "a" then Just "new a" else Nothing
update f 5 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "new a")]
update f 7 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "a")]
update f 3 (fromList [(5,"a"), (3,"b")]) == singleton 5 "a"
\end{code}
\end{hs}

\subsubsection{|updateWithKey :: Ord k => (k -> a -> Maybe a) -> k -> Map k a -> Map k a|}

|O(log n).| La expresión (|updateWithKey f k map|) actualiza el valor `x' en `k' (si esta en el map).
Si (|f k x|) es |Nothing|, el elemento es eliminado. Si es (|Just y|), la clave `k' es cambiada al nuevo valor `y'.
\begin{hs}
\small
\begin{code}
let f k x = if x == "a" then Just ((show k) ++ ":new a") else Nothing
updateWithKey f 5 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "5:new a")]
updateWithKey f 7 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "a")]
updateWithKey f 3 (fromList [(5,"a"), (3,"b")]) == singleton 5 "a"
\end{code}
\end{hs}

\subsubsection{|alter :: Ord k => (Maybe a -> Maybe a) -> k -> Map k a -> Map k a|}

|O(log n).| La expresión (|alter f k map|) altera el valor de `x' en `k', o su ausencia.
|alter| puede ser usado para insertar, eliminar, o actualizar un valor en el |Map|.
En palabras simples: |lookup k (alter f k m) = f (lookup k m)|
\begin{hs}
\small
\begin{code}
let f _ = Nothing
alter f 7 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "a")]
alter f 5 (fromList [(5,"a"), (3,"b")]) == singleton 3 "b"

let f _ = Just "c"
alter f 7 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "a"), (7, "c")]
alter f 5 (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "c")]
\end{code}
\end{hs}


\section{Combine}

\subsection{Unión}

\subsubsection{|union :: Ord k => Map k a -> Map k a -> Map k a|}

|O(n+m).| La expresión (|union t1 t2|) toma la unión de preferencia-por-izquierda de t1 y t2.
Prefiere t1 cuando se encuentran duplicados, por ejemplo, (|union == unoinWith const|).
La implementación usa el algoritmo \textit{hedge-union}. \textit{hedge-union} es más eficiente en (|bigset `union` smallset|).
\begin{hs}
\small
\begin{code}
union (fromList [(5, "a"), (3, "b")]) (fromList [(5, "A"), (7, "C")]) 
    == fromList [(3, "b"), (5, "a"), (7, "C")]
\end{code}
\end{hs}

\subsubsection{|unionWith :: Ord k => (a -> a -> a) -> Map k a -> Map k a -> Map k a|}

|O(n+m).| Unión con una función de combinación. La implementación utiliza el algoritmo \textit{hedge-union}.
\begin{hs}
\small
\begin{code}
unionWith (++) (fromList [(5, "a"), (3, "b")]) (fromList [(5, "A"), (7, "C")]) 
    == fromList [(3, "b"), (5, "aA"), (7, "C")]
\end{code}
\end{hs}

\subsubsection{|unionWithKey :: Ord k => (k -> a -> a -> a) -> Map k a -> Map k a -> Map k a|}

|O(n+m).| Unión con una función de combinación. 
\begin{hs}
\small
\begin{code}
let f key left_value right_value 
    = (show key) ++ ":" ++ left_value ++ "|" ++ right_value
unionWithKey f (fromList [(5, "a"), (3, "b")]) (fromList [(5, "A"), (7, "C")]) 
    == fromList [(3, "b"), (5, "5:a|A"), (7, "C")]
\end{code}
\end{hs}

\section{Recorrido}

\subsection{Map}

\subsubsection{|map :: (a -> b) -> Map k a -> Map k b|}

|O(n).| Mapear una función sobre todos  los valores de map.
\begin{hs}
\small
\begin{code}
map (++ "x") (fromList [(5,"a"), (3,"b")]) == fromList [(3, "bx"), (5, "ax")]
\end{code}
\end{hs}

\subsubsection{|mapWithKey :: (k -> a -> b) -> Map k a -> Map k b|}

|O(n).| Mapear una función sobre todos los valores en el map.
\begin{hs}
\small
\begin{code}
let f key x = (show key) ++ ":" ++ x
mapWithKey f (fromList [(5,"a"), (3,"b")]) == fromList [(3, "3:b"), (5, "5:a")]
\end{code}
\end{hs}

\subsection{Fold}

\subsubsection{|fold :: (a -> b -> b) -> b -> Map k a -> b|}

|O(n).| |Fold| los valores en el map, de manera que |fold f z == foldr f z . elems|. 
Por ejemplo,
\begin{hs}
\small
\begin{code}
elems map = fold (:) [] map
let f a len = len + (length a)
fold f 0 (fromList [(5,"a"), (3,"bbb")]) == 4
\end{code}
\end{hs}

\subsubsection{|foldWithKey :: (k -> a -> b -> b) -> b -> Map k a -> b|}

|O(n).| |Fold| las claves y valores en el map, de manera que 

|foldWithKey f z == foldr (uncurry f) z . toAscList|. 

Por ejemplo,
\begin{hs}
\small
\begin{code}
keys map = foldWithKey (\k x ks -> k:ks) [] map
let f k a result = result ++ "(" ++ (show k) ++ ":" ++ a ++ ")"
foldWithKey f "Map: " (fromList [(5,"a"), (3,"b")]) == "Map: (5:a)(3:b)"
\end{code}
\end{hs}

Esto es idéntico a |foldrWithKey|, y usted debería usar aquella en vez de esta. Su nombre es guardado sólo por compatibilidad.

\subsubsection{|foldrWithKey :: (k -> a -> b -> b) -> b -> Map k a -> b|}

|O(n).| Post-order fold. La función es aplicada desde el valor más pequeño al más grande.

\subsubsection{|foldlWithKey :: (b -> k -> a -> b) -> b -> Map k a -> b|}

O(n). Pre-order fold. La función será aplicada desde el valor más pequeño al más grande.

\section{Conversión}

\subsection{|elems :: Map k a -> [a]|}

|O(n).| Retornar todos los elementos del map en orden ascendente de sus claves.
\begin{hs}
\small
\begin{code}
elems (fromList [(5,"a"), (3,"b")]) == ["b","a"]
elems empty == []
\end{code}
\end{hs}

\subsection{|keys :: Map k a -> [k]|}

|O(n).| Retornar todas las claves del map en orden ascendente.
\begin{hs}
\small
\begin{code}
keys (fromList [(5,"a"), (3,"b")]) == [3,5]
keys empty == []
\end{code}
\end{hs}

\subsection{Listas}

\subsubsection{|toList :: Map k a -> [(k, a)]|}

|O(n).| Convertir a una lista de tupla de clave/valor.
\begin{hs}
\small
\begin{code}
toList (fromList [(5,"a"), (3,"b")]) == [(3,"b"), (5,"a")]
toList empty == []
\end{code}
\end{hs}

\subsubsection{|fromList :: Ord k => [(k, a)] -> Map k a|}

|O(n*log n).| Construir un map desde una lista de tuplas clave/valor.
Vea también |fromAscList|. Si la lista contiene más de un valor para la misma clave, el último
valor para la clave es retenido.
\begin{hs}
\small
\begin{code}
fromList [] == empty
fromList [(5,"a"), (3,"b"), (5, "c")] == fromList [(5,"c"), (3,"b")]
fromList [(5,"c"), (3,"b"), (5, "a")] == fromList [(5,"a"), (3,"b")]
\end{code}
\end{hs}

\section{Filtro}

\subsection{|filter :: Ord k => (a -> Bool) -> Map k a -> Map k a|}

|O(n).| Filtrar todos los valores que satisfagan el predicado.
\begin{hs}
\small
\begin{code}
filter (> "a") (fromList [(5,"a"), (3,"b")]) == singleton 3 "b"
filter (> "x") (fromList [(5,"a"), (3,"b")]) == empty
filter (< "a") (fromList [(5,"a"), (3,"b")]) == empty
\end{code}
\end{hs}

\subsection{|filterWithKey :: Ord k => (k -> a -> Bool) -> Map k a -> Map k a|}

|O(n).| Filtrar todos los valores que satisfagan el predicado.
\begin{hs}
\small
\begin{code}
filterWithKey (\k _ -> k > 4) (fromList [(5,"a"), (3,"b")]) == singleton 5 "a"
\end{code}
\end{hs}

\subsection{|mapMaybe :: Ord k => (a -> Maybe b) -> Map k a -> Map k b|}

|O(n).| Mapear los valores y coleccionar los resultado |Just|.
\begin{hs}
\small
\begin{code}
let f x = if x == "a" then Just "new a" else Nothing
mapMaybe f (fromList [(5,"a"), (3,"b")]) == singleton 5 "new a"
\end{code}
\end{hs}

\subsection{|mapMaybeWithKey :: Ord k => (k -> a -> Maybe b) -> Map k a -> Map k b|}

|O(n).| Mapear clave/valor y coleccionar los resultado |Just|.
\begin{hs}
\small
\begin{code}
let f k _ = if k < 5 then Just ("key : " ++ (show k)) else Nothing
mapMaybeWithKey f (fromList [(5,"a"), (3,"b")]) == singleton 3 "key : 3"
\end{code}
\end{hs}


\section{Índice}

\subsection{|elemAt :: Int -> Map k a -> (k, a)|}

|O(log n).| Recuperar un elemento por el índice. Se lanza un error cuando el índice no es válido.
\begin{hs}
\small
\begin{code}
elemAt 0 (fromList [(5,"a"), (3,"b")]) == (3,"b")
elemAt 1 (fromList [(5,"a"), (3,"b")]) == (5, "a")
elemAt 2 (fromList [(5,"a"), (3,"b")])    Error: index out of range
\end{code}
\end{hs}

\subsection{|updateAt :: (k -> a -> Maybe a) -> Int -> Map k a -> Map k a|}

|O(log n).| Actualizar el elemento del índice. Se lanza una error cuando el índice no es válido.
\begin{hs}
\small
\begin{code}
 updateAt (\ _ _ -> Just "x") 0    (fromList [(5,"a"), (3,"b")]) == fromList [(3, "x"), (5, "a")]
 updateAt (\ _ _ -> Just "x") 1    (fromList [(5,"a"), (3,"b")]) == fromList [(3, "b"), (5, "x")]
 updateAt (\ _ _ -> Just "x") 2    (fromList [(5,"a"), (3,"b")])    Error: index out of range
 updateAt (\ _ _ -> Just "x") (-1) (fromList [(5,"a"), (3,"b")])    Error: index out of range
 updateAt (\_ _  -> Nothing)  0    (fromList [(5,"a"), (3,"b")]) == singleton 5 "a"
 updateAt (\_ _  -> Nothing)  1    (fromList [(5,"a"), (3,"b")]) == singleton 3 "b"
 updateAt (\_ _  -> Nothing)  2    (fromList [(5,"a"), (3,"b")])    Error: index out of range
 updateAt (\_ _  -> Nothing)  (-1) (fromList [(5,"a"), (3,"b")])    Error: index out of range
\end{code}
\end{hs}

\subsection{|deleteAt :: Int -> Map k a -> Map k a|}

|O(log n).| Eliminar el elemento del índice. Definido como \newline (|deleteAt i map = updateAt (k x -> Nothing) i map|).
\begin{hs}
\small
\begin{code}
deleteAt 0  (fromList [(5,"a"), (3,"b")]) == singleton 5 "a"
deleteAt 1  (fromList [(5,"a"), (3,"b")]) == singleton 3 "b"
deleteAt 2 (fromList [(5,"a"), (3,"b")])     Error: index out of range
deleteAt (-1) (fromList [(5,"a"), (3,"b")])  Error: index out of range
\end{code}
\end{hs}

