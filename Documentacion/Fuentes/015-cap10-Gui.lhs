
%include lhs2TeX.fmt

\chapter{Interfaz Gráfica de Usuario (GUI)} \label{chp:gui}

%\section{Introducción}

%if showChanges
\color{blue}
%endif


En este capítulo se mostrará el desarrollo de la interfaz gráfica de usuario (GUI) para 
el Navegador Web.\\

La interfaz gráfica de usuario, en primer lugar, se encarga de integrar todos los módulos que 
se ha desarrollado en el proyecto. 

Además, la interfaz gráfica de usuario provee los mecanismos de interacción entre el usuario 
y la página Web. Por ejemplo, si el usuario quiere navegar por una página Web, el GUI debe 
proveer un lugar donde el usuario pueda escribir la dirección URL de la página Web.
Y si desde una página Web, el usuario desea seguir un enlace para ir a otra
página Web, el GUI también debe proveer la forma de hacer un clic en un enlace
y cargar la nueva página Web. Finalmente si el usuario desea volver a una página Web
en la que navegó anteriormente, entonces el GUI también debe proveer alguna forma de recargar alguna
página ya visitada.\\

En el \pref{chp:pselector} (\pref{sec:obtenerHEst}), cuando se obtenía todas las hojas se estilo, 
se mencionó la existencia de 3 autores: |UserAgent, User y Author|. El autor |User|, que corresponde
al que maneja el Navegador Web, debe tener la capacidad de añadir reglas de estilo. 
\newline
Entonces, además de la interacción usuario-página Web, el GUI también debe proveer una forma
de añadir reglas de estilo para el usuario |User|.\\

De esa manera, en el presente capítulo se presenta del desarrollo de la Interfaz Gráfica de Usuario para
el proyecto.\\

Así mismo, se utilizará la librería |WxHaskell| \cite{wxhaskell} para el desarrollo del GUI.\\

Se inicia el capítulo con el desarrollo una interfaz gráfica de usuario sin acciones y a medida 
que se vaya avanzando, se añadirá acciones para los botones y menús.

%if showChanges
\color{black}
%endif

\section{Interfaz Gráfica de Usuario Básica}
En esta sección se definirá una interfaz gráfica de usuario sin acciones.\\

Para ello se define las funciones principales para |WxHaskell| e interfaz gráfica de usuario.
El \pref{lhc:main} muestra las funciones principales.

\begin{hs}
\small
\begin{code}
main :: IO()
main = start browser

browser :: IO()
browser
    = do ...
\end{code}
\caption{Funciones principales del GUI} \label{lhc:main}
\end{hs}

En la función |browser| del \pref{lhc:main} se definirá todos los componentes del GUI.

\subsection{Variables de WxHaskell}

Se utiliza las variables de |WxHaskell| para almacenar información relevante para el Navegador Web.\\

Por ejemplo ha definido las siguientes variables:
\begin{itemize}
\item Variable |sfiles|: guarda la lista de nombres de archivos de hojas de estilo.

\begin{hs}
\small
\begin{code}
    lfiles              <- readConfigFile
    sfiles              <- variable [value := lfiles]
\end{code}
\end{hs}

\item Variable |varfstree|: guarda la estructura |FSTressFase1| en un tipo |Maybe|. Inicialmente es |Nothing|.

\begin{hs}
\small
\begin{code}
    varfstree           <- variable [value := Nothing]
\end{code}
\end{hs}

\item Variable |varzipper|: guarda a lista de páginas de navegación (necesario para ir adelante y atrás).

\begin{hs}
\small
\begin{code}
    varzipper           <- variable [value := initZipperList]
\end{code}
\end{hs}

\item Variable |varbaseurl|: guarda el |url| base de una página Web. Inicialmente es |""|.

\begin{hs}
\small
\begin{code}
    varbaseurl          <- variable [value := ""]
\end{code}
\end{hs}

\item Variable |varDefaultCSS4html|: guarda la hoja de estilos del |UserAgent|.

\begin{hs}
\small
\begin{code}
    defaultcss4html     <- parseFileUserAgent $ maybe "" id $  Map.lookup 
                                                               "User_Agent_Stylesheet" 
                                                               lfiles
    varDefaultCSS4Html  <- variable [ value := defaultcss4html]
\end{code}
\end{hs}
\end{itemize}

\subsection{Ventanas y Botones}

La ventana principal del Navegador Web es una ventana de tipo |Frame|, que es definida
con la función |frame| de WxHaskell:

\begin{hs}
\small
\begin{code}
    f <- frame [text := "Simple San Simon Functional Web Browser"]
\end{code}
\end{hs}

También se define la ventana donde se renderizará las páginas Web, este tiene un tamaño virtual de |800*600|:

\begin{hs}
\small
\begin{code}
    pnl <- scrolledWindow f [virtualSize := sz 800 600]
\end{code}
\end{hs}

Luego se define los botones principales con los que interactuará el usuario: un widget |inp| donde se escribirá el |url|,
un botón |get| para obtener la página Web, un botón |upd| para actualizar la página Web, y los botones
|goForward| y |goBackward| para la navegación entre páginas.

%format ">>=" = "\char34 \bind  \char34"
%format "=<<" = "\char34 \rbind \char34"
%%format "=<<" = "\text{\tt \char34 " "\rbind" "\char34}"

\begin{hs}
\small
\begin{code}
    inp         <- entry  f  [ text := "file:///home/carlos/fwb/test1.html"]
    get         <- button f  [ text := "Get"]
    upd         <- button f  [ text := "Update"]
    goForward   <- button f  [ text := ">>=", size := sz 50 (-1)]
    goBackward  <- button f  [ text := "=<<", size := sz 50 (-1)]
\end{code}
\end{hs}

\subsection{El menú principal}

Para crear el menú principal, se ha definido la función |createMenus|, que se encarga de crear todos 
los menús del Navegador Web:

\begin{hs}
\small
\begin{code}
    createMenus f sfiles varzipper inp pnl varfstree varDefaultCSS4Html varbaseurl
\end{code}
\end{hs}

La función |createMenus| está definido de la siguiente manera:
\begin{hs}
\small
\begin{code}
createMenus f sfiles varzipper inp pnl varfstree varDefaultCSS4Html varbaseurl
    = do  -- panel browser
          pbrowser   <- menuPane [text := "Browser"]
          mgetPage   <- menuItem pbrowser  [ text := "Get a Web Page\tCtrl+g"
                                           , on command := windowSetFocus inp
                                           ]
          mgoFord    <- menuItem pbrowser [ text := "Go Forward\tCtrl+f"]
          mgoBack    <- menuItem pbrowser [ text := "Go Backward\tCtrl+b"]
          menuLine pbrowser
          mclose     <- menuQuit pbrowser [text := "Close", on command := close f]
          -- panel settings
          psettings  <- menuPane [text := "Settings"]
          muserS     <- menuItem psettings [ text := "User Stylesheet"]
          magentS    <- menuItem psettings [ text := "User Agent Stylesheet"]
\end{code}
\end{hs}
\begin{hs}
\small
\begin{code}
          -- panel help
          phelp      <- menuPane [text := "Help"]
          menuAbout phelp [text := "About", on command := infoDialog f "About" about]
          -- set the menus on the frame
          set f [ menuBar := [pbrowser, psettings, phelp] ]
\end{code}
\end{hs}



\subsection{El \textit{layout} del Navegador Web}

El esquema para la ventana principal del Navegador Web tiene dos partes:
\begin{itemize}
    \item Panel de interacción: es el lugar donde están los botones principales para interactuar
          con el Navegador Web. Por ejemplo se tiene al widget donde se coloca el |url|, los botones
          para obtener y actualizar la página Web.
    \item Panel del renderización: es el lugar donde se renderizan las páginas Web. Ocupa
          la mayor parte de la ventana principal.
\end{itemize}

La implementación del esquema (|layout|) es de la siguiente manera:
\begin{hs}
\small
\begin{code}
    set f  [ layout := column 5  [ row 5    [ widget goBackward, widget goForward, hspace 10
                                            , centre $ label "URL:", hfill $ widget inp
                                            , widget up, widget go
                                            ]
                                 , fill $ widget pnl
                                 ]
           ]
\end{code}
\end{hs}

A continuación se muestra la imagen de la GUI desarrollada hasta esta parte:

\begin{figure}[H]
\begin{center}
    \scalebox{0.4}{\includegraphics{078-figura-figura021.jpg}}
\end{center}
\end{figure}

\section{Descargar Recursos de la Web} \label{sec:download}

En esta sección se desarrollará un módulo que interactué con los protocolos HTTP y File para
descargar recursos de la Web.\\

Los recursos que se necesita descargar son: archivos HTML, hojas de estilo e imágenes.\\

Para descargar los recursos de la Web se está utilizando la librería \libcurl. LibCurl \cite{curl} es una librería
que permite interactuar con varios protocolos a través de una dirección |URL|.
Entre los protocolos con los que interactúa están los protocolos HTTP y File, los cuales son
necesarios para el proyecto.

\subsection{Descargar un documento HTML}

Para descargar un archivo HTML se ha definido la función |getContenidoURL| del \pref{lhc:getContenidoURL} que recibe un |URL| en un |String|
y devuelve una tupla, donde el primer elemento es el |URL| y el segundo elemento es un |String| que representa
el contenido de la página Web.\\

Para descargar el archivo se está utilizando la función |curlGetResponse_| de la librería LibCurl.\\

Si ocurre algún error en la descarga, se devuelve la dirección |URL| y una página HTML que muestre el error.
Pero si la descarga tiene éxito, entonces se crea un nuevo proceso para descargar tanto las imágenes
y hojas de estilo. Luego se devuelve la dirección |url| y el contenido HTML que se ha descargado.

\begin{hs}
\small
\begin{code}
getContenidoURL :: String -> IO (String, String)
getContenidoURL url
    =  do   (CurlResponse cCode _ _ _ content fvalue) <- getResponse url
            putStrLn $ show cCode ++ " at " ++ url
            (IString eurl) <- fvalue EffectiveUrl
            if cCode == CurlOK
                then  do    let base = URL.getBaseUrl eurl
                            forkIO (downloadImages base content)
                            forkIO (downloadHTMLStyleSheet base content)
                            return (eurl,content)
                else return $ (url,pageNoDisponible (show cCode) url)

getResponse :: String -> IO (CurlResponse_ [(String, String)] String)
getResponse url = curlGetResponse_ url []

pageNoDisponible :: String -> String -> String
pageNoDisponible error link 
    = "<html> error page ... "
\end{code}
\caption{Función para descargar el contenido de una dirección URL} \label{lhc:getContenidoURL}
\end{hs}

\subsection{Descargar imágenes}

En la anterior sección, después que la descarga tenía éxito, se procedía a crear un nuevo proceso para descargar las imágenes,
en ese nuevo proceso se llamaba a la función |downloadImages|, la cual recibía el |URL| base de la página Web y el contenido
del HTML. 

En esta sección se describirá la función |downloadImages|.\\

Para descargar las imágenes, además de la librería LibCurl, también se está utilizando otras librerías de Haskell:

\begin{itemize}
    \item |GD|\cite{lgd}: Se utiliza para convertir el contenido de una imagen (|String|) descargada de la Web en un archivo de 
          imagen con formato específico.
    \item |TagSoup|\cite{ltagsoup}: Se utiliza para buscar el |URL| de las imágenes a descargar en el contenido de una página Web.
    \item |URL|\cite{lurl}: Se utiliza para hacer operaciones sobre una dirección |URL| (por ejemplo, encontrar el |URL| base).
\end{itemize}

Lo primero que se realiza para descargar las imágenes es obtener las |URLs| de las imágenes a descargar. Luego se elimina
todas las |URL| que son repetidas (para no tener que descargar más de dos veces una imagen). Finalmente, se asigna
las funciones correspondientes para convertir las imágenes descargadas a un determinado tipo de imagen.\\

El \pref{lhc:getImagenes} y 91 muestran la implementación de la función |downloadImages|, la cual se encarga de descargar 
todas las imágenes de una página Web.\\

