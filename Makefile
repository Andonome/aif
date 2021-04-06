filename=main
branch := $(shell git rev-parse --abbrev-ref HEAD)
output: ${filename}.pdf
${filename}.pdf: ${filename}.ind ${filename}.glg
svg-inkscape:
	pdflatex -shell-escape ${filename}.tex
${filename}.ind: svg-inkscape ${filename}.idx $(wildcard *.tex)
	pdflatex ${filename}.tex
	makeindex ${filename}.idx
${filename}.glg: svg-inkscape
	pdflatex ${filename}.tex
	makeglossaries ${filename}
	pdflatex ${filename}.tex
guide:
	pdflatex -shell-escape players_guide.tex
	makeindex players_guide.idx
	pdflatex players_guide.tex
	pdflatex players_guide.tex
	pdflatex players_guide.tex
all:
	make clean
	make guide
	make
tree:
	[ -e ../config ] || ( echo "You don't have a local config repo" && exit 1 )
	git status
	git subtree -P config pull ../config ${branch}
clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape
