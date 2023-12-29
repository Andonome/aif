BOOK = $(shell basename "$$(pwd)")
output: $(BOOK).pdf

global: config/bind.sty .switch-gls
.switch-gls:
	@touch -r Makefile .switch-gls
config/bind.sty:
	@git submodule update --init

svg-inkscape: | config/bind.sty
	@pdflatex -shell-escape -jobname $(BOOK) main.tex
$(BOOK).pdf: svg-inkscape $(wildcard *.tex) rumours/ caves/ config/
	@pdflatex -jobname $(BOOK) main.tex

all: $(BOOK).pdf
	latexmk -jobname=$(BOOK) -shell-escape -pdf main.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

clean:
	rm -fr *.aux *.sls *.slo *.slg *.toc *.acn *.log *.ptc *.out *.idx *.ist \
	*.glg *.gls *.acr *.alg *.ilg *.ind *.pdf \
	*glo \
	svg-inkscape \
	*.fls

.PHONY: clean all