\begin{hs}
\small
\begin{code}
downloadImages base stringHTML 
    = do  let  imgTags  =  [  fromAttrib "src" tag
                           |  tag <- parseTags stringHTML
                           ,  tagOpen (=="img") (anyAttrName (== "src")) tag
                           ]
               imgSRCs  = nub imgTags  -- elimina los repetidos
               imgfuns  = map getImageFunctionNameType imgSRCs
          mapM_ downloadprocess imgfuns
    where  downloadprocess (url,name,fload,fsave)
                =  do  img     <- download base url
                       gdimg   <- fload img
                       let path = tmpPath ++ name
                       fsave path gdimg
                       putStrLn $ "image saved at " ++ path

download base url 
    = do    let url' =  if URL.isAbsolute url
                        then url
                        else    if URL.isHostRelative url
                                then base        ++ url
                                else base ++ "/" ++ url
            (cod,obj) <- curlGetString_ url' []
            putStrLn $ show cod ++ " at " ++ url'
            return obj
\end{code}
\caption{Funciones para descargar imágenes, parte 1} \label{lhc:getImagenes}
\end{hs}

\begin{hs}
\small
\begin{code}
getImageFunctionNameType url 
    =  let name = takeFileName url
       in case takeExtension url of
            ".jpg"      ->  (url, name, loadJpegByteString, saveJpegFile (-1))
            ".png"      ->  (url, name, loadPngByteString , savePngFile)
            ".gif"      ->  (url, name, loadGifByteString , saveGifFile)
            otherwise   ->  error $ "[DownloadProcess] error with ..."
\end{code}
\caption{Funciones para descargar imágenes, parte 2} \label{lhc:getImagenes2}
\end{hs}

Se ha definido un directorio común (|./tmp/| del ejecutable) para guardar todas las imágenes descargadas.

La función |download| del \pref{lhc:getImagenes} se encarga de descargar un recurso desde la Web. 
Pero antes de proceder a descargar hace ciertas operaciones para tener una dirección |URL| absoluta 
(dirección completa o entera del recurso a descargar).\\

La función |getImageFunctionNameType| del \pref{lhc:getImagenes2} asigna las funciones correspondientes para convertir
la imagen descargada (|String|) en un archivo de imagen. Note que sólo se reconocen 3 tipos de formato de imagen:
JPG, PNG y GIF.

\subsection{Descargar Hojas de Estilo}
El proceso de descargar hojas de estilo es básicamente el mismo que para descargar imágenes. La única diferencia
es que ya no se necesita funciones de conversión entre un |String| y el archivo de imagen, porque se descarga un
archivo de texto plano. Otra de las diferencias es que la dirección |URL| para descargar se encuentra en los 
elementos |link| de la página Web.



\section{El proceso de Renderización} \label{sec:procR}

En esta sección se describirá el proceso de renderización de una página Web. También se define las acciones para los 
botones |get| y |update| de la interfaz gráfica de usuario.\\

El proceso de renderización comprende los siguiente pasos:
\begin{enumerate}
    \item Obtener la dirección |URL| de la página Web que se quiere renderizar.
    \item Descargar el contendido del |URL|.
    \item Parsear el contenido del |URL|.
    \item Procesar el |NTree| y generar el |FSTree|.
    \item Procesar la estructura de formato fase 1.
    \item Procesar la estructura de formato fase 2.
    \item Limpiar la ventana por si existe alguna otra página Web renderizada.
    \item Renderizar la página Web en la ventana.
\end{enumerate}

Otra de las acciones importantes de un Navegador Web, aparte de renderizar una página Web, es el de actualizar una 
página Web ya existente. La actualización no sólo puede ser generada por
el botón |update|, sino también por el redimensionamiento de la ventana principal o cuando el Navegador
Web lo requiera.

La actualización de una página Web no necesita realizar todo el proceso de renderización descrita en la anterior lista, 
sino que solamente lo correspondiente a redimensionar, es decir desde el paso 5.\\

Entonces, para hacer posible la acción de actualizar se ha definido una variable de |WxHaskell| denominada: |varfstree|.
La variable |varfstree| guarda el resultado de procesar el |NTree|, de manera que, no se tenga que volver a procesarlo
cuando se tenga que actualizar la página Web.\\

A continuación se describen las funciones de renderización y actualización de páginas Web.

\subsection{Renderizar una página Web} \label{sec:rendPW}

