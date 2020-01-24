#!/bin/sh
if [ ! -z $1 ]; then
	git status
	git subtree -P config pull ../config master
	git subtree -P config push ../config aif
fi
pdflatex -shell-escape main.tex
makeglossaries main
makeglossaries main.idx
pdflatex main.tex
