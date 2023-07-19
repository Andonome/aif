BOOK = $(shell basename "$$(pwd)")
output: $(BOOK).pdf

global: config/bind.sty .switch-gls
.switch-gls:
	@touch -r Makefile .switch-gls
config/bind.sty:
	@git submodule update --init

svg-inkscape: | config/bind.sty
	@pdflatex -shell-escape -jobname $(BOOK) main.tex
$(BOOK).glo: | svg-inkscape
	@pdflatex -jobname $(BOOK) main.tex
$(BOOK).sls: | $(BOOK).glo
	@makeglossaries $(BOOK)
$(BOOK).pdf: $(BOOK).sls $(wildcard *.tex) $(wildcard config/*.sty)
	@pdflatex -jobname $(BOOK) main.tex

players_guide.pdf:
	pdflatex -shell-escape players_guide.tex
	pdflatex players_guide.tex
	pdflatex players_guide.tex
all: $(BOOK).pdf  players_guide.pdf
	latexmk -jobname=$(BOOK) -shell-escape -pdf main.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

clean:
	rm -fr *.aux *.sls *.slo *.slg *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf sq/*aux svg-inkscape

.PHONY: clean all
