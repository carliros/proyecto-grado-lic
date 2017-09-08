
%include lhs2TeX.fmt

\begin{code}
f <$> p = pReturn f   <*> p
f <$  p = const   f   <$> p
p <*  q = (\x _ -> x) <$> p <*> q
p *>  q = (\_ x -> x) <$> p <*> q
\end{code}
