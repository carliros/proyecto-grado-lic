
all: FunctionalWebBrowser.pdf

FunctionalWebBrowser.pdf: examples lhs2tex force
	pdflatex 001-principal-Principal.tex
	bibtex 001-principal-Principal
	pdflatex 001-principal-Principal.tex
	pdflatex 001-principal-Principal.tex
	mv 001-principal-Principal.pdf Lic-Informatica_11-07-11_ProyectoDeGrado_DesarrolloDeNavegadorWebConHaskell.pdf


examples:
	lhs2TeX --verb 022-ejemplo-ejemplo001.lhs -o 022-ejemplo-ejemplo001.tex
	lhs2TeX --verb 023-ejemplo-ejemplo002.lhs -o 023-ejemplo-ejemplo002.tex
	lhs2TeX --verb 024-ejemplo-ejemplo003.lhs -o 024-ejemplo-ejemplo003.tex
	lhs2TeX --verb 025-ejemplo-ejemplo004.lhs -o 025-ejemplo-ejemplo004.tex
	lhs2TeX --verb 026-ejemplo-ejemplo005.lhs -o 026-ejemplo-ejemplo005.tex
	lhs2TeX --verb 027-ejemplo-ejemplo006.lhs -o 027-ejemplo-ejemplo006.tex
	lhs2TeX --verb 028-ejemplo-ejemplo007.lhs -o 028-ejemplo-ejemplo007.tex
	lhs2TeX --verb 029-ejemplo-ejemplo008.lhs -o 029-ejemplo-ejemplo008.tex
	lhs2TeX --verb 030-ejemplo-ejemplo009.lhs -o 030-ejemplo-ejemplo009.tex
	lhs2TeX --verb 031-ejemplo-ejemplo010.lhs -o 031-ejemplo-ejemplo010.tex
	lhs2TeX --verb 032-ejemplo-ejemplo011.lhs -o 032-ejemplo-ejemplo011.tex
	lhs2TeX --verb 033-ejemplo-ejemplo012.lhs -o 033-ejemplo-ejemplo012.tex
	lhs2TeX --verb 034-ejemplo-ejemplo013.lhs -o 034-ejemplo-ejemplo013.tex
	lhs2TeX --verb 035-ejemplo-ejemplo014.lhs -o 035-ejemplo-ejemplo014.tex
	lhs2TeX --verb 036-ejemplo-ejemplo015.lhs -o 036-ejemplo-ejemplo015.tex
	lhs2TeX --verb 037-ejemplo-ejemplo016.lhs -o 037-ejemplo-ejemplo016.tex
	lhs2TeX --verb 038-ejemplo-ejemplo017.lhs -o 038-ejemplo-ejemplo017.tex
	lhs2TeX --verb 039-ejemplo-ejemplo018.lhs -o 039-ejemplo-ejemplo018.tex
	lhs2TeX --verb 040-ejemplo-ejemplo019.lhs -o 040-ejemplo-ejemplo019.tex
	lhs2TeX --verb 041-ejemplo-ejemplo020.lhs -o 041-ejemplo-ejemplo020.tex
	lhs2TeX --verb 042-ejemplo-ejemplo021.lhs -o 042-ejemplo-ejemplo021.tex
	lhs2TeX --verb 043-ejemplo-ejemplo022.lhs -o 043-ejemplo-ejemplo022.tex
	lhs2TeX --verb 044-ejemplo-ejemplo023.lhs -o 044-ejemplo-ejemplo023.tex
	lhs2TeX --verb 045-ejemplo-ejemplo024.lhs -o 045-ejemplo-ejemplo024.tex
	lhs2TeX --verb 046-ejemplo-ejemplo025.lhs -o 046-ejemplo-ejemplo025.tex
	lhs2TeX --verb 047-ejemplo-ejemplo026.lhs -o 047-ejemplo-ejemplo026.tex
	lhs2TeX --verb 048-ejemplo-ejemplo027.lhs -o 048-ejemplo-ejemplo027.tex
	lhs2TeX --verb 049-ejemplo-ejemplo028.lhs -o 049-ejemplo-ejemplo028.tex
	lhs2TeX --verb 050-ejemplo-ejemplo029.lhs -o 050-ejemplo-ejemplo029.tex
	lhs2TeX --verb 051-ejemplo-ejemplo030.lhs -o 051-ejemplo-ejemplo030.tex
	lhs2TeX --verb 052-ejemplo-ejemplo031.lhs -o 052-ejemplo-ejemplo031.tex
	lhs2TeX --verb 053-ejemplo-ejemplo032.lhs -o 053-ejemplo-ejemplo032.tex
	lhs2TeX --verb 054-ejemplo-ejemplo032.lhs -o 054-ejemplo-ejemplo032.tex
	lhs2TeX --verb 055-ejemplo-ejemplo033.lhs -o 055-ejemplo-ejemplo033.tex
	lhs2TeX --verb 056-ejemplo-ejemplo034.lhs -o 056-ejemplo-ejemplo034.tex

