output: main.pdf

book: main.pdf
	mv main.pdf Adventures_in_Fenestra.pdf
main.pdf: main.aux config $(wildcard *tex) sq
	pdflatex main.tex
main.aux: svg-inkscape
	pdflatex main.tex
	makeglossaries main
svg-inkscape: config/bind.sty images
	pdflatex -shell-escape main.tex
	pdflatex main.tex

config/bind.sty:
	git submodule update --init

handouts: handouts.pdf images/extracted/under_lost_city.svg
images/extracted/under_lost_city.svg: images/extracted
	inkscape images/Dyson_Logos/under_lost_city.svg --export-id-only --export-id=layer2 -l --export-filename images/extracted/under_lost_city.svg

images/extracted:
	mkdir -p images/extracted

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

all: book guide handouts

clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf  *.slg  *.slo  *.sls  sq/*aux svg-inkscape