Así como se describió en la sección anterior, el primer paso para renderizar, es obtener la dirección |URL| de la página Web.
Para lo cual, se ha definido una función que obtenga el texto del |widget entry| 
y llame a otra función para renderizar la dirección |URL|:

\begin{hs}
\small
\begin{code}
renderPage pnl inp varfstree varzipper varDefaultCSS4Html varbaseurl
    =  do   url <- get inp text
            goToURL pnl inp varfstree varzipper varDefaultCSS4Html varbaseurl url
\end{code}
\end{hs}

La función |goToURL| se encarga de renderizar el |URL| que recibe como parámetro:

\begin{hs}
\small
\begin{code}
goToURL pnl inp varfstree varzipper varDefaultCSS4Html varbaseurl url 
    = do ...
\end{code}
\end{hs}

Lo primero que se realiza, es obtener el contenido del URL:
\begin{hs}
\small
\begin{code}
    (eurl,content) <- getContenidoURL url
\end{code}
\end{hs}

Luego, se obtiene el |URL| base y se guarda en la variable |varbaseurl|:
\begin{hs}
\small
\begin{code}
    let baseurl = getBaseUrl eurl
    set varbaseurl [value := baseurl]
\end{code}
\end{hs}

Seguidamente, se actualiza el |widget entry| con el |URL| devuelto por la función 
\newline
|getContenidoURL|.
También se actualiza la lista de navegación de páginas con el nuevo |URL| que se está renderizando:

\begin{hs}
\small
\begin{code}
    set inp [text := eurl]

    -- inserting into the historial
    zipper <- get varzipper value
    let newzipper = insert url zipper
    set varzipper [value := newzipper]
\end{code}
\end{hs}

Lo siguiente es ``parsear'' el contenido del |URL|:
\begin{hs}
\small
\begin{code}
    ast <- parseHTML content
\end{code}
\end{hs}

Luego se debe procesar el |NTree| y generar la estructura de formato. El resultado de esta parte,
es guardado en la variable |varfstree|:

\begin{hs}
\small
\begin{code}
    defaultcss4html <- get varDefaultCSS4Html value
    let fstree = genFormattingEstructure ast defaultcss4html
    set varfstree [value := fstree]
\end{code}
\end{hs}

Finalmente, se llama a la función |updateInitialContainer| y se repinta el panel de renderización:

\begin{hs}
\small
\begin{code}
    updateInitialContainer pnl inp varfstree varzipper varDefaultCSS4Html varbaseurl
    repaint pnl
\end{code}
\end{hs}

La función |updateInitialContainer| se encarga de procesar la estructura de formato que 
se encuentra en la variable |varfstree|:

\begin{hs}
\small
\begin{code}
updateInitialContainer icb inp varfstree varzipper varDefaultCSS4Html varbaseurl
    = do ...
\end{code}
\end{hs}

Lo primero es limpiar la ventana de renderización (por si existe una página ya renderizada) y
se posiciona la barra de desplazamiento en la parte inicial:

\begin{hs}
\small
\begin{code}
    windowDestroyChildren icb
    scrolledWindowScroll icb (pt 0 0)
\end{code}
\end{hs}

Luego se recolecta la información necesaria para procesar la estructura de formato:

\begin{hs}
\small
\begin{code}
    (Size w h) <- windowGetClientSize icb
    baseurl <- get varbaseurl value
\end{code}
\end{hs}

Y se obtiene la estructura de formato de la variable |varfstree|:

\begin{hs}
\small
\begin{code}
    result <- get varfstree value
\end{code}
\end{hs}

Si el contenido de la variable es |Nothing| no se realiza nada, caso contrario se procesa el |fstree|:

\begin{hs}
\small
\begin{code}
    case result of
        (Just fstree)  -> do  let  boxtree 
                                        = processFSTree1 fstree icb (w,h)
                                   (_,fresult, (wc,hc)) 
                                        = processFSTree2    boxtree
                                                            baseurl 
                                                            icb 
                                                            (goToURL    icb 
                                                                        inp 
                                                                        varfstree 
                                                                        varzipper 
                                                                        varDefaultCSS4Html 
                                                                        varbaseurl)
                              fresult icb
                              sw <- get icb size
                              let ns@(Size nw nh) = sizeMax sw (sz wc hc)
                              set icb [virtualSize := ns, scrollRate := sz (nw `div` 100) (nh `div` 100) ]
        Nothing        -> return ()