lhs2tex:
	lhs2TeX --poly 002-caratula-Caratula.lhs -o 002-caratula-Caratula.tex
	lhs2TeX --poly 003-dedicatoria-Dedicatoria.lhs -o 003-dedicatoria-Dedicatoria.tex
	lhs2TeX --poly 004-agradecimientos-Agradecimientos.lhs -o 004-agradecimientos-Agradecimientos.tex
	lhs2TeX --poly 005-resumen-Resumen.lhs -o 005-resumen-Resumen.tex
	lhs2TeX --poly 006-cap01-Introduccion.lhs -o 006-cap01-Introduccion.tex
	lhs2TeX --poly 007-cap02-MarcoTeorico.lhs -o 007-cap02-MarcoTeorico.tex -u showChanges
	lhs2TeX --poly 008-cap03-Gramaticas.lhs -o 008-cap03-Gramaticas.tex -u showChanges
	lhs2TeX --poly 009-cap04-ParsingHtml.lhs -o 009-cap04-ParsingHtml.tex -u showChanges
	lhs2TeX --poly 010-cap05-ParsingCss.lhs -o 010-cap05-ParsingCss.tex -u showChanges
	lhs2TeX --poly 011-cap06-AsignacionDeValoresAPropiedades.lhs -o 011-cap06-AsignacionDeValoresAPropiedades.tex -u showChanges
	lhs2TeX --poly 012-cap07-EstructuraFormato.lhs -o 012-cap07-EstructuraFormato.tex -u showChanges
	lhs2TeX --poly 013-cap08-PropiedadesCss.lhs -o 013-cap08-PropiedadesCss.tex
	lhs2TeX --poly 014-cap09-CssBoxModel.lhs -o 014-cap09-CssBoxModel.tex -u showChanges
	lhs2TeX --poly 015-cap10-Gui.lhs -o 015-cap10-Gui.tex -u showChanges
	lhs2TeX --poly 016-cap11-Conclusiones.lhs -o 016-cap11-Conclusiones.tex
	lhs2TeX --poly 017-apendice01-ParsingTutorial.lhs -o 017-apendice01-ParsingTutorial.tex
	lhs2TeX --poly 018-apendice02-AGTutorial.lhs -o 018-apendice02-AGTutorial.tex
	lhs2TeX --poly 019-apendice03-Map.lhs -o 019-apendice03-Map.tex
	lhs2TeX --poly 020-apendice04-UserAgent.lhs -o 020-apendice04-UserAgent.tex
	lhs2TeX --poly 001-principal-Principal.lhs -o 001-principal-Principal.tex

clean:
	-rm -f *.pdf *.ps *.bbl *.log *.aux *.toc *.out *.blg *~ *.tex *.bak *.lot *.lof *.ltg *.ptb *.lac *.ldt *.lhc

bib : 

.PHONY : force

