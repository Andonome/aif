#!/bin/bash
if [ $1 = clean ]; then
	rm -r *aux *log main.{i,g}* *toc *.ptc *.out svg-inkscape 2>/dev/null
	exit 0
fi

if [ $1 = tree ]; then
	git status
	git subtree -P config pull ../config master
	git subtree -P config push ../config aif
fi
pdflatex -shell-escape main.tex
makeglossaries main
makeindex main.idx
pdflatex main.tex