\end{code}
\end{hs}

Después de procesar la estructura de formato se hace ciertas operaciones para configurar
la barra de desplazamiento del panel de renderización.

\subsection{Acciones para los botones de la interfaz gráfica}

A continuación se asignará las acciones para los botones |Get| y |Update| de la interfaz gráfica de usuario.\\

Cuando se hace clic en el botón |Get|, simplemente se llama a la función para renderizar la página Web:
\begin{hs}
\small
\begin{code}
set get [on command := renderPage   pnl 
                                    inp 
                                    varfstree 
                                    varzipper 
                                    varDefaultCSS4Html 
                                    varbaseurl]
\end{code}
\end{hs}

Si se hace clic en el botón |Update| se llama a la función |updateInitialContainer|:

\begin{hs}
\small
\begin{code}
set upd [on command := updateInitialContainer   pnl 
                                                inp 
                                                varfstree 
                                                varzipper 
                                                varDefaultCSS4Html 
                                                varbaseurl]
\end{code}
\end{hs}

Si la ventana principal cambia sus dimensiones, también se llamar a la función 
\newline
|updateInitialContainer| para redimensionar la página Web:

\begin{hs}
\small
\begin{code}
set pnl [ on resize := updateInitialContainer   pnl 
                                                inp 
                                                varfstree 
                                                varzipper 
                                                varDefaultCSS4Html 
                                                varbaseurl ]
\end{code}
\end{hs}

Finalmente, si se presiona la tecla |enter| en el |widget entry|, se debe renderizar la página sin 
necesidad de hacer clic en el botón |Get|:

\begin{hs}
\small
\begin{code}
set inp [on enterKey := renderPage  pnl 
                                    inp 
                                    varfstree 
                                    varzipper 
                                    varDefaultCSS4Html 
                                    varbaseurl]
\end{code}
\end{hs}

\section{Acciones para los botones \textit{goForward} y \textit{goBackward}}

En esta sección se definirá la funcionalidad para la navegación de páginas visitadas.

\subsection{El módulo |ZipperList|}

Para navegar entre las páginas Web visitadas se ha desarrollado el módulo |ZipperList| el cual define funciones
para navegar sobre una lista de páginas Web.\\

Las funciones que tiene el módulo |ZipperList| son:

\begin{itemize}
    \item |forward|: Obtiene un elemento que se encuentra a la derecha del elemento actual de la lista.
    \item |backward|: Obtiene un elemento que se encuentra a la izquierda del elemento actual de la lista.
    \item |insert|: Inserta un |url| a la izquierda del elemento actual de la lista.
    \item |getElement|: Obtiene el |url| donde apunta el elemento actual de la lista.
    \item |initZipperList|: Inicializa el |ZipperList|.
\end{itemize}

\subsection{Configurar las acciones}

Para configurar las acciones |goForward| y |goBackward| se ha definido la función 
\newline
|onButtonHistorial|, 
que recibe una acción (|fmove|) de |ZipperList|, la variable |varzipper| (que guarda el |ZipperList|) y 
otros argumentos necesarios para la renderización:

\begin{hs}
\small
\begin{code}
onButtonHistorial fmove varzipper inp pnl varfstree varDefaultCSS4Html varbaseurl
    =  do   zipper <- get varzipper value
            let newzipper = fmove zipper
            set varzipper [value := newzipper]
            set inp [text := getElement newzipper]
            renderPage  pnl
                        inp 
                        varfstree 
                        varzipper 
                        varDefaultCSS4Html 
                        varbaseurl
\end{code}
\end{hs}

La función |onButtonHistorial| primeramente obtiene el valor de la variable |varzipper|, 
aplica la función de movimiento sobre el |ZipperList|, actualiza la variable |varzipper|
y el |widget entry| con el nuevo valor y finalmente llama a la función |renderPage| para 
renderizar la página Web.\\

Con la función |onButtonHistorial| se puede configurar las acciones |backward| y |forward| tanto del
menú y botones de la interfaz:

