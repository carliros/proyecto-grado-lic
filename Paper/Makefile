
all: lhs
	pdflatex hsbrowser.tex
	bibtex hsbrowser
	pdflatex hsbrowser.tex
	pdflatex hsbrowser.tex
	evince hsbrowser.pdf &

lhs:
	lhs2TeX --poly hsbrowser.lhs -o hsbrowser.tex

clean:
	rm -f *.pdf *.ps *.bbl *.log *.aux *.toc *.out *.blg *~ *.tex *.bak *.lot *.lof *.ltg *.ptb *.lac *.ldt *.lhc

