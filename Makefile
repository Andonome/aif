output: main.pdf


main.pdf: main.aux config
	pdflatex main.tex
main.aux: svg-inkscape
	pdflatex main.tex
	makeglossaries main
svg-inkscape: config/bind.sty images
	pdflatex -shell-escape main.tex
	pdflatex main.tex

config/bind.sty:
	git submodule update --init

handouts: handouts.pdf
handouts.pdf:
	pdflatex -shell-escape handouts.tex
	pdflatex handouts.tex

guide: players_guide.pdf fenestra.tex nightguard.tex astronomy.tex history.tex players_guide.tex
	pdflatex players_guide.tex
players_guide.pdf:
	pdflatex -shell-escape players_guide.tex
	pdflatex players_guide.tex
	pdflatex players_guide.tex

creds:
	cd images && pandoc artists.md -o ../art.pdf

all: main.pdf guide handouts

clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf  *.slg  *.slo  *.sls  sq/*aux svg-inkscape