En los menus:
\begin{hs}
\small
\begin{code}
set mgoFord  [ on command := onButtonHistorial  forward  
                                                varzipper 
                                                inp 
                                                pnl 
                                                varfstree 
                                                varDefaultCSS4Html 
                                                varbaseurl]
set mgoBack [ on command := onButtonHistorial   backward 
                                                varzipper 
                                                inp 
                                                pnl 
                                                varfstree 
                                                varDefaultCSS4Html 
                                                varbaseurl]
\end{code}
\end{hs}

En los botones:

\begin{hs}
\small
\begin{code}
set goForward [ on command := onButtonHistorial     forward  
                                                    varzipper 
                                                    inp 
                                                    pnl 
                                                    varfstree 
                                                    varDefaultCSS4Html 
                                                    varbaseurl]
set goBackward [ on command := onButtonHistorial    backward 
                                                    varzipper 
                                                    inp 
                                                    pnl 
                                                    varfstree 
                                                    varDefaultCSS4Html 
                                                    varbaseurl]
\end{code}
\end{hs}

\section{Archivos de hojas de estilo}

En esta sección se describe la funcionalidad para manipular las hojas de estilo
para el usuario |User| y |UserAgent|.

\subsection{Archivos de Configuración}

Se está utilizando un archivo de configuración que contiene las direcciones de los archivos 
que almacenan las hojas de estilo. Esto es realizado, con el objetivo de permitir que el Navegador Web
pueda recordar el archivo de hoja de estilo que estuvo utilizando antes que se cierre el
programa.

El archivo de configuración es bastante simple, su formato es:

\begin{hs}
\small
\input{055-ejemplo-ejemplo033}
\end{hs}

En la interfaz gráfica se ha definido la variable |sfiles| para almacenar la lista de archivos de hojas 
de estilo. El valor de |sfiles| es de tipo |Map String FilePath|, donde la clave es el nombre que representa
el archivo y su valor es el |path| de la hoja de estilo a la que hace referencia el nombre.\\

Entonces, cuando se inicia el programa, se lee el archivo de configuración para recordar la hoja de estilo
que se estaba utilizando:

\begin{hs}
\small
\begin{code}
    lfiles  <- readConfigFile
    sfiles  <- variable [value := lfiles]
\end{code}
\end{hs}

La función |readConfigFile| se encarga de leer el archivo de configuración y de convertirlo al tipo deseado
para la variable.

\subsection{Variable para las Hojas de Estilo}

También se está utilizando variables para guardar las hojas de estilo tanto de |UserAgent| y |User|.
Por ejemplo, la variable |varDefaultCSS4Html| guarda la estructura |HojaEstilo| de |UserAgent|.\\

Entonces, cuando se hace clic en el ítem |User Agent Stylesheet| del menú |Settings| se lanza una ventana para seleccionar un
archivo de hoja de estilo. Una vez que se selecciona el archivo, se modifica las variables y archivos correspondientes.

Por ejemplo, para el menú de |UserAgent|, se tiene:

\begin{hs}
\small
\begin{code}
set magentS [ on command := getUserAgentStylesheet]
\end{code}
\end{hs}

La función |getUserAgentStylesheet| modifica la variable |varDefaultCSS4Html|:

\begin{hs}
\small
\begin{code}
getUserAgentStylesheet 
    =   do  mf <- selectFile "User Agent Stylesheet"
            newStylesheet <-    case mf of
                                    Just path   -> parseFileUserAgent path
                                    Nothing     -> return $ Map.empty
            set varDefaultCSS4Html [value := newStylesheet]
\end{code}
\end{hs}

La función |selectFile| lanza la ventana para seleccionar el archivo de hoja de estilo, si
se selecciona un archivo, se debe modificar el archivo de configuración de hojas de estilo.

\begin{hs}
\small
\begin{code}
selectFile nm = do
        mf <- fileOpenDialog f True True ("Select " ++ nm) [("Stylesheet",["*.css"])] "" ""
        case mf of
                Just fn     ->  do  lf1 <- get sfiles value
                                    let  nmc     = concat $ List.intersperse "_" $ words nm
                                         lf2     = Map.insert nmc fn lf1
                                    writeConfigFile lf2
                Nothing     -> return ()
        return mf
\end{code}
\end{hs}


